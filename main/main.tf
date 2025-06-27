# Main Terraform Configuration
# This file orchestrates the creation of Okta resources based on YAML configurations

locals {
  # Read and parse the metadata file (shared across all modules)
  # Metadata file is at app level: apps/DIV1/TEST/TEST-metadata.yaml
  # From terraform modules dir, the path is: ../poc-okta-terraform-configs/apps/DIV1/TEST/TEST-metadata.yaml
  app_path = dirname(var.app_config_path)
  app_name = basename(dirname(var.app_config_path))
  metadata_file = file("../poc-okta-terraform-configs/${local.app_path}/${local.app_name}-metadata.yaml")
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
  # Environment config is at: apps/DIV1/TEST/dev/TEST-dev.yaml
  env_config_file = file("../poc-okta-terraform-configs/${var.app_config_path}/${local.metadata.cmdb_app_short_name}-${var.environment}.yaml")
  env_config      = yamldecode(local.env_config_file)
  
  # Extract environment config values
  app_config  = local.env_config.app_config
  
  # Optional fields that may not exist in simple configs
  oauth_config = try(local.env_config.oauth_config, {})
  trusted_origins = try(local.env_config.trusted_origins, [])
  bookmarks = try(local.env_config.bookmarks, [])
}

# Create 2-leg OAuth app if oauth2 object is provided
module "oauth_2leg" {
  count  = var.oauth2 != null ? 1 : 0
  source = "../modules/oauth_2leg"
  
  app_label = var.oauth2.app.label
  token_endpoint_auth_method = var.oauth2.app.token_endpoint_auth_method
  omit_secret = var.oauth2.app.omit_secret
  auto_key_rotation = var.oauth2.app.auto_key_rotation
  auto_submit_toolbar = var.oauth2.app.auto_submit_toolbar
  hide_ios = var.oauth2.app.hide_ios
  hide_web = var.oauth2.app.hide_web
  issuer_mode = var.oauth2.app.issuer_mode
  consent_method = var.oauth2.app.consent_method
  login_mode = var.oauth2.app.login_mode
  status = var.oauth2.app.status
  client_basic_secret = var.oauth2.app.client_basic_secret
  profile = local.common_profile
  
  # Additional optional variables
  accessibility_error_redirect_url = var.oauth2.app.accessibility_error_redirect_url
  accessibility_login_redirect_url = var.oauth2.app.accessibility_login_redirect_url
  accessibility_self_service = var.oauth2.app.accessibility_self_service
  admin_note = var.oauth2.app.admin_note
  enduser_note = var.oauth2.app.enduser_note
  app_links_json = var.oauth2.app.app_links_json
  app_settings_json = var.oauth2.app.app_settings_json
  authentication_policy = var.oauth2.app.authentication_policy
  client_id = var.oauth2.app.client_id
  client_uri = var.oauth2.app.client_uri
  implicit_assignment = var.oauth2.app.implicit_assignment
  jwks_uri = var.oauth2.app.jwks_uri
  login_scopes = var.oauth2.app.login_scopes
  login_uri = var.oauth2.app.login_uri
  logo = var.oauth2.app.logo
  logo_uri = var.oauth2.app.logo_uri
  pkce_required = var.oauth2.app.pkce_required
  policy_uri = var.oauth2.app.policy_uri
  post_logout_redirect_uris = var.oauth2.app.post_logout_redirect_uris
  redirect_uris = var.oauth2.app.redirect_uris
  refresh_token_leeway = var.oauth2.app.refresh_token_leeway
  refresh_token_rotation = var.oauth2.app.refresh_token_rotation
  tos_uri = var.oauth2.app.tos_uri
  user_name_template = var.oauth2.app.user_name_template
  user_name_template_push_status = var.oauth2.app.user_name_template_push_status
  user_name_template_suffix = var.oauth2.app.user_name_template_suffix
  user_name_template_type = var.oauth2.app.user_name_template_type
  wildcard_redirect = var.oauth2.app.wildcard_redirect
}

# Create 3-leg frontend OAuth app if spa object is provided
module "oauth_3leg_frontend" {
  count  = var.spa != null ? 1 : 0
  source = "../modules/spa_oidc"
  
  app_label = var.spa.app.label
  profile = local.common_profile
  
  # OAuth App variables
  token_endpoint_auth_method = var.spa.app.token_endpoint_auth_method
  omit_secret = var.spa.app.omit_secret
  auto_key_rotation = var.spa.app.auto_key_rotation
  auto_submit_toolbar = var.spa.app.auto_submit_toolbar
  hide_ios = var.spa.app.hide_ios
  hide_web = var.spa.app.hide_web
  issuer_mode = var.spa.app.issuer_mode
  consent_method = var.spa.app.consent_method
  login_mode = var.spa.app.login_mode
  status = var.spa.app.status
  client_basic_secret = var.spa.app.client_basic_secret
  client_id = var.spa.app.client_id
  pkce_required = var.spa.app.pkce_required
  redirect_uris = var.spa.app.redirect_uris
  post_logout_redirect_uris = var.spa.app.post_logout_redirect_uris
  
