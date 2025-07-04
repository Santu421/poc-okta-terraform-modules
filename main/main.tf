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
  
  app_label = var.oauth2.app_label
  token_endpoint_auth_method = var.oauth2.token_endpoint_auth_method
  omit_secret = var.oauth2.omit_secret
  auto_key_rotation = var.oauth2.auto_key_rotation
  auto_submit_toolbar = var.oauth2.auto_submit_toolbar
  hide_ios = var.oauth2.hide_ios
  hide_web = var.oauth2.hide_web
  issuer_mode = var.oauth2.issuer_mode
  consent_method = var.oauth2.consent_method
  login_mode = var.oauth2.login_mode
  status = var.oauth2.status
  client_basic_secret = var.oauth2.client_basic_secret
  profile = local.common_profile
  
  # Additional optional variables
  accessibility_error_redirect_url = var.oauth2.accessibility_error_redirect_url
  accessibility_login_redirect_url = var.oauth2.accessibility_login_redirect_url
  accessibility_self_service = var.oauth2.accessibility_self_service
  admin_note = var.oauth2.admin_note
  enduser_note = var.oauth2.enduser_note
  app_links_json = var.oauth2.app_links_json
  app_settings_json = var.oauth2.app_settings_json
  authentication_policy = var.oauth2.authentication_policy
  client_id = var.oauth2.client_id
  client_uri = var.oauth2.client_uri
  implicit_assignment = var.oauth2.implicit_assignment
  jwks_uri = var.oauth2.jwks_uri
  login_scopes = var.oauth2.login_scopes
  login_uri = var.oauth2.login_uri
  logo = var.oauth2.logo
  logo_uri = var.oauth2.logo_uri
  pkce_required = var.oauth2.pkce_required
  policy_uri = var.oauth2.policy_uri
  post_logout_redirect_uris = var.oauth2.post_logout_redirect_uris
  redirect_uris = var.oauth2.redirect_uris
  refresh_token_leeway = var.oauth2.refresh_token_leeway
  refresh_token_rotation = var.oauth2.refresh_token_rotation
  tos_uri = var.oauth2.tos_uri
  user_name_template = var.oauth2.user_name_template
  user_name_template_push_status = var.oauth2.user_name_template_push_status
  user_name_template_suffix = var.oauth2.user_name_template_suffix
  user_name_template_type = var.oauth2.user_name_template_type
  wildcard_redirect = var.oauth2.wildcard_redirect
}

# Create 3-leg frontend OAuth app if enabled
module "oauth_3leg_frontend" {
  count  = local.app_config.create_3leg_frontend ? 1 : 0
  source = "../modules/spa_oidc"
  
  app_label = var.spa.app_label
  profile = local.common_profile
  
  # OAuth App variables
  token_endpoint_auth_method = var.spa.token_endpoint_auth_method
  omit_secret = var.spa.omit_secret
  auto_key_rotation = var.spa.auto_key_rotation
  auto_submit_toolbar = var.spa.auto_submit_toolbar
  hide_ios = var.spa.hide_ios
  hide_web = var.spa.hide_web
  issuer_mode = var.spa.issuer_mode
  consent_method = var.spa.consent_method
  login_mode = var.spa.login_mode
  status = var.spa.status
  client_basic_secret = var.spa.client_basic_secret
  client_id = var.spa.client_id
  pkce_required = var.spa.pkce_required
  redirect_uris = var.spa.redirect_uris
  post_logout_redirect_uris = var.spa.post_logout_redirect_uris
  
  # Additional optional OAuth variables
  accessibility_error_redirect_url = var.spa.accessibility_error_redirect_url
  accessibility_login_redirect_url = var.spa.accessibility_login_redirect_url
  accessibility_self_service = var.spa.accessibility_self_service
  admin_note = var.spa.admin_note
  enduser_note = var.spa.enduser_note
  app_links_json = var.spa.app_links_json
  app_settings_json = var.spa.app_settings_json
  authentication_policy = var.spa.authentication_policy
  client_uri = var.spa.client_uri
  implicit_assignment = var.spa.implicit_assignment
  jwks_uri = var.spa.jwks_uri
  login_scopes = var.spa.login_scopes
  login_uri = var.spa.login_uri
  logo = var.spa.logo
  logo_uri = var.spa.logo_uri
  policy_uri = var.spa.policy_uri
  refresh_token_leeway = var.spa.refresh_token_leeway
  refresh_token_rotation = var.spa.refresh_token_rotation
  tos_uri = var.spa.tos_uri
  user_name_template = var.spa.user_name_template
  user_name_template_push_status = var.spa.user_name_template_push_status
  user_name_template_suffix = var.spa.user_name_template_suffix
  user_name_template_type = var.spa.user_name_template_type
  wildcard_redirect = var.spa.wildcard_redirect
  
  # Group variables
  group_name = var.spa.group_name
  group_description = var.spa.group_description
  
  # Trusted Origin variables
  trusted_origin_name = var.spa.trusted_origin_name
  trusted_origin_url = var.spa.trusted_origin_url
  trusted_origin_scopes = var.spa.trusted_origin_scopes
  
  # Bookmark variables
  bookmark_label = var.spa.bookmark_label
  bookmark_url = var.spa.bookmark_url
  bookmark_status = var.spa.bookmark_status
  bookmark_auto_submit_toolbar = var.spa.bookmark_auto_submit_toolbar
  bookmark_hide_ios = var.spa.bookmark_hide_ios
  bookmark_hide_web = var.spa.bookmark_hide_web
}

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