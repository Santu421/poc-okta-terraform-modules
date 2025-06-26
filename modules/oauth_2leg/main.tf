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
  
  # Read metadata for profile
  app_short_name = basename(var.app_config_path)
  metadata_file = file("${var.app_config_path}/${local.app_short_name}-metadata.yaml")
  metadata = yamldecode(local.metadata_file)
  
  # Extract metadata values
  parent_cmdb_name    = local.metadata.parent_cmdb_name
  division            = local.metadata.division
  cmdb_app_short_name = local.metadata.cmdb_app_short_name
  team_dl             = local.metadata.team_dl
  requested_by        = local.metadata.requested_by
}

resource "okta_app_oauth" "oauth_2leg" {
  label                                = "${local.division}_${local.cmdb_app_short_name}_API_SVCS"
  type                                 = "service"
  grant_types                          = ["client_credentials"]
  response_types                       = ["token"]
  token_endpoint_auth_method          = "client_secret_basic"
  
  # Set profile with all metadata fields
  profile = jsonencode({
    parent_cmdb_name    = local.parent_cmdb_name
    division            = local.division
    cmdb_app_short_name = local.cmdb_app_short_name
    team_dl             = local.team_dl
    requested_by        = local.requested_by
  })
  
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