  # Additional optional OAuth variables
  accessibility_error_redirect_url = var.spa.app.accessibility_error_redirect_url
  accessibility_login_redirect_url = var.spa.app.accessibility_login_redirect_url
  accessibility_self_service = var.spa.app.accessibility_self_service
  admin_note = var.spa.app.admin_note
  enduser_note = var.spa.app.enduser_note
  app_links_json = var.spa.app.app_links_json
  app_settings_json = var.spa.app.app_settings_json
  authentication_policy = var.spa.app.authentication_policy
  client_uri = var.spa.app.client_uri
  implicit_assignment = var.spa.app.implicit_assignment
  jwks_uri = var.spa.app.jwks_uri
  login_scopes = var.spa.app.login_scopes
  login_uri = var.spa.app.login_uri
  logo = var.spa.app.logo
  logo_uri = var.spa.app.logo_uri
  policy_uri = var.spa.app.policy_uri
  refresh_token_leeway = var.spa.app.refresh_token_leeway
  refresh_token_rotation = var.spa.app.refresh_token_rotation
  tos_uri = var.spa.app.tos_uri
  user_name_template = var.spa.app.user_name_template
  user_name_template_push_status = var.spa.app.user_name_template_push_status
  user_name_template_suffix = var.spa.app.user_name_template_suffix
  user_name_template_type = var.spa.app.user_name_template_type
  wildcard_redirect = var.spa.app.wildcard_redirect
  
  # Group variables (conditional)
  group_name = var.spa.group != null ? var.spa.group.name : null
  group_description = var.spa.group != null ? var.spa.group.description : null
  
  # Trusted Origin variables (conditional)
  trusted_origin_name = var.spa.trusted_origin != null ? var.spa.trusted_origin.name : null
  trusted_origin_url = var.spa.trusted_origin != null ? var.spa.trusted_origin.url : null
  trusted_origin_scopes = var.spa.trusted_origin != null ? var.spa.trusted_origin.scopes : null
  
  # Bookmark variables (conditional)
  bookmark_label = var.spa.bookmark != null ? var.spa.bookmark.label : null
  bookmark_url = var.spa.bookmark != null ? var.spa.bookmark.url : null
  bookmark_status = var.spa.bookmark != null ? var.spa.bookmark.status : null
  bookmark_auto_submit_toolbar = var.spa.bookmark != null ? var.spa.bookmark.auto_submit_toolbar : null
  bookmark_hide_ios = var.spa.bookmark != null ? var.spa.bookmark.hide_ios : null
  bookmark_hide_web = var.spa.bookmark != null ? var.spa.bookmark.hide_web : null
}

# Create 3-leg backend OAuth app if web object is provided
module "oauth_3leg_backend" {
  count  = var.web != null ? 1 : 0
  source = "../modules/web_oidc"
  
  app_label = var.web.app.label
  profile = local.common_profile
  
  # OAuth App variables
  token_endpoint_auth_method = var.web.app.token_endpoint_auth_method
  omit_secret = var.web.app.omit_secret
  auto_key_rotation = var.web.app.auto_key_rotation
  auto_submit_toolbar = var.web.app.auto_submit_toolbar
  hide_ios = var.web.app.hide_ios
  hide_web = var.web.app.hide_web
  issuer_mode = var.web.app.issuer_mode
  consent_method = var.web.app.consent_method
  login_mode = var.web.app.login_mode
  status = var.web.app.status
  client_basic_secret = var.web.app.client_basic_secret
  client_id = var.web.app.client_id
  pkce_required = var.web.app.pkce_required
  redirect_uris = var.web.app.redirect_uris
  post_logout_redirect_uris = var.web.app.post_logout_redirect_uris
  
  # Additional optional OAuth variables
  accessibility_error_redirect_url = var.web.app.accessibility_error_redirect_url
  accessibility_login_redirect_url = var.web.app.accessibility_login_redirect_url
  accessibility_self_service = var.web.app.accessibility_self_service
  admin_note = var.web.app.admin_note
  enduser_note = var.web.app.enduser_note
  app_links_json = var.web.app.app_links_json
  app_settings_json = var.web.app.app_settings_json
  authentication_policy = var.web.app.authentication_policy
  client_uri = var.web.app.client_uri
  implicit_assignment = var.web.app.implicit_assignment
  jwks_uri = var.web.app.jwks_uri
  login_scopes = var.web.app.login_scopes
  login_uri = var.web.app.login_uri
  logo = var.web.app.logo
  logo_uri = var.web.app.logo_uri
  policy_uri = var.web.app.policy_uri
  refresh_token_leeway = var.web.app.refresh_token_leeway
  refresh_token_rotation = var.web.app.refresh_token_rotation
  tos_uri = var.web.app.tos_uri
  user_name_template = var.web.app.user_name_template
  user_name_template_push_status = var.web.app.user_name_template_push_status
  user_name_template_suffix = var.web.app.user_name_template_suffix
  user_name_template_type = var.web.app.user_name_template_type
  wildcard_redirect = var.web.app.wildcard_redirect
  
