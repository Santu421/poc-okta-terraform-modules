variable "app" {
  description = "OAuth application configuration"
  type = object({
    name         = string
    label        = string
    type         = string
    grant_types  = set(string)
    redirect_uris = list(string)
    response_types = set(string)
    
    # Optional attributes with correct data types
    token_endpoint_auth_method = optional(string)
    accessibility_error_redirect_url = optional(string)
    accessibility_login_redirect_url = optional(string)
    accessibility_self_service = optional(bool)
    admin_note = optional(string)
    app_links_json = optional(string)
    app_settings_json = optional(string)
    authentication_policy = optional(string)
    auto_key_rotation = optional(bool)
    auto_submit_toolbar = optional(bool)
    client_basic_secret = optional(string)
    client_id = optional(string)
    client_uri = optional(string)
    consent_method = optional(string)
    enduser_note = optional(string)
    hide_ios = optional(bool)
    hide_web = optional(bool)
    implicit_assignment = optional(bool)
    issuer_mode = optional(string)
    jwks_uri = optional(string)
    login_mode = optional(string)
    login_scopes = optional(set(string))
    login_uri = optional(string)
    logo = optional(string)
    logo_uri = optional(string)
    omit_secret = optional(bool)
    pkce_required = optional(bool)
    policy_uri = optional(string)
    post_logout_redirect_uris = optional(set(string))
    profile = optional(string)
    refresh_token_leeway = optional(number)
    refresh_token_rotation = optional(string)
    status = optional(string)
    tos_uri = optional(string)
    user_name_template = optional(string)
    user_name_template_push_status = optional(string)
    user_name_template_suffix = optional(string)
    user_name_template_type = optional(string)
    wildcard_redirect = optional(string)
  })
  
  validation {
    condition = contains(["client_secret_basic", "client_secret_post", "client_secret_jwt", "private_key_jwt", "none"], var.app.token_endpoint_auth_method) || var.app.token_endpoint_auth_method == null
    error_message = "token_endpoint_auth_method must be one of: client_secret_basic, client_secret_post, client_secret_jwt, private_key_jwt, none"
  }
  
  validation {
    condition = contains(["ORG_URL", "CUSTOM_URL"], var.app.issuer_mode) || var.app.issuer_mode == null
    error_message = "issuer_mode must be one of: ORG_URL, CUSTOM_URL"
  }
  
  validation {
    condition = contains(["ROTATE", "STATIC"], var.app.refresh_token_rotation) || var.app.refresh_token_rotation == null
    error_message = "refresh_token_rotation must be one of: ROTATE, STATIC"
  }
} 