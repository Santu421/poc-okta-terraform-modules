# Web OIDC Module Variables

variable "app_label" {
  description = "Application display label"
  type        = string
}

variable "redirect_uris" {
  description = "Redirect URIs for the web application"
  type        = list(string)
}

variable "post_logout_uris" {
  description = "Post logout URIs for the web application"
  type        = list(string)
  default     = []
}

# Accessibility parameters
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

# Application metadata
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

variable "auto_key_rotation" {
  description = "Auto key rotation"
  type        = bool
  default     = null
}

variable "auto_submit_toolbar" {
  description = "Display auto submit toolbar"
  type        = bool
  default     = false
}

variable "client_basic_secret" {
  description = "Client basic secret"
  type        = string
  default     = null
  sensitive   = true
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

variable "consent_method" {
  description = "Consent method"
  type        = string
  default     = null
}

variable "grant_types" {
  description = "Grant types"
  type        = set(string)
  default     = null
}

variable "hide_ios" {
  description = "Hide from iOS"
  type        = bool
  default     = false
}

variable "hide_web" {
  description = "Hide from web"
  type        = bool
  default     = false
}

variable "implicit_assignment" {
  description = "Implicit assignment"
  type        = bool
  default     = null
}

variable "issuer_mode" {
  description = "Issuer mode"
  type        = string
  default     = "ORG_URL"
}

variable "jwks_uri" {
  description = "JWKS URI"
  type        = string
  default     = null
}

variable "login_mode" {
  description = "Login mode"
  type        = string
  default     = null
}

variable "login_scopes" {
  description = "Login scopes"
  type        = set(string)
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

variable "omit_secret" {
  description = "Omit secret"
  type        = bool
  default     = null
}

variable "pkce_required" {
  description = "PKCE required"
  type        = bool
  default     = false
}

variable "policy_uri" {
  description = "Policy URI"
  type        = string
  default     = null
}

variable "post_logout_redirect_uris" {
  description = "Post logout redirect URIs"
  type        = set(string)
  default     = null
}

variable "profile" {
  description = "Application profile"
  type        = string
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

variable "response_types" {
  description = "Response types"
  type        = set(string)
  default     = null
}

variable "status" {
  description = "Application status"
  type        = string
  default     = null
}

variable "token_endpoint_auth_method" {
  description = "Token endpoint auth method"
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

# Trusted Origin variables
variable "trusted_origin_name" {
  description = "Trusted origin name"
  type        = string
  default     = null
}

variable "trusted_origin_url" {
  description = "Trusted origin URL"
  type        = string
  default     = null
}

variable "trusted_origin_scopes" {
  description = "Trusted origin scopes"
  type        = list(string)
  default     = null
}

variable "trusted_origin_status" {
  description = "Trusted origin status"
  type        = string
  default     = null
}

# Bookmark variables
variable "bookmark_label" {
  description = "Bookmark app label"
  type        = string
  default     = null
}

variable "bookmark_url" {
  description = "Bookmark app URL"
  type        = string
  default     = null
}

variable "bookmark_status" {
  description = "Bookmark app status"
  type        = string
  default     = null
}

variable "bookmark_auto_submit_toolbar" {
  description = "Bookmark auto submit toolbar"
  type        = bool
  default     = null
}

variable "bookmark_hide_ios" {
  description = "Bookmark hide from iOS"
  type        = bool
  default     = null
}

variable "bookmark_hide_web" {
  description = "Bookmark hide from web"
  type        = bool
  default     = null
} 