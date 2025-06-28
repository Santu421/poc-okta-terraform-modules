# Root Terraform Configuration
# This file configures the Okta provider and orchestrates the main module

# Okta Provider Configuration
provider "okta" {
  org_name  = var.okta_org_name
  base_url  = var.okta_base_url
  api_token = var.okta_api_token
}

locals {
  # Derive environment from app_config_path if not provided
  # Expected path format: apps/DIV1/TEST/dev
  environment = var.environment != null ? var.environment : element(split("/", var.app_config_path), -1)
}

# Call the main orchestration module
module "main" {
  source = "./main"
  
  # Pass through the required variables
  app_config_path = var.app_config_path
  environment     = local.environment
  
  # Pass through the configuration objects
  oauth2 = var.oauth2
  spa    = var.spa
  na     = var.na
  web    = var.web
}

# (Removed module "okta_apps" block as it is not needed) 