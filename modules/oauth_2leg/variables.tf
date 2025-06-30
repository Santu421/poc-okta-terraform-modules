# OAuth 2-Leg Module Variables

# Group Assignment Variables
variable "okta_authz_groups" {
  description = "OKTA authorization groups to assign to the app"
  type        = set(string)
  default     = ["Everyone"]
}

variable "ldap_groups_data" {
  description = "LDAP groups data for group ID conversion"
  type        = set(string)
  default     = []
}

variable "spapp_groups_data" {
  description = "SPAPP groups data for group ID conversion"
  type        = set(string)
  default     = []
}

variable "app_label" {
  description = "Application display label"
  type        = string
}

variable "token_endpoint_auth_method" {
  description = "Token endpoint authentication method"
  type        = string
  default     = null
}

variable "omit_secret" {
  description = "Omit client secret"
  type        = bool
  default     = null
}

variable "auto_key_rotation" {
  description = "Auto key rotation"
  type        = bool
  default     = null
}

variable "auto_submit_toolbar" {
  description = "Display auto submit toolbar"
  type        = bool
  default     = null
}

variable "hide_ios" {
  description = "Hide from iOS"
  type        = bool
  default     = null
}

variable "hide_web" {
  description = "Hide from web"
  type        = bool
  default     = null
}

variable "issuer_mode" {
  description = "Issuer mode"
  type        = string
  default     = null
}

variable "consent_method" {
  description = "Consent method"
  type        = string
  default     = null
}

variable "login_mode" {
  description = "Login mode"
  type        = string
  default     = null
}

variable "status" {
  description = "Application status"
  type        = string
  default     = null
}

variable "client_basic_secret" {
  description = "Client basic secret"
  type        = string
  default     = null
  sensitive   = true
}

variable "profile" {
  description = "Application profile"
  type        = string
  default     = null
}

variable "accessibility_error_redirect_url" {
  description = "Custom error page URL"
  type        = string
  default     = null
}

variable "accessibility_login_redirect_url" {
  description = "Custom login page URL"
  type        = string
  default     = null
}

variable "accessibility_self_service" {
  description = "Enable self-service"
  type        = bool
  default     = null
}

variable "admin_note" {
  description = "Application notes for admins"
  type        = string
  default     = null
}

variable "enduser_note" {
  description = "Application notes for end users"
  type        = string
  default     = null
}

variable "app_links_json" {
  description = "Application links JSON"
  type        = string
  default     = null
}

variable "app_settings_json" {
  description = "Application settings JSON"
  type        = string
  default     = null
}

variable "authentication_policy" {
  description = "Authentication policy ID"
  type        = string
  default     = null
}

variable "client_id" {
  description = "Client ID"
  type        = string
  default     = null
}

variable "client_uri" {
  description = "Client URI"
  type        = string
  default     = null
}

variable "implicit_assignment" {
  description = "Implicit assignment"
  type        = bool
  default     = null
}

variable "jwks_uri" {
  description = "JWKS URI"
  type        = string
  default     = null
}

variable "login_scopes" {
  description = "Login scopes"
  type        = list(string)
  default     = null
}

variable "login_uri" {
  description = "Login URI"
  type        = string
  default     = null
}

variable "logo" {
  description = "Logo"
  type        = string
  default     = null
}

variable "logo_uri" {
  description = "Logo URI"
  type        = string
  default     = null
}

variable "pkce_required" {
  description = "PKCE required"
  type        = bool
  default     = null
}

variable "policy_uri" {
  description = "Policy URI"
  type        = string
  default     = null
}

variable "post_logout_redirect_uris" {
  description = "Post logout redirect URIs"
  type        = list(string)
  default     = null
}

variable "redirect_uris" {
  description = "Redirect URIs"
  type        = list(string)
  default     = null
}

variable "refresh_token_leeway" {
  description = "Refresh token leeway"
  type        = number
  default     = null
}

variable "refresh_token_rotation" {
  description = "Refresh token rotation"
  type        = string
  default     = null
}

variable "tos_uri" {
  description = "Terms of service URI"
  type        = string
  default     = null
}

variable "user_name_template" {
  description = "User name template"
  type        = string
  default     = null
}

variable "user_name_template_push_status" {
  description = "User name template push status"
  type        = string
  default     = null
}

variable "user_name_template_suffix" {
  description = "User name template suffix"
  type        = string
  default     = null
}

variable "user_name_template_type" {
  description = "User name template type"
  type        = string
  default     = null
}

variable "wildcard_redirect" {
  description = "Wildcard redirect"
  type        = string
  default     = null
} 