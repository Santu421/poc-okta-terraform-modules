terraform {
  required_providers {
    okta = {
      source  = "okta/okta"
      version = "4.20.0"
    }
  }
}

# Native OIDC Module (Mobile/Native Applications)
# This module creates OAuth applications for native/mobile applications

resource "okta_app_oauth" "na_oidc" {
  label                                = var.app_label
  type                                 = "native"
  grant_types                          = ["password", "refresh_token", "authorization_code"]
  redirect_uris                        = var.redirect_uris
  post_logout_redirect_uris           = var.post_logout_uris
  response_types                       = ["code"]
  token_endpoint_auth_method          = "client_secret_basic"
  pkce_required                        = var.pkce_required
  
  # All optional parameters from Okta provider documentation
  accessibility_error_redirect_url     = try(var.accessibility_error_redirect_url, null)
  accessibility_login_redirect_url     = try(var.accessibility_login_redirect_url, null)
  accessibility_self_service           = try(var.accessibility_self_service, null)
  admin_note                           = try(var.admin_note, null)
  app_links_json                       = try(var.app_links_json, null)
  app_settings_json                    = try(var.app_settings_json, null)
  authentication_policy                = try(var.authentication_policy, null)
  auto_key_rotation                    = try(var.auto_key_rotation, null)
  auto_submit_toolbar                  = try(var.auto_submit_toolbar, null)
  client_basic_secret                  = try(var.client_basic_secret, null)
  client_id                            = try(var.client_id, null)
  client_uri                           = try(var.client_uri, null)
  consent_method                       = try(var.consent_method, null)
  enduser_note                         = try(var.enduser_note, null)
  hide_ios                             = try(var.hide_ios, null)
  hide_web                             = try(var.hide_web, null)
  implicit_assignment                  = try(var.implicit_assignment, null)
  issuer_mode                          = try(var.issuer_mode, null)  # Read-only — used only for output
  jwks_uri                             = try(var.jwks_uri, null)
  login_mode                           = try(var.login_mode, null)
  login_scopes                         = try(var.login_scopes, null)
  login_uri                            = try(var.login_uri, null)
  logo                                 = try(var.logo, null)
  logo_uri                             = try(var.logo_uri, null)
  omit_secret                          = try(var.omit_secret, null)
  policy_uri                           = try(var.policy_uri, null)
  profile                              = try(var.profile, null)
  refresh_token_leeway                = try(var.refresh_token_leeway, null)
  refresh_token_rotation              = try(var.refresh_token_rotation, null)
  status                               = try(var.status, null)
  tos_uri                              = try(var.tos_uri, null)
  user_name_template                   = try(var.user_name_template, null)
  user_name_template_push_status      = try(var.user_name_template_push_status, null)
  user_name_template_suffix           = try(var.user_name_template_suffix, null)
  user_name_template_type             = try(var.user_name_template_type, null)
  wildcard_redirect                    = try(var.wildcard_redirect, null)
}

# Group for native app access
resource "okta_group" "na_oidc_group" {
  name        = var.group_name
  description = var.group_description
}

# App-Group Assignment
resource "okta_app_group_assignment" "na_oidc_assignment" {
  app_id   = okta_app_oauth.na_oidc.id
  group_id = okta_group.na_oidc_group.id
}

# Trusted Origin for native app
resource "okta_trusted_origin" "na_oidc_origin" {
  name   = var.trusted_origin_name
  origin = var.trusted_origin_url
  scopes = var.trusted_origin_scopes
}

# Bookmark App (optional - for admin access)
resource "okta_app_bookmark" "na_oidc_bookmark" {
  label                = var.bookmark_label
  url                  = var.bookmark_url
  status               = var.bookmark_status
  auto_submit_toolbar  = var.bookmark_auto_submit_toolbar
  hide_ios             = var.bookmark_hide_ios
  hide_web             = var.bookmark_hide_web
} 