# Root Terraform Variables

# Provider Configuration
variable "okta_org_name" {
  description = "Okta organization name"
  type        = string
}

variable "okta_base_url" {
  description = "Okta base URL"
  type        = string
}

variable "okta_api_token" {
  description = "Okta API token"
  type        = string
  sensitive   = true
}

# Application Configuration
variable "app_config_path" {
  description = "Path to the application configuration files"
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

# 2-Leg OAuth Configuration Object
variable "oauth2" {
  description = "2-Leg OAuth application configuration"
  type = object({
    # Required fields
    label = string
    client_id = string
    
    # Optional fields in schema order
    type = optional(string, "service")
    accessibility_error_redirect_url = optional(string)
    accessibility_login_redirect_url = optional(string)
    accessibility_self_service = optional(bool, false)
    admin_note = optional(string)
    app_links_json = optional(string)
    app_settings_json = optional(string)
    authentication_policy = optional(string)
    auto_key_rotation = optional(bool, true)
    auto_submit_toolbar = optional(bool, false)
    client_basic_secret = optional(string)
    client_uri = optional(string)
    consent_method = optional(string, "TRUSTED")
    enduser_note = optional(string)
    grant_types = optional(set(string), ["client_credentials"])
    hide_ios = optional(bool, true)
    hide_web = optional(bool, true)
    implicit_assignment = optional(bool)
    issuer_mode = optional(string, "ORG_URL")
    jwks_uri = optional(string)
    login_mode = optional(string, "DISABLED")
    login_scopes = optional(set(string))
    login_uri = optional(string)
    logo = optional(string)
    logo_uri = optional(string)
    omit_secret = optional(bool, true)
    pkce_required = optional(bool, false)
    policy_uri = optional(string)
    post_logout_redirect_uris = optional(set(string))
    redirect_uris = optional(list(string))
    refresh_token_leeway = optional(number)
    refresh_token_rotation = optional(string)
    response_types = optional(set(string), ["token"])
    status = optional(string, "ACTIVE")
    token_endpoint_auth_method = optional(string, "client_secret_basic")
    tos_uri = optional(string)
    user_name_template = optional(string)
    user_name_template_push_status = optional(string)
    user_name_template_suffix = optional(string)
    user_name_template_type = optional(string, "BUILT_IN")
    wildcard_redirect = optional(string)
  })
  default = null
}

# 3-Leg SPA Configuration Object
variable "spa" {
  description = "3-Leg SPA application configuration"
  type = object({
    # Required fields
    label = string
    client_id = string
    
    # Optional fields in schema order
    type = optional(string, "browser")
    accessibility_error_redirect_url = optional(string)
    accessibility_login_redirect_url = optional(string)
    accessibility_self_service = optional(bool, false)
    admin_note = optional(string)
    app_links_json = optional(string)
    app_settings_json = optional(string)
    authentication_policy = optional(string)
    auto_key_rotation = optional(bool, true)
    auto_submit_toolbar = optional(bool, false)
    client_basic_secret = optional(string)
    client_uri = optional(string)
    consent_method = optional(string, "TRUSTED")
    enduser_note = optional(string)
    grant_types = optional(set(string), ["authorization_code"])
    hide_ios = optional(bool, false)
    hide_web = optional(bool, false)
    implicit_assignment = optional(bool)
    issuer_mode = optional(string, "ORG_URL")
    jwks_uri = optional(string)
    login_mode = optional(string, "DISABLED")
    login_scopes = optional(set(string))
    login_uri = optional(string)
    logo = optional(string)
    logo_uri = optional(string)
    omit_secret = optional(bool, true)
    pkce_required = optional(bool, true)
    policy_uri = optional(string)
    post_logout_redirect_uris = optional(set(string))
    redirect_uris = optional(list(string))
    refresh_token_leeway = optional(number)
    refresh_token_rotation = optional(string)
    response_types = optional(set(string), ["code"])
    status = optional(string, "ACTIVE")
    token_endpoint_auth_method = optional(string, "none")
    tos_uri = optional(string)
    user_name_template = optional(string)
    user_name_template_push_status = optional(string)
    user_name_template_suffix = optional(string)
    user_name_template_type = optional(string, "BUILT_IN")
    wildcard_redirect = optional(string)
    
    # Additional SPA-specific variables
    group_name = optional(string)
    group_description = optional(string)
    trusted_origin_name = optional(string)
    trusted_origin_url = optional(string)
    trusted_origin_scopes = optional(list(string), ["CORS", "REDIRECT"])
    bookmark_label = optional(string)
    bookmark_url = optional(string)
    bookmark_status = optional(string, "ACTIVE")
    bookmark_auto_submit_toolbar = optional(bool, false)
    bookmark_hide_ios = optional(bool, false)
    bookmark_hide_web = optional(bool, false)
  })
  default = null
} 