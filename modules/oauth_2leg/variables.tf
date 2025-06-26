# OAuth 2-Leg Module Variables

variable "app_config_path" {
  description = "Path to the application configuration directory containing 2leg-api.tfvars"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, uat, prod)"
  type        = string
} 