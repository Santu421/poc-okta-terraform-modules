# OAuth 2-Leg Module Variables

variable "app_config_path" {
  description = "Path to the application configuration directory containing 2leg-api.tfvars"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, uat, prod)"
  type        = string
}

variable "profile" {
  description = "Application profile with metadata"
  type        = string
}

variable "division" {
  description = "Division name"
  type        = string
}

variable "cmdb_app_short_name" {
  description = "CMDB application short name"
  type        = string
} 