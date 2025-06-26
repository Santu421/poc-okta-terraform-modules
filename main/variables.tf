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

# OAuth 2-Leg variables
variable "app_label" {
  description = "OAuth 2-Leg application label"
  type        = string
  default     = null
}

variable "token_endpoint_auth_method" {
  description = "OAuth 2-Leg token endpoint auth method"
  type        = string
  default     = "client_secret_basic"
}

variable "omit_secret" {
  description = "OAuth 2-Leg omit secret"
  type        = bool
  default     = true
}

variable "auto_key_rotation" {
  description = "OAuth 2-Leg auto key rotation"
  type        = bool
  default     = true
}

variable "auto_submit_toolbar" {
  description = "OAuth 2-Leg auto submit toolbar"
  type        = bool
  default     = false
}

variable "hide_ios" {
  description = "OAuth 2-Leg hide iOS"
  type        = bool
  default     = true
}

variable "hide_web" {
  description = "OAuth 2-Leg hide web"
  type        = bool
  default     = true
}

variable "issuer_mode" {
  description = "OAuth 2-Leg issuer mode"
  type        = string
  default     = "ORG_URL"
}

variable "consent_method" {
  description = "OAuth 2-Leg consent method"
  type        = string
  default     = "TRUSTED"
}

variable "login_mode" {
  description = "OAuth 2-Leg login mode"
  type        = string
  default     = "DISABLED"
}

variable "status" {
  description = "OAuth 2-Leg status"
  type        = string
  default     = "ACTIVE"
}

variable "client_basic_secret" {
  description = "OAuth 2-Leg client basic secret"
  type        = string
  default     = null
  sensitive   = true
}

# Additional optional variables
variable "accessibility_error_redirect_url" {
  description = "Accessibility error redirect URL"
  type        = string
  default     = null
}

variable "accessibility_login_redirect_url" {
  description = "Accessibility login redirect URL"
  type        = string
  default     = null
}

variable "accessibility_self_service" {
  description = "Accessibility self service"
  type        = bool
  default     = null
}

variable "admin_note" {
  description = "Admin note"
  type        = string
  default     = null
}

variable "enduser_note" {
  description = "End user note"
  type        = string
  default     = null
}

variable "app_links_json" {
  description = "App links JSON"
  type        = string
  default     = null
}

variable "app_settings_json" {
  description = "App settings JSON"
  type        = string
  default     = null
}

variable "authentication_policy" {
  description = "Authentication policy"
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