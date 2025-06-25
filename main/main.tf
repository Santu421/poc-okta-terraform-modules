# Main Terraform Configuration
# This file orchestrates the creation of Okta resources based on YAML configurations

# Read and parse the metadata file
locals {
  metadata_file = file("${var.app_config_path}/${var.app_name}-metadata.yaml")
  metadata      = yamldecode(local.metadata_file)
  
  # Extract metadata values
  parent_cmdb_name    = local.metadata.parent_cmdb_name
  division            = local.metadata.division
  cmdb_app_short_name = local.metadata.cmdb_app_short_name
  team_dl             = local.metadata.team_dl
  requested_by        = local.metadata.requested_by
}

# Read and parse the environment-specific config file
locals {
  env_config_file = file("${var.app_config_path}/${var.environment}/${var.app_name}-${var.environment}.yaml")
  env_config      = yamldecode(local.env_config_file)
  
  # Extract environment config values
  environment = local.env_config.environment
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
  
  app_label = "${local.division}_${local.cmdb_app_short_name}_API_SVCS"
  client_id = "${local.division}_${local.cmdb_app_short_name}_API_SVCS"
  
  # Set profile with all metadata fields
  profile = jsonencode({
    parent_cmdb_name    = local.parent_cmdb_name
    division            = local.division
    cmdb_app_short_name = local.cmdb_app_short_name
    team_dl             = local.team_dl
    requested_by        = local.requested_by
  })
  
  # All optional OAuth app parameters - use try() to handle missing fields
  accessibility_error_redirect_url     = try(local.oauth_config.accessibility_error_redirect_url, null)
  accessibility_login_redirect_url     = try(local.oauth_config.accessibility_login_redirect_url, null)
  accessibility_self_service           = try(local.oauth_config.accessibility_self_service, null)
  admin_note                           = try(local.oauth_config.admin_note, null)
  app_links_json                       = try(local.oauth_config.app_links_json, null)
  app_settings_json                    = try(local.oauth_config.app_settings_json, null)
  authentication_policy                = try(local.oauth_config.authentication_policy, null)
  auto_key_rotation                    = try(local.oauth_config.auto_key_rotation, null)
  auto_submit_toolbar                  = try(local.oauth_config.auto_submit_toolbar, null)
  client_basic_secret                  = try(local.oauth_config.client_basic_secret, null)
  client_uri                           = try(local.oauth_config.client_uri, null)
  consent_method                       = try(local.oauth_config.consent_method, null)
  enduser_note                         = try(local.oauth_config.enduser_note, null)
  hide_ios                             = try(local.oauth_config.hide_ios, null)
  hide_web                             = try(local.oauth_config.hide_web, null)
  implicit_assignment                  = try(local.oauth_config.implicit_assignment, null)
  issuer_mode                          = try(local.oauth_config.issuer_mode, null)
  jwks_uri                             = try(local.oauth_config.jwks_uri, null)
  login_mode                           = try(local.oauth_config.login_mode, null)
  login_scopes                         = try(local.oauth_config.login_scopes, null)
  login_uri                            = try(local.oauth_config.login_uri, null)
  logo                                 = try(local.oauth_config.logo, null)
  logo_uri                             = try(local.oauth_config.logo_uri, null)
  omit_secret                          = try(local.oauth_config.omit_secret, null)
  pkce_required                        = try(local.oauth_config.pkce_required, null)
  policy_uri                           = try(local.oauth_config.policy_uri, null)
  post_logout_redirect_uris           = try(local.oauth_config.post_logout_redirect_uris, null)
  redirect_uris                        = try(local.oauth_config.redirect_uris, null)
  refresh_token_leeway                = try(local.oauth_config.refresh_token_leeway, null)
  refresh_token_rotation              = try(local.oauth_config.refresh_token_rotation, null)
  status                               = try(local.oauth_config.status, null)
  tos_uri                              = try(local.oauth_config.tos_uri, null)
  user_name_template                   = try(local.oauth_config.user_name_template, null)
  user_name_template_push_status      = try(local.oauth_config.user_name_template_push_status, null)
  user_name_template_suffix           = try(local.oauth_config.user_name_template_suffix, null)
  user_name_template_type             = try(local.oauth_config.user_name_template_type, null)
  wildcard_redirect                    = try(local.oauth_config.wildcard_redirect, null)
}

# Create 3-leg frontend OAuth app if enabled
module "oauth_3leg_frontend" {
  count  = local.app_config.create_3leg_frontend ? 1 : 0
  source = "../modules/spa_oidc"
  
  app_label = "${local.division}_${local.cmdb_app_short_name}_OIDC_SPA"
  client_id = "${local.division}_${local.cmdb_app_short_name}_OIDC_SPA"
  
