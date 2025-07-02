variable "enabled_client_ids" {
  description = "List of enabled OAuth client IDs for the policy"
  type        = list(string)
}
variable "policy_name" {
  description = "Name of the authorization server policy"
  type        = string
}
variable "policy_description" {
  description = "Description of the authorization server policy"
  type        = string
}
variable "rule_name" {
  description = "Name of the authorization server policy rule"
  type        = string
}
variable "grant_type_whitelist" {
  description = "List of allowed grant types"
  type        = list(string)
}
variable "group_whitelist" {
  description = "List of allowed groups"
  type        = list(string)
}
variable "scope_whitelist" {
  description = "List of allowed scopes"
  type        = list(string)
}
variable "oauth_app_dependencies" {
  description = "Dependencies on OAuth apps to ensure they are created before the policy"
  type        = any
  default     = []
} 