output "policy_id" {
  value = okta_auth_server_policy.oauth_access_policy.id
}

output "rule_id" {
  value = okta_auth_server_policy_rule.oauth_access_rule.id
} 