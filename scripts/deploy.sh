#!/bin/bash

# Okta Terraform Deployment Script
# This script provides an interactive menu for deploying Okta resources

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Default values
DEFAULT_CONFIGS_PATH="../poc-okta-terraform-configs"

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "${BLUE}================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}================================${NC}"
}

# Function to check if required tools are installed
check_prerequisites() {
    print_status "Checking prerequisites..."
    
    if ! command -v terraform &> /dev/null; then
        print_error "Terraform is not installed. Please install Terraform first."
        exit 1
    fi
    
    if ! command -v yq &> /dev/null; then
        print_warning "yq is not installed. Some features may not work properly."
    fi
    
    print_status "Prerequisites check completed."
}

# Function to validate environment
validate_environment() {
    local env=$1
    if [[ ! "$env" =~ ^(dev|uat|prod)$ ]]; then
        print_error "Invalid environment: $env. Must be dev, uat, or prod."
        return 1
    fi
    return 0
}

# Function to list available apps
list_available_apps() {
    local configs_path=$1
    local apps=()
    
    if [[ ! -d "$configs_path/apps" ]]; then
        print_error "Apps directory not found at $configs_path/apps"
        return 1
    fi
    
    print_status "Scanning for available apps..."
    
    # Find all metadata files
    while IFS= read -r -d '' file; do
        local app_path=$(dirname "$file")
        local app_name=$(basename "$app_path")
        local division=$(basename "$(dirname "$app_path")")
        apps+=("$division/$app_name")
    done < <(find "$configs_path/apps" -name "*metadata.yaml" -print0 2>/dev/null)
    
    if [[ ${#apps[@]} -eq 0 ]]; then
        print_error "No apps found in $configs_path/apps"
        return 1
    fi
    
    echo -e "${BLUE}Available Apps:${NC}"
    for i in "${!apps[@]}"; do
        echo "  $((i+1)). ${apps[$i]}"
    done
    
    return 0
}

# Function to select app
select_app() {
    local configs_path=$1
    
    if ! list_available_apps "$configs_path"; then
        return 1
    fi
    
    echo
    read -p "Enter app number: " app_choice
    
    # Get the selected app
    local apps=()
    while IFS= read -r -d '' file; do
        local app_path=$(dirname "$file")
        local app_name=$(basename "$app_path")
        local division=$(basename "$(dirname "$app_path")")
        apps+=("$division/$app_name")
    done < <(find "$configs_path/apps" -name "*metadata.yaml" -print0 2>/dev/null)
    
    if [[ $app_choice -lt 1 || $app_choice -gt ${#apps[@]} ]]; then
        print_error "Invalid app selection."
        return 1
    fi
    
    local selected_app=${apps[$((app_choice-1))]}
    echo "$selected_app"
}

# Function to validate app configuration
validate_app_config() {
    local app_path=$1
    local environment=$2
    
    print_status "Validating app configuration..."
    
    # Check if metadata file exists
    local metadata_file="$app_path/metadata.yaml"
    if [[ ! -f "$metadata_file" ]]; then
        print_error "Metadata file not found: $metadata_file"
        return 1
    fi
    
    # Check if environment config exists
    local env_config_file="$app_path/$environment/${app_name}-${environment}.yaml"
    if [[ ! -f "$env_config_file" ]]; then
        print_error "Environment config file not found: $env_config_file"
        return 1
    fi
    
    print_status "App configuration validation passed."
    return 0
}

# Function to deploy app
deploy_app() {
    local configs_path=$1
    local environment=$2
    
    print_header "App Deployment"
    
    # Select app
    local selected_app=$(select_app "$configs_path")
    if [[ $? -ne 0 ]]; then
        return 1
    fi
    
    local app_path="$configs_path/apps/$selected_app"
    local app_name=$(basename "$app_path")
    
    print_status "Selected app: $selected_app"
    
    # Validate app configuration
    if ! validate_app_config "$app_path" "$environment"; then
        return 1
    fi
    
    # Set app config path for Terraform
    local app_config_path="$app_path"
    
    # Run Terraform
    run_terraform "$environment" "$app_config_path"
}

# Function to deploy other Okta components
deploy_other_components() {
    local environment=$1
    
    print_header "Other Okta Components Deployment"
    
    echo -e "${BLUE}Available Components:${NC}"
    echo "  1. Authorization Server"
    echo "  2. Custom Domain"
    echo "  3. Network Zone"
    echo "  4. Policy"
    echo "  5. Back to Main Menu"
    
    echo
    read -p "Select component (1-5): " component_choice
    
    case $component_choice in
        1)
            print_status "Authorization Server deployment not yet implemented."
            ;;
        2)
            print_status "Custom Domain deployment not yet implemented."
            ;;
        3)
            print_status "Network Zone deployment not yet implemented."
            ;;
        4)
            print_status "Policy deployment not yet implemented."
            ;;
        5)
            return 0
            ;;
        *)
            print_error "Invalid selection."
            return 1
            ;;
    esac
}

