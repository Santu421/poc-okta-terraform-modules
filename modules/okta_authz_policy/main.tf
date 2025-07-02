resource "okta_auth_server_policy" "oauth_access_policy" {
  auth_server_id  = "default"
  name            = var.policy_name
  description     = var.policy_description
  status          = "ACTIVE"
  priority        = 1
  client_whitelist = var.enabled_client_ids
  
  depends_on = [var.oauth_app_dependencies]
}

resource "okta_auth_server_policy_rule" "oauth_access_rule" {
  auth_server_id         = "default"
  policy_id              = okta_auth_server_policy.oauth_access_policy.id
  name                   = var.rule_name
  status                 = "ACTIVE"
  priority               = 1
  grant_type_whitelist   = var.grant_type_whitelist
  group_whitelist        = var.group_whitelist
  scope_whitelist        = var.scope_whitelist
} 