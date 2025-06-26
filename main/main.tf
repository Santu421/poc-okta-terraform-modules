# Main Terraform Configuration
# This file orchestrates the creation of Okta resources based on YAML configurations

locals {
  # Read and parse the metadata file (shared across all modules)
  metadata_file = file("${var.app_config_path}/${basename(var.app_config_path)}-metadata.yaml")
  metadata      = yamldecode(local.metadata_file)
  
  # Common profile for all modules
  common_profile = jsonencode({
    parent_cmdb_name    = local.metadata.parent_cmdb_name
    division            = local.metadata.division
    cmdb_app_short_name = local.metadata.cmdb_app_short_name
    team_dl             = local.metadata.team_dl
    requested_by        = local.metadata.requested_by
  })
  
  # Read and parse the environment-specific config file
  env_config_file = file("${var.app_config_path}/${var.environment}/${local.metadata.cmdb_app_short_name}-${var.environment}.yaml")
  env_config      = yamldecode(local.env_config_file)
  
  # Extract environment config values
  app_config  = local.env_config.app_config
  
  # Optional fields that may not exist in simple configs
  oauth_config = try(local.env_config.oauth_config, {})
  trusted_origins = try(local.env_config.trusted_origins, [])
  bookmarks = try(local.env_config.bookmarks, [])
}

# Create 2-leg OAuth app if enabled
module "oauth_2leg" {
  count  = local.app_config.create_2leg ? 1 : 0
  source = "../modules/oauth_2leg"
  
  app_label = var.app_label
  token_endpoint_auth_method = var.token_endpoint_auth_method
  omit_secret = var.omit_secret
  auto_key_rotation = var.auto_key_rotation
  auto_submit_toolbar = var.auto_submit_toolbar
  hide_ios = var.hide_ios
  hide_web = var.hide_web
  issuer_mode = var.issuer_mode
  consent_method = var.consent_method
  login_mode = var.login_mode
  status = var.status
  client_basic_secret = var.client_basic_secret
  profile = local.common_profile
  
  # Additional optional variables
  accessibility_error_redirect_url = var.accessibility_error_redirect_url
  accessibility_login_redirect_url = var.accessibility_login_redirect_url
  accessibility_self_service = var.accessibility_self_service
  admin_note = var.admin_note
  enduser_note = var.enduser_note
  app_links_json = var.app_links_json
  app_settings_json = var.app_settings_json
  authentication_policy = var.authentication_policy
  client_id = var.client_id
  client_uri = var.client_uri
  implicit_assignment = var.implicit_assignment
  jwks_uri = var.jwks_uri
  login_scopes = var.login_scopes
  login_uri = var.login_uri
  logo = var.logo
  logo_uri = var.logo_uri
  pkce_required = var.pkce_required
  policy_uri = var.policy_uri
  post_logout_redirect_uris = var.post_logout_redirect_uris
  redirect_uris = var.redirect_uris
  refresh_token_leeway = var.refresh_token_leeway
  refresh_token_rotation = var.refresh_token_rotation
  tos_uri = var.tos_uri
  user_name_template = var.user_name_template
  user_name_template_push_status = var.user_name_template_push_status
  user_name_template_suffix = var.user_name_template_suffix
  user_name_template_type = var.user_name_template_type
  wildcard_redirect = var.wildcard_redirect
}

# Create 3-leg frontend OAuth app if enabled
# module "oauth_3leg_frontend" {
#   count  = local.app_config.create_3leg_frontend ? 1 : 0
#   source = "../modules/spa_oidc"
#   
#   app_config_path = var.app_config_path
#   environment     = var.environment
#   profile         = local.common_profile
#   division        = local.metadata.division
#   cmdb_app_short_name = local.metadata.cmdb_app_short_name
# }

# Create 3-leg backend OAuth app if enabled
# module "oauth_3leg_backend" {
#   count  = local.app_config.create_3leg_backend ? 1 : 0
#   source = "../modules/web_oidc"
#   
#   app_config_path = var.app_config_path
#   environment     = var.environment
#   profile         = local.common_profile
#   division        = local.metadata.division
#   cmdb_app_short_name = local.metadata.cmdb_app_short_name
# }

# Create 3-leg native OAuth app if enabled
# module "oauth_3leg_native" {
#   count  = local.app_config.create_3leg_native ? 1 : 0
#   source = "../modules/na_oidc"
#   
#   app_config_path = var.app_config_path
#   environment     = var.environment
#   profile         = local.common_profile
#   division        = local.metadata.division
#   cmdb_app_short_name = local.metadata.cmdb_app_short_name
# } 