# Function to run Terraform
run_terraform() {
    local environment=$1
    local app_config_path=$2
    
    print_header "Terraform Execution"
    
    # Check if API token is set
    if [[ -z "$TF_VAR_okta_api_token" ]]; then
        print_error "TF_VAR_okta_api_token environment variable is not set."
        print_status "Please set it with: export TF_VAR_okta_api_token='your-token'"
        return 1
    fi
    
    # Determine tfvars file
    local tfvars_file="$PROJECT_ROOT/vars/${environment}.tfvars"
    if [[ ! -f "$tfvars_file" ]]; then
        print_error "Tfvars file not found: $tfvars_file"
        return 1
    fi
    
    print_status "Environment: $environment"
    print_status "App config path: $app_config_path"
    print_status "Tfvars file: $tfvars_file"
    
    # Change to project root
    cd "$PROJECT_ROOT"
    
    # Initialize Terraform if needed
    if [[ ! -d ".terraform" ]]; then
        print_status "Initializing Terraform..."
        terraform init
    fi
    
    # Show plan
    echo
    print_status "Running terraform plan..."
    terraform plan \
        -var-file="$tfvars_file" \
        -var="environment=$environment" \
        -var="app_config_path=$app_config_path"
    
    # Ask for confirmation
    echo
    read -p "Do you want to apply these changes? (y/N): " confirm
    
    if [[ $confirm =~ ^[Yy]$ ]]; then
        print_status "Applying changes..."
        terraform apply \
            -var-file="$tfvars_file" \
            -var="environment=$environment" \
            -var="app_config_path=$app_config_path" \
            -auto-approve
        print_status "Deployment completed successfully!"
    else
        print_status "Deployment cancelled."
    fi
}

# Function to show main menu
show_main_menu() {
    print_header "Okta Terraform Deployment"
    echo
    echo -e "${BLUE}Select Deployment Type:${NC}"
    echo "  1. App Deployment"
    echo "  2. Other Okta Components"
    echo "  3. Exit"
    echo
}

# Function to select environment
select_environment() {
    echo -e "${BLUE}Select Environment:${NC}"
    echo "  1. Development (dev)"
    echo "  2. UAT (uat)"
    echo "  3. Production (prod)"
    echo
    read -p "Enter environment number (1-3): " env_choice
    
    case $env_choice in
        1) echo "dev" ;;
        2) echo "uat" ;;
        3) echo "prod" ;;
        *)
            print_error "Invalid environment selection."
            return 1
            ;;
    esac
}

# Main function
main() {
    print_header "Okta Terraform Deployment Script"
    
    # Check prerequisites
    check_prerequisites
    
    # Get configs path
    read -p "Enter path to configs directory [$DEFAULT_CONFIGS_PATH]: " configs_path
    configs_path=${configs_path:-$DEFAULT_CONFIGS_PATH}
    
    if [[ ! -d "$configs_path" ]]; then
        print_error "Configs directory not found: $configs_path"
        exit 1
    fi
    
    print_status "Using configs path: $configs_path"
    
    # Main loop
    while true; do
        show_main_menu
        read -p "Enter your choice (1-3): " choice
        
        case $choice in
            1)
                # App deployment
                local environment=$(select_environment)
                if [[ $? -eq 0 ]]; then
                    deploy_app "$configs_path" "$environment"
                fi
                ;;
            2)
                # Other components
                local environment=$(select_environment)
                if [[ $? -eq 0 ]]; then
                    deploy_other_components "$environment"
                fi
                ;;
            3)
                print_status "Exiting..."
                exit 0
                ;;
            *)
                print_error "Invalid choice. Please try again."
                ;;
        esac
        
        echo
        read -p "Press Enter to continue..."
        echo
    done
}

# Run main function
main "$@" 