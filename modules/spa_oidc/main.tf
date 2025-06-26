terraform {
  required_providers {
    okta = {
      source  = "okta/okta"
      version = "4.20.0"
    }
  }
}

# SPA OIDC Module
# Reads configuration from 3leg-spa.tfvars file

locals {
  # Check if 3leg-spa.tfvars exists and read it
  tfvars_file_path = "${var.app_config_path}/3leg-spa.tfvars"
  tfvars_content = fileexists(local.tfvars_file_path) ? file(local.tfvars_file_path) : ""
  tfvars = length(local.tfvars_content) > 0 ? hcl2(local.tfvars_content) : {}
  
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

resource "okta_app_oauth" "spa_oidc" {
  label                                = local.tfvars.app_label
  type                                 = "browser"
  grant_types                          = ["authorization_code"]
  response_types                       = ["code"]
  token_endpoint_auth_method          = "none"
  
  # Set profile with all metadata fields
  profile = jsonencode({
    parent_cmdb_name    = local.parent_cmdb_name
    division            = local.division
    cmdb_app_short_name = local.cmdb_app_short_name
    team_dl             = local.team_dl
    requested_by        = local.requested_by
  })
  
  # All optional parameters from Okta provider documentation
  accessibility_error_redirect_url     = try(local.tfvars.accessibility_error_redirect_url, null)
  accessibility_login_redirect_url     = try(local.tfvars.accessibility_login_redirect_url, null)
  accessibility_self_service           = try(local.tfvars.accessibility_self_service, null)
  admin_note                           = try(local.tfvars.admin_note, null)
  app_links_json                       = try(local.tfvars.app_links_json, null)
  app_settings_json                    = try(local.tfvars.app_settings_json, null)
  authentication_policy                = try(local.tfvars.authentication_policy, null)
  auto_key_rotation                    = try(local.tfvars.auto_key_rotation, null)
  auto_submit_toolbar                  = try(local.tfvars.auto_submit_toolbar, null)
  client_basic_secret                  = try(local.tfvars.client_basic_secret, null)
  client_id                            = try(local.tfvars.client_id, null)
  client_uri                           = try(local.tfvars.client_uri, null)
  consent_method                       = try(local.tfvars.consent_method, null)
  enduser_note                         = try(local.tfvars.enduser_note, null)
  hide_ios                             = try(local.tfvars.hide_ios, null)
  hide_web                             = try(local.tfvars.hide_web, null)
  implicit_assignment                  = try(local.tfvars.implicit_assignment, null)
  issuer_mode                          = try(local.tfvars.issuer_mode, null)
  jwks_uri                             = try(local.tfvars.jwks_uri, null)
  login_mode                           = try(local.tfvars.login_mode, null)
  login_scopes                         = try(local.tfvars.login_scopes, null)
  login_uri                            = try(local.tfvars.login_uri, null)
  logo                                 = try(local.tfvars.logo, null)
  logo_uri                             = try(local.tfvars.logo_uri, null)
  omit_secret                          = try(local.tfvars.omit_secret, null)
  pkce_required                        = try(local.tfvars.pkce_required, null)
  policy_uri                           = try(local.tfvars.policy_uri, null)
  post_logout_redirect_uris           = try(local.tfvars.post_logout_redirect_uris, null)
  redirect_uris                        = try(local.tfvars.redirect_uris, null)
  refresh_token_leeway                = try(local.tfvars.refresh_token_leeway, null)
  refresh_token_rotation              = try(local.tfvars.refresh_token_rotation, null)
  status                               = try(local.tfvars.status, null)
  tos_uri                              = try(local.tfvars.tos_uri, null)
  user_name_template                   = try(local.tfvars.user_name_template, null)
  user_name_template_push_status      = try(local.tfvars.user_name_template_push_status, null)
  user_name_template_suffix           = try(local.tfvars.user_name_template_suffix, null)
  user_name_template_type             = try(local.tfvars.user_name_template_type, null)
  wildcard_redirect                    = try(local.tfvars.wildcard_redirect, null)
}

# Group for SPA access
resource "okta_group" "spa_oidc_group" {
  name        = try(local.tfvars.group_name, null)
  description = try(local.tfvars.group_description, null)
}

# App-Group Assignment
resource "okta_app_group_assignment" "spa_oidc_assignment" {
  app_id   = okta_app_oauth.spa_oidc.id
  group_id = okta_group.spa_oidc_group.id
}

# Trusted Origin for SPA
resource "okta_trusted_origin" "spa_oidc_origin" {
  name   = try(local.tfvars.trusted_origin_name, null)
  origin = try(local.tfvars.trusted_origin_url, null)
  scopes = try(local.tfvars.trusted_origin_scopes, null)
}

# Bookmark App (optional - for admin access)
resource "okta_app_bookmark" "spa_oidc_bookmark" {
  label                = try(local.tfvars.bookmark_label, null)
  url                  = try(local.tfvars.bookmark_url, null)
  status               = try(local.tfvars.bookmark_status, null)
  auto_submit_toolbar  = try(local.tfvars.bookmark_auto_submit_toolbar, null)
  hide_ios             = try(local.tfvars.bookmark_hide_ios, null)
  hide_web             = try(local.tfvars.bookmark_hide_web, null)
} 