  # Group variables (conditional)
  group_name = var.web.group != null ? var.web.group.name : null
  group_description = var.web.group != null ? var.web.group.description : null
  
  # Trusted Origin variables (conditional)
  trusted_origin_name = var.web.trusted_origin != null ? var.web.trusted_origin.name : null
  trusted_origin_url = var.web.trusted_origin != null ? var.web.trusted_origin.url : null
  trusted_origin_scopes = var.web.trusted_origin != null ? var.web.trusted_origin.scopes : null
  
  # Bookmark variables (conditional)
  bookmark_label = var.web.bookmark != null ? var.web.bookmark.label : null
  bookmark_url = var.web.bookmark != null ? var.web.bookmark.url : null
  bookmark_status = var.web.bookmark != null ? var.web.bookmark.status : null
  bookmark_auto_submit_toolbar = var.web.bookmark != null ? var.web.bookmark.auto_submit_toolbar : null
  bookmark_hide_ios = var.web.bookmark != null ? var.web.bookmark.hide_ios : null
  bookmark_hide_web = var.web.bookmark != null ? var.web.bookmark.hide_web : null
}

# Create 3-leg native OAuth app if na object is provided
module "oauth_3leg_native" {
  count  = var.na != null ? 1 : 0
  source = "../modules/na_oidc"
  
  app_label = var.na.app.label
  profile = local.common_profile
  
  # OAuth App variables
  token_endpoint_auth_method = var.na.app.token_endpoint_auth_method
  omit_secret = var.na.app.omit_secret
  auto_key_rotation = var.na.app.auto_key_rotation
  auto_submit_toolbar = var.na.app.auto_submit_toolbar
  hide_ios = var.na.app.hide_ios
  hide_web = var.na.app.hide_web
  issuer_mode = var.na.app.issuer_mode
  consent_method = var.na.app.consent_method
  login_mode = var.na.app.login_mode
  status = var.na.app.status
  client_basic_secret = var.na.app.client_basic_secret
  client_id = var.na.app.client_id
  pkce_required = var.na.app.pkce_required
  redirect_uris = var.na.app.redirect_uris
  post_logout_redirect_uris = var.na.app.post_logout_redirect_uris
  
  # Additional optional OAuth variables
  accessibility_error_redirect_url = var.na.app.accessibility_error_redirect_url
  accessibility_login_redirect_url = var.na.app.accessibility_login_redirect_url
  accessibility_self_service = var.na.app.accessibility_self_service
  admin_note = var.na.app.admin_note
  enduser_note = var.na.app.enduser_note
  app_links_json = var.na.app.app_links_json
  app_settings_json = var.na.app.app_settings_json
  authentication_policy = var.na.app.authentication_policy
  client_uri = var.na.app.client_uri
  implicit_assignment = var.na.app.implicit_assignment
  jwks_uri = var.na.app.jwks_uri
  login_scopes = var.na.app.login_scopes
  login_uri = var.na.app.login_uri
  logo = var.na.app.logo
  logo_uri = var.na.app.logo_uri
  policy_uri = var.na.app.policy_uri
  refresh_token_leeway = var.na.app.refresh_token_leeway
  refresh_token_rotation = var.na.app.refresh_token_rotation
  tos_uri = var.na.app.tos_uri
  user_name_template = var.na.app.user_name_template
  user_name_template_push_status = var.na.app.user_name_template_push_status
  user_name_template_suffix = var.na.app.user_name_template_suffix
  user_name_template_type = var.na.app.user_name_template_type
  wildcard_redirect = var.na.app.wildcard_redirect
  
  # Group variables (conditional)
  group_name = var.na.group != null ? var.na.group.name : null
  group_description = var.na.group != null ? var.na.group.description : null
  
  # Trusted Origin variables (conditional)
  trusted_origin_name = var.na.trusted_origin != null ? var.na.trusted_origin.name : null
  trusted_origin_url = var.na.trusted_origin != null ? var.na.trusted_origin.url : null
  trusted_origin_scopes = var.na.trusted_origin != null ? var.na.trusted_origin.scopes : null
  
  # Bookmark variables (conditional)
  bookmark_label = var.na.bookmark != null ? var.na.bookmark.label : null
  bookmark_url = var.na.bookmark != null ? var.na.bookmark.url : null
  bookmark_status = var.na.bookmark != null ? var.na.bookmark.status : null
  bookmark_auto_submit_toolbar = var.na.bookmark != null ? var.na.bookmark.auto_submit_toolbar : null
  bookmark_hide_ios = var.na.bookmark != null ? var.na.bookmark.hide_ios : null
  bookmark_hide_web = var.na.bookmark != null ? var.na.bookmark.hide_web : null
} 