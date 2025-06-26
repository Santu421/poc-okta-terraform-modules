# Root Terraform Configuration
# This file configures the Okta provider and orchestrates the main module

# Okta Provider Configuration
provider "okta" {
  org_name  = var.okta_org_name
  base_url  = var.okta_base_url
  api_token = var.okta_api_token
}

# Call the main orchestration module
module "main" {
  source = "./main"
  
  # Pass through the required variables
  app_config_path = var.app_config_path
  environment     = var.environment
  
  # Pass through all oauth_2leg variables
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

# (Removed module "okta_apps" block as it is not needed) 