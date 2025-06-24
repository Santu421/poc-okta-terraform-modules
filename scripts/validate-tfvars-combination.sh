#!/bin/bash

# Script to validate .tfvars combinations at Terraform module level
# This script is owned by Engineering Team and enforces business rules

set -e

# Function to show usage
show_usage() {
    echo "Usage: $0 <app_folder>"
    echo ""
    echo "Validates .tfvars combinations for app deployment"
    echo "Enforces business rules for app type combinations"
    echo ""
    echo "Example:"
    echo "  $0 apps/FINANCE_EXPENSE_TRACKER"
}

# Function to check if .tfvars file exists
check_tfvars_exists() {
    local tfvars_file="$1"
    if [[ -f "$tfvars_file" ]]; then
        return 0
    else
        return 1
    fi
}

# Function to validate app type combinations
validate_app_combinations() {
    local app_folder="$1"
    
    echo "🔍 Validating .tfvars combinations for: $(basename "$app_folder")"
    echo ""
    
    # Check which .tfvars files exist
    local has_2leg=false
    local has_3leg_frontend=false
    local has_3leg_backend=false
    local has_3leg_native=false
    
    if check_tfvars_exists "$app_folder/2leg-api.tfvars"; then
        has_2leg=true
        echo "✅ Found: 2-leg API (.tfvars)"
    fi
    
    if check_tfvars_exists "$app_folder/3leg-frontend.tfvars"; then
        has_3leg_frontend=true
        echo "✅ Found: 3-leg Frontend (.tfvars)"
    fi
    
    if check_tfvars_exists "$app_folder/3leg-backend.tfvars"; then
        has_3leg_backend=true
        echo "✅ Found: 3-leg Backend (.tfvars)"
    fi
    
    if check_tfvars_exists "$app_folder/3leg-native.tfvars"; then
        has_3leg_native=true
        echo "✅ Found: 3-leg Native (.tfvars)"
    fi
    
    echo ""
    
    # Count 3-leg types
    local three_leg_count=0
    [[ "$has_3leg_frontend" == "true" ]] && ((three_leg_count++))
    [[ "$has_3leg_backend" == "true" ]] && ((three_leg_count++))
    [[ "$has_3leg_native" == "true" ]] && ((three_leg_count++))
    
    # Business Rule 1: Only one 3-leg type allowed
    if [[ $three_leg_count -gt 1 ]]; then
        echo "❌ Validation Failed: Multiple 3-leg app types detected"
        echo "   Only one 3-leg type is allowed per app"
        echo "   Found: $three_leg_count 3-leg types"
        return 1
    fi
    
    # Business Rule 2: At least one app type must be present
    local total_apps=0
    [[ "$has_2leg" == "true" ]] && ((total_apps++))
    [[ "$has_3leg_frontend" == "true" ]] && ((total_apps++))
    [[ "$has_3leg_backend" == "true" ]] && ((total_apps++))
    [[ "$has_3leg_native" == "true" ]] && ((total_apps++))
    
    if [[ $total_apps -eq 0 ]]; then
        echo "❌ Validation Failed: No app types found"
        echo "   At least one app type must be present"
        return 1
    fi
    
    # Business Rule 3: Specific combination rules
    if [[ "$has_2leg" == "true" ]]; then
        # 2-leg can only be combined with 3-leg-frontend
        if [[ "$has_3leg_backend" == "true" ]]; then
            echo "❌ Validation Failed: Invalid combination"
            echo "   2-leg API cannot be combined with 3-leg Backend"
            echo "   Allowed combinations:"
            echo "   - 2-leg + 3-leg-frontend (hybrid)"
            echo "   - 2-leg only"
            echo "   - 3-leg-frontend only"
            echo "   - 3-leg-backend only"
            echo "   - 3-leg-native only"
            return 1
        fi
        
        if [[ "$has_3leg_native" == "true" ]]; then
            echo "❌ Validation Failed: Invalid combination"
            echo "   2-leg API cannot be combined with 3-leg Native"
            echo "   Allowed combinations:"
            echo "   - 2-leg + 3-leg-frontend (hybrid)"
            echo "   - 2-leg only"
            echo "   - 3-leg-frontend only"
            echo "   - 3-leg-backend only"
            echo "   - 3-leg-native only"
            return 1
        fi
    fi
    
    # Business Rule 4: 3-leg-backend cannot be combined with 2-leg
    if [[ "$has_3leg_backend" == "true" ]] && [[ "$has_2leg" == "true" ]]; then
        echo "❌ Validation Failed: Invalid combination"
        echo "   3-leg Backend cannot be combined with 2-leg API"
        echo "   Allowed combinations:"
        echo "   - 2-leg + 3-leg-frontend (hybrid)"
        echo "   - 2-leg only"
        echo "   - 3-leg-frontend only"
        echo "   - 3-leg-backend only"
        echo "   - 3-leg-native only"
        return 1
    fi
    
    # Business Rule 5: 3-leg-native cannot be combined with 2-leg
    if [[ "$has_3leg_native" == "true" ]] && [[ "$has_2leg" == "true" ]]; then
        echo "❌ Validation Failed: Invalid combination"
        echo "   3-leg Native cannot be combined with 2-leg API"
        echo "   Allowed combinations:"
        echo "   - 2-leg + 3-leg-frontend (hybrid)"
        echo "   - 2-leg only"
        echo "   - 3-leg-frontend only"
        echo "   - 3-leg-backend only"
        echo "   - 3-leg-native only"
        return 1
    fi
    
    # All validations passed
    echo "✅ .tfvars combination validation passed"
    echo ""
    echo "📋 Valid combination detected:"
    
    if [[ "$has_2leg" == "true" ]] && [[ "$has_3leg_frontend" == "true" ]]; then
        echo "   🎯 Hybrid App: 2-leg API + 3-leg Frontend"
    elif [[ "$has_2leg" == "true" ]]; then
        echo "   🔧 API Service: 2-leg only"
    elif [[ "$has_3leg_frontend" == "true" ]]; then
        echo "   🌐 Frontend App: 3-leg Frontend only"
    elif [[ "$has_3leg_backend" == "true" ]]; then
        echo "   🖥️  Backend App: 3-leg Backend only"
    elif [[ "$has_3leg_native" == "true" ]]; then
        echo "   📱 Native App: 3-leg Native only"
    fi
    
    return 0
}

