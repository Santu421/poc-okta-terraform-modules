# Main Module Variables

variable "app_config_path" {
  description = "Path to the application configuration files (metadata.yaml and environment.yaml)"
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
    app = object({
      # Required fields
      label = string  # Required per Okta docs
      client_id = string  # Required per Okta docs
      
      # Optional fields in schema order
      type = optional(string, "service")  # Default for 2-leg apps
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
      grant_types = optional(set(string), ["client_credentials"])  # Default for 2-leg
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
      pkce_required = optional(bool, false)  # Usually false for 2-leg
      policy_uri = optional(string)
      post_logout_redirect_uris = optional(set(string))
      redirect_uris = optional(list(string))
      refresh_token_leeway = optional(number)
      refresh_token_rotation = optional(string)
      response_types = optional(set(string), ["token"])  # Default for 2-leg
      status = optional(string, "ACTIVE")
      token_endpoint_auth_method = optional(string, "client_secret_basic")
      tos_uri = optional(string)
      user_name_template = optional(string)
      user_name_template_push_status = optional(string)
      user_name_template_suffix = optional(string)
      user_name_template_type = optional(string, "BUILT_IN")
      wildcard_redirect = optional(string)
    })
    
    group = optional(object({
      name = string
      description = string
    }))
    
    trusted_origin = optional(object({
      name = string
      url = string
      scopes = list(string)
    }))
    
    bookmark = optional(object({
      label = string
      url = string
      status = optional(string, "ACTIVE")
      auto_submit_toolbar = optional(bool, false)
      hide_ios = optional(bool, false)
      hide_web = optional(bool, false)
    }))
  })
  sensitive = false
}

# SPA 3-Leg Configuration Map
variable "spa" {
  description = "SPA 3-Leg application configuration"
  type = object({
    app = object({
      # Required fields
      label = string  # Required per Okta docs
      client_id = string  # Required per Okta docs
      
      # Optional fields in schema order
      type = optional(string, "browser")  # Default for SPA apps
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
      grant_types = optional(set(string), ["authorization_code"])  # Default for SPA
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
      pkce_required = optional(bool, true)  # Required for SPAs
      policy_uri = optional(string)
      post_logout_redirect_uris = optional(set(string))
      redirect_uris = optional(list(string))
      refresh_token_leeway = optional(number)
      refresh_token_rotation = optional(string)
      response_types = optional(set(string), ["code"])  # Default for SPA
      status = optional(string, "ACTIVE")
      token_endpoint_auth_method = optional(string, "none")
      tos_uri = optional(string)
      user_name_template = optional(string)
      user_name_template_push_status = optional(string)
      user_name_template_suffix = optional(string)
      user_name_template_type = optional(string, "BUILT_IN")
      wildcard_redirect = optional(string)
    })
    
    group = optional(object({
      name = string
      description = string
    }))
    
    trusted_origin = optional(object({
      name = string
      url = string
      scopes = list(string)
    }))
    
    bookmark = optional(object({
      label = string
      url = string
      status = optional(string, "ACTIVE")
      auto_submit_toolbar = optional(bool, false)
      hide_ios = optional(bool, false)
      hide_web = optional(bool, false)
    }))
  })
  sensitive = false
}

# Native OIDC Configuration Map
variable "na" {
  description = "Native OIDC application configuration"
  type = object({
    app = object({
      # Required fields
      label = string  # Required per Okta docs
      client_id = string  # Required per Okta docs
      
      # Optional fields in schema order
      type = optional(string, "native")  # Default for Native apps
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
      grant_types = optional(set(string), ["password", "refresh_token", "authorization_code"])  # Default for Native
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
      pkce_required = optional(bool, true)  # Required for Native apps
      policy_uri = optional(string)
      post_logout_redirect_uris = optional(set(string))
      redirect_uris = optional(list(string))
      refresh_token_leeway = optional(number)
      refresh_token_rotation = optional(string)
      response_types = optional(set(string), ["code"])  # Default for Native
      status = optional(string, "ACTIVE")
      token_endpoint_auth_method = optional(string, "client_secret_basic")
      tos_uri = optional(string)
      user_name_template = optional(string)
      user_name_template_push_status = optional(string)
      user_name_template_suffix = optional(string)
      user_name_template_type = optional(string, "BUILT_IN")
      wildcard_redirect = optional(string)
    })
    
    group = optional(object({
      name = string
      description = string
    }))
    
    trusted_origin = optional(object({
      name = string
      url = string
      scopes = list(string)
    }))
    
    bookmark = optional(object({
      label = string
      url = string
      status = optional(string, "ACTIVE")
      auto_submit_toolbar = optional(bool, false)
      hide_ios = optional(bool, false)
      hide_web = optional(bool, false)
    }))
  })
  sensitive = false
}

# Web OIDC Configuration Map
variable "web" {
  description = "Web OIDC application configuration"
  type = object({
    app = object({
      # Required fields
      label = string  # Required per Okta docs
      client_id = string  # Required per Okta docs
      
      # Optional fields in schema order
      type = optional(string, "web")  # Default for Web apps
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
      grant_types = optional(set(string), ["authorization_code", "refresh_token", "client_credentials"])  # Default for Web
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
      pkce_required = optional(bool, true)  # Required for Web apps
      policy_uri = optional(string)
      post_logout_redirect_uris = optional(set(string))
      redirect_uris = optional(list(string))
      refresh_token_leeway = optional(number)
      refresh_token_rotation = optional(string)
      response_types = optional(set(string), ["code"])  # Default for Web
      status = optional(string, "ACTIVE")
      token_endpoint_auth_method = optional(string, "client_secret_basic")
      tos_uri = optional(string)
      user_name_template = optional(string)
      user_name_template_push_status = optional(string)
      user_name_template_suffix = optional(string)
      user_name_template_type = optional(string, "BUILT_IN")
      wildcard_redirect = optional(string)
    })
    
    group = optional(object({
      name = string
      description = string
    }))
    
    trusted_origin = optional(object({
      name = string
      url = string
      scopes = list(string)
    }))
    
    bookmark = optional(object({
      label = string
      url = string
      status = optional(string, "ACTIVE")
      auto_submit_toolbar = optional(bool, false)
      hide_ios = optional(bool, false)
      hide_web = optional(bool, false)
    }))
  })
  sensitive = false
} 