# Root Terraform Variables

# Okta Provider Variables
variable "okta_org_name" {
  description = "Okta organization name"
  type        = string
}

variable "okta_base_url" {
  description = "Okta base URL (e.g., https://your-org.okta.com)"
  type        = string
}

variable "okta_api_token" {
  description = "Okta API token"
  type        = string
  sensitive   = true
}

# Application Configuration Variables
variable "app_config_path" {
  description = "Path to the application configuration directory"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, uat, prod)"
  type        = string
  validation {
    condition     = contains(["dev", "uat", "prod"], var.environment)
    error_message = "Environment must be one of: dev, uat, prod."
  }
}

# OAuth 2-Leg Configuration Map
variable "oauth2" {
  description = "OAuth 2-Leg application configuration"
  type = object({
    app_label = optional(string)
    token_endpoint_auth_method = optional(string, "client_secret_basic")
    omit_secret = optional(bool, true)
    auto_key_rotation = optional(bool, true)
    auto_submit_toolbar = optional(bool, false)
    hide_ios = optional(bool, true)
    hide_web = optional(bool, true)
    issuer_mode = optional(string, "ORG_URL")
    consent_method = optional(string, "TRUSTED")
    login_mode = optional(string, "DISABLED")
    status = optional(string, "ACTIVE")
    client_basic_secret = optional(string)
    client_id = optional(string)
    
    # Additional optional variables
    accessibility_error_redirect_url = optional(string)
    accessibility_login_redirect_url = optional(string)
    accessibility_self_service = optional(bool)
    admin_note = optional(string)
    enduser_note = optional(string)
    app_links_json = optional(string)
    app_settings_json = optional(string)
    authentication_policy = optional(string)
    client_uri = optional(string)
    implicit_assignment = optional(bool)
    jwks_uri = optional(string)
    login_scopes = optional(list(string))
    login_uri = optional(string)
    logo = optional(string)
    logo_uri = optional(string)
    pkce_required = optional(bool)
    policy_uri = optional(string)
    post_logout_redirect_uris = optional(list(string))
    redirect_uris = optional(list(string))
    refresh_token_leeway = optional(number)
    refresh_token_rotation = optional(string)
    tos_uri = optional(string)
    user_name_template = optional(string)
    user_name_template_push_status = optional(string)
    user_name_template_suffix = optional(string)
    user_name_template_type = optional(string)
    wildcard_redirect = optional(string)
  })
  default = {}
  sensitive = false
}

# SPA 3-Leg Configuration Map
variable "spa" {
  description = "SPA 3-Leg application configuration"
  type = object({
    app_label = optional(string)
    token_endpoint_auth_method = optional(string, "none")
    omit_secret = optional(bool, true)
    auto_key_rotation = optional(bool, true)
    auto_submit_toolbar = optional(bool, false)
    hide_ios = optional(bool, false)
    hide_web = optional(bool, false)
    issuer_mode = optional(string, "ORG_URL")
    consent_method = optional(string, "TRUSTED")
    login_mode = optional(string, "DISABLED")
    status = optional(string, "ACTIVE")
    client_basic_secret = optional(string)
    client_id = optional(string)
    pkce_required = optional(bool, true)
    redirect_uris = optional(list(string))
    post_logout_redirect_uris = optional(list(string))
    
    # Additional optional OAuth variables
    accessibility_error_redirect_url = optional(string)
    accessibility_login_redirect_url = optional(string)
    accessibility_self_service = optional(bool)
    admin_note = optional(string)
    enduser_note = optional(string)
    app_links_json = optional(string)
    app_settings_json = optional(string)
    authentication_policy = optional(string)
    client_uri = optional(string)
    implicit_assignment = optional(bool)
    jwks_uri = optional(string)
    login_scopes = optional(list(string))
    login_uri = optional(string)
    logo = optional(string)
    logo_uri = optional(string)
    policy_uri = optional(string)
    refresh_token_leeway = optional(number)
    refresh_token_rotation = optional(string)
    tos_uri = optional(string)
    user_name_template = optional(string)
    user_name_template_push_status = optional(string)
    user_name_template_suffix = optional(string)
    user_name_template_type = optional(string)
    wildcard_redirect = optional(string)
    
    # Group variables
    group_name = optional(string)
    group_description = optional(string)
    
    # Trusted Origin variables
    trusted_origin_name = optional(string)
    trusted_origin_url = optional(string)
    trusted_origin_scopes = optional(list(string), ["CORS", "REDIRECT"])
    
    # Bookmark variables
    bookmark_label = optional(string)
    bookmark_url = optional(string)
    bookmark_status = optional(string, "ACTIVE")
    bookmark_auto_submit_toolbar = optional(bool, false)
    bookmark_hide_ios = optional(bool, false)
    bookmark_hide_web = optional(bool, false)
  })
  default = {}
  sensitive = false
} 