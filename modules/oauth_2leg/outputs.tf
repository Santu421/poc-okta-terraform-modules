# OAuth 2-Leg Module Outputs

output "oauth_2leg_app_id" {
  description = "OAuth 2-Leg application ID"
  value       = okta_app_oauth.oauth_2leg.id
}

output "oauth_2leg_client_id" {
  description = "OAuth 2-Leg client ID"
  value       = okta_app_oauth.oauth_2leg.client_id
}

output "oauth_2leg_client_secret" {
  description = "OAuth 2-Leg client secret"
  value       = okta_app_oauth.oauth_2leg.client_secret
  sensitive   = true
} 