# Main Module Variables

variable "app_config_path" {
  description = "Path to the application configuration files (metadata.yaml and environment.yaml)"
  type        = string
}

variable "app_name" {
  description = "Application name (e.g., AD, XYZ) used in file naming"
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