# Function to validate .tfvars file structure
validate_tfvars_structure() {
    local app_folder="$1"
    
    echo "🔍 Validating .tfvars file structure..."
    
    # Check each .tfvars file for required fields
    for tfvars_file in "$app_folder"/*.tfvars; do
        if [[ -f "$tfvars_file" ]]; then
            local filename=$(basename "$tfvars_file")
            echo "   📄 Checking: $filename"
            
            # Check for required fields
            if ! grep -q "app_name" "$tfvars_file"; then
                echo "   ❌ Missing: app_name in $filename"
                return 1
            fi
            
            if ! grep -q "app_label" "$tfvars_file"; then
                echo "   ❌ Missing: app_label in $filename"
                return 1
            fi
            
            if ! grep -q "grant_types" "$tfvars_file"; then
                echo "   ❌ Missing: grant_types in $filename"
                return 1
            fi
        fi
    done
    
    echo "   ✅ All .tfvars files have required fields"
    return 0
}

# Main execution
main() {
    local app_folder="$1"
    
    if [[ -z "$app_folder" ]]; then
        echo "Error: App folder path is required"
        show_usage
        exit 1
    fi
    
    if [[ ! -d "$app_folder" ]]; then
        echo "Error: App folder not found: $app_folder"
        exit 1
    fi
    
    echo "🔍 Terraform Module Validation - Engineering Team"
    echo "App: $(basename "$app_folder")"
    echo ""
    
    # Validate .tfvars combinations
    if ! validate_app_combinations "$app_folder"; then
        exit 1
    fi
    
    echo ""
    
    # Validate .tfvars structure
    if ! validate_tfvars_structure "$app_folder"; then
        exit 1
    fi
    
    echo ""
    echo "🎉 All validations passed! Ready for deployment."
    echo ""
    echo "📋 Summary:"
    echo "   - App combinations: ✅ Valid"
    echo "   - .tfvars structure: ✅ Valid"
    echo "   - Business rules: ✅ Enforced"
}

# Run main function
main "$@" 