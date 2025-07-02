variable "enabled_client_ids" {
  type    = list(string)
}
variable "policy_name" {
  type    = string
}
variable "policy_description" {
  type    = string
}
variable "rule_name" {
  type    = string
}
variable "grant_type_whitelist" {
  type    = list(string)
}
variable "group_whitelist" {
  type    = list(string)
}
variable "scope_whitelist" {
  type    = list(string)
} 