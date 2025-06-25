# OAuth 2-Leg Module (API Services)
# This module creates OAuth applications for server-to-server API authentication

resource "okta_app_oauth" "oauth_2leg" {
  label                      = var.app_label
  type                       = "service"
  grant_types                = ["client_credentials"]
  response_types             = ["token"]
  token_endpoint_auth_method = "client_secret_basic"
  
  # Optional parameters using try() function - only those relevant for 2-leg
  auto_submit_toolbar        = try(var.auto_submit_toolbar, null)
  hide_ios                   = try(var.hide_ios, null)
  hide_web                   = try(var.hide_web, null)
  issuer_mode                = try(var.issuer_mode, null)
  pkce_required              = try(var.pkce_required, null)
  consent_method            = try(var.consent_method, null)
  custom_client_id          = try(var.custom_client_id, null)
  client_uri                = try(var.client_uri, null)
  logo_uri                  = try(var.logo_uri, null)
  policy_uri                = try(var.policy_uri, null)
  tos_uri                   = try(var.tos_uri, null)
  profile                   = try(var.profile, null)
  jwks_uri                  = try(var.jwks_uri, null)
  client_basic_secret       = try(var.client_basic_secret, null)
  token_endpoint_auth_signature = try(var.token_endpoint_auth_signature, null)
  trust_groups              = try(var.trust_groups, null)
  trust_zones               = try(var.trust_zones, null)
  custom_setup_property     = try(var.custom_setup_property, null)
  external_id               = try(var.external_id, null)
  features                  = try(var.features, null)
  inline_hook_id            = try(var.inline_hook_id, null)
  notes                     = try(var.notes, null)
  omit_secret               = try(var.omit_secret, null)
  pending_changes           = try(var.pending_changes, null)
  sign_on_mode              = try(var.sign_on_mode, null)
  status                    = try(var.status, null)
  timeouts                  = try(var.timeouts, null)

  lifecycle {
    ignore_changes = [groups]
  }
}

# Group for API access
resource "okta_group" "oauth_2leg_group" {
  name        = var.group_name
  description = var.group_description
  type        = var.group_type
}

# App-Group Assignment
resource "okta_app_group_assignment" "oauth_2leg_assignment" {
  app_id   = okta_app_oauth.oauth_2leg.id
  group_id = okta_group.oauth_2leg_group.id
}

# Trusted Origin (if needed for API endpoints)
resource "okta_trusted_origin" "oauth_2leg_origin" {
  count  = var.trusted_origin_url != null ? 1 : 0
  name   = var.trusted_origin_name
  origin = var.trusted_origin_url
  scopes = var.trusted_origin_scopes
  status = var.trusted_origin_status
}

# Bookmark App (optional - for admin access)
resource "okta_app_bookmark" "oauth_2leg_bookmark" {
  count               = var.bookmark_url != null ? 1 : 0
  label               = var.bookmark_label
  url                 = var.bookmark_url
  status              = var.bookmark_status
  auto_submit_toolbar = var.bookmark_auto_submit_toolbar
  hide_ios            = var.bookmark_hide_ios
  hide_web            = var.bookmark_hide_web
} 