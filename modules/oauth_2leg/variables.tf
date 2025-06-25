# OAuth 2-Leg Module Variables

variable "app_label" {
  description = "Application display label"
  type        = string
}

# Optional OAuth app parameters - only those relevant for 2-leg service apps
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

variable "pkce_required" {
  description = "Require PKCE for authorization code flow"
  type        = bool
  default     = null
}

variable "consent_method" {
  description = "Consent method"
  type        = string
  default     = null
}

variable "custom_client_id" {
  description = "Custom client ID"
  type        = string
  default     = null
}

variable "client_uri" {
  description = "Client URI"
  type        = string
  default     = null
}

variable "logo_uri" {
  description = "Logo URI"
  type        = string
  default     = null
}

variable "policy_uri" {
  description = "Policy URI"
  type        = string
  default     = null
}

variable "tos_uri" {
  description = "Terms of service URI"
  type        = string
  default     = null
}

variable "profile" {
  description = "Application profile"
  type        = map(string)
  default     = null
}

variable "jwks_uri" {
  description = "JWKS URI"
  type        = string
  default     = null
}

variable "client_basic_secret" {
  description = "Client basic secret"
  type        = string
  default     = null
  sensitive   = true
}

variable "token_endpoint_auth_signature" {
  description = "Token endpoint auth signature"
  type        = string
  default     = null
}

variable "trust_groups" {
  description = "Trust groups"
  type        = list(string)
  default     = null
}

variable "trust_zones" {
  description = "Trust zones"
  type        = list(string)
  default     = null
}

variable "custom_setup_property" {
  description = "Custom setup property"
  type        = string
  default     = null
}

variable "external_id" {
  description = "External ID"
  type        = string
  default     = null
}

variable "features" {
  description = "Application features"
  type        = list(string)
  default     = null
}

variable "inline_hook_id" {
  description = "Inline hook ID"
  type        = string
  default     = null
}

variable "notes" {
  description = "Application notes"
  type        = string
  default     = null
}

variable "omit_secret" {
  description = "Omit secret"
  type        = bool
  default     = null
}

variable "pending_changes" {
  description = "Pending changes"
  type        = string
  default     = null
}

variable "sign_on_mode" {
  description = "Sign on mode"
  type        = string
  default     = null
}

variable "status" {
  description = "Application status"
  type        = string
  default     = null
}

variable "timeouts" {
  description = "Timeouts"
  type        = map(string)
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
  default     = ["CORS"]
}

variable "trusted_origin_status" {
  description = "Trusted origin status"
  type        = string
  default     = "ACTIVE"
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
  default     = "ACTIVE"
}

variable "bookmark_auto_submit_toolbar" {
  description = "Bookmark auto submit toolbar"
  type        = bool
  default     = false
}

variable "bookmark_hide_ios" {
  description = "Bookmark hide from iOS"
  type        = bool
  default     = false
}

variable "bookmark_hide_web" {
  description = "Bookmark hide from web"
  type        = bool
  default     = false
} 