  # Set profile with all metadata fields
  profile = jsonencode({
    parent_cmdb_name    = local.parent_cmdb_name
    division            = local.division
    cmdb_app_short_name = local.cmdb_app_short_name
    team_dl             = local.team_dl
    requested_by        = local.requested_by
  })
  
  # OAuth configuration
  redirect_uris = try(local.oauth_config.redirect_uris, [])
  post_logout_uris = try(local.oauth_config.post_logout_uris, [])
  
  # Group configuration
  group_name = "${local.division}_${local.cmdb_app_short_name}_SPA_ACCESS_${upper(local.environment)}"
  group_description = "Access group for ${local.parent_cmdb_name} Frontend (${local.environment})"
  
  # Trusted origin
  trusted_origin_name = "${local.division}_${local.cmdb_app_short_name}_SPA_ORIGIN_${upper(local.environment)}"
  trusted_origin_url = try(local.trusted_origins[0].url, "https://${lower(local.cmdb_app_short_name)}-${local.environment}.example.com")
  trusted_origin_scopes = ["CORS", "REDIRECT"]
  
  # Bookmark
  bookmark_label = "${local.parent_cmdb_name} Frontend Admin (${local.environment})"
  bookmark_url = try(local.bookmarks[0].url, "https://${lower(local.cmdb_app_short_name)}-${local.environment}.example.com")
}

# Create 3-leg backend OAuth app if enabled
module "oauth_3leg_backend" {
  count  = local.app_config.create_3leg_backend ? 1 : 0
  source = "../modules/web_oidc"
  
  app_label = "${local.division}_${local.cmdb_app_short_name}_OIDC_WA"
  client_id = "${local.division}_${local.cmdb_app_short_name}_OIDC_WA"
  
  # Set profile with all metadata fields
  profile = jsonencode({
    parent_cmdb_name    = local.parent_cmdb_name
    division            = local.division
    cmdb_app_short_name = local.cmdb_app_short_name
    team_dl             = local.team_dl
    requested_by        = local.requested_by
  })
  
  # OAuth configuration
  redirect_uris = try(local.oauth_config.redirect_uris, [])
  post_logout_uris = try(local.oauth_config.post_logout_uris, [])
  
  # Group configuration
  group_name = "${local.division}_${local.cmdb_app_short_name}_WA_ACCESS_${upper(local.environment)}"
  group_description = "Access group for ${local.parent_cmdb_name} Backend (${local.environment})"
  
  # Trusted origin
  trusted_origin_name = "${local.division}_${local.cmdb_app_short_name}_WA_ORIGIN_${upper(local.environment)}"
  trusted_origin_url = try(local.trusted_origins[0].url, "https://${lower(local.cmdb_app_short_name)}-${local.environment}.example.com")
  trusted_origin_scopes = ["CORS", "REDIRECT"]
  
  # Bookmark
  bookmark_label = "${local.parent_cmdb_name} Backend Admin (${local.environment})"
  bookmark_url = try(local.bookmarks[0].url, "https://${lower(local.cmdb_app_short_name)}-${local.environment}.example.com")
}

# Create 3-leg native OAuth app if enabled
module "oauth_3leg_native" {
  count  = local.app_config.create_3leg_native ? 1 : 0
  source = "../modules/na_oidc"
  
  app_label = "${local.division}_${local.cmdb_app_short_name}_OIDC_NA"
  client_id = "${local.division}_${local.cmdb_app_short_name}_OIDC_NA"
  
  # Set profile with all metadata fields
  profile = jsonencode({
    parent_cmdb_name    = local.parent_cmdb_name
    division            = local.division
    cmdb_app_short_name = local.cmdb_app_short_name
    team_dl             = local.team_dl
    requested_by        = local.requested_by
  })
  
  # OAuth configuration
  redirect_uris = try(local.oauth_config.redirect_uris, [])
  post_logout_uris = try(local.oauth_config.post_logout_uris, [])
  
  # Group configuration
  group_name = "${local.division}_${local.cmdb_app_short_name}_NA_ACCESS_${upper(local.environment)}"
  group_description = "Access group for ${local.parent_cmdb_name} Native (${local.environment})"
  
  # Trusted origin
  trusted_origin_name = "${local.division}_${local.cmdb_app_short_name}_NA_ORIGIN_${upper(local.environment)}"
  trusted_origin_url = try(local.trusted_origins[0].url, "https://${lower(local.cmdb_app_short_name)}-${local.environment}.example.com")
  trusted_origin_scopes = ["CORS", "REDIRECT"]
  
  # Bookmark
  bookmark_label = "${local.parent_cmdb_name} Native Admin (${local.environment})"
  bookmark_url = try(local.bookmarks[0].url, "https://${lower(local.cmdb_app_short_name)}-${local.environment}.example.com")
} 