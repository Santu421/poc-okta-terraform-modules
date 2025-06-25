resource "okta_app_oauth" "this" {
  label                                = var.app.label
  type                                 = var.app.type
  grant_types                          = var.app.grant_types
  redirect_uris                        = var.app.redirect_uris
  response_types                       = var.app.response_types
  token_endpoint_auth_method          = try(var.app.token_endpoint_auth_method, null)
  
  # All optional parameters from Okta provider documentation
  accessibility_error_redirect_url     = try(var.app.accessibility_error_redirect_url, null)
  accessibility_login_redirect_url     = try(var.app.accessibility_login_redirect_url, null)
  accessibility_self_service           = try(var.app.accessibility_self_service, null)
  admin_note                           = try(var.app.admin_note, null)
  app_links_json                       = try(var.app.app_links_json, null)
  app_settings_json                    = try(var.app.app_settings_json, null)
  authentication_policy                = try(var.app.authentication_policy, null)
  auto_key_rotation                    = try(var.app.auto_key_rotation, null)
  auto_submit_toolbar                  = try(var.app.auto_submit_toolbar, null)
  client_basic_secret                  = try(var.app.client_basic_secret, null)
  client_id                            = try(var.app.client_id, null)
  client_uri                           = try(var.app.client_uri, null)
  consent_method                       = try(var.app.consent_method, null)
  enduser_note                         = try(var.app.enduser_note, null)
  hide_ios                             = try(var.app.hide_ios, null)
  hide_web                             = try(var.app.hide_web, null)
  implicit_assignment                  = try(var.app.implicit_assignment, null)
  issuer_mode                          = try(var.app.issuer_mode, null)
  jwks_uri                             = try(var.app.jwks_uri, null)
  login_mode                           = try(var.app.login_mode, null)
  login_scopes                         = try(var.app.login_scopes, null)
  login_uri                            = try(var.app.login_uri, null)
  logo                                 = try(var.app.logo, null)
  logo_uri                             = try(var.app.logo_uri, null)
  omit_secret                          = try(var.app.omit_secret, null)
  pkce_required                        = try(var.app.pkce_required, null)
  policy_uri                           = try(var.app.policy_uri, null)
  post_logout_redirect_uris           = try(var.app.post_logout_redirect_uris, null)
  profile                              = try(var.app.profile, null)
  refresh_token_leeway                = try(var.app.refresh_token_leeway, null)
  refresh_token_rotation              = try(var.app.refresh_token_rotation, null)
  status                               = try(var.app.status, null)
  tos_uri                              = try(var.app.tos_uri, null)
  user_name_template                   = try(var.app.user_name_template, null)
  user_name_template_push_status      = try(var.app.user_name_template_push_status, null)
  user_name_template_suffix           = try(var.app.user_name_template_suffix, null)
  user_name_template_type             = try(var.app.user_name_template_type, null)
  wildcard_redirect                    = try(var.app.wildcard_redirect, null)
} 