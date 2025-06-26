# OAuth 2-Leg Module
# Reads configuration from 2leg-api.tfvars file

terraform {
  required_providers {
    okta = {
      source  = "okta/okta"
      version = "4.20.0"
    }
  }
}

locals {
  # Check if 2leg-api.tfvars exists and read it
  tfvars_file_path = "${var.app_config_path}/${var.environment}/2leg-api.tfvars"
  tfvars_content = fileexists(local.tfvars_file_path) ? file(local.tfvars_file_path) : ""
}

resource "okta_app_oauth" "oauth_2leg" {
  label                                = "${var.division}_${var.cmdb_app_short_name}_API_SVCS"
  type                                 = "service"
  grant_types                          = ["client_credentials"]
  response_types                       = ["token"]
  token_endpoint_auth_method          = "client_secret_basic"
  
  # Set profile with all metadata fields
  profile = var.profile
  
  # OAuth app parameters
  omit_secret                          = true
  auto_key_rotation                    = true
  auto_submit_toolbar                  = false
  hide_ios                             = true
  hide_web                             = true
  issuer_mode                          = "ORG_URL"
  consent_method                       = "TRUSTED"
  login_mode                           = "DISABLED"
  status                               = "ACTIVE"
} 