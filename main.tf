# Root Terraform Configuration
# This file configures the Okta provider and orchestrates the main module

# Okta Provider Configuration
provider "okta" {
  org_name  = var.okta_org_name
  base_url  = var.okta_base_url
  api_token = var.okta_api_token
}

# Call the main orchestration module
module "main" {
  source = "./main"
  
  # Pass through the required variables
  app_config_path = var.app_config_path
  environment     = var.environment
}

# (Removed module "okta_apps" block as it is not needed) 