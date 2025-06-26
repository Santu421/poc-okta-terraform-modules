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
  description = "Path to the application configuration files (metadata.yaml and environment.yaml)"
  type        = string
  default     = "./app-config"
}

variable "environment" {
  description = "Environment name (dev, uat, prod)"
  type        = string
  validation {
    condition     = contains(["dev", "uat", "prod"], var.environment)
    error_message = "Environment must be one of: dev, uat, prod."
  }
} 