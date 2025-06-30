# Root Terraform Outputs

# Debug Outputs for Group Assignment Troubleshooting
output "debug_group_assignment" {
  description = "Debug information for group assignment troubleshooting"
  value = module.main.debug_group_assignment
}

output "debug_na_oidc_authz_groups" {
  description = "Debug information for native OIDC authorization groups"
  value = module.main.debug_na_oidc_authz_groups
}

# Application Metadata
output "app_metadata" {
  description = "Application metadata from YAML"
  value = module.main.app_metadata
}

# Created Modules Status
output "created_modules" {
  description = "List of modules that were created"
  value = module.main.created_modules
}

# Module-specific outputs (exposed at root level)
output "oauth_2leg_app_id" {
  description = "2-leg OAuth application ID"
  value = module.main.oauth_2leg_app_id
}

output "oauth_2leg_client_id" {
  description = "2-leg OAuth client ID"
  value = module.main.oauth_2leg_client_id
}

output "oauth_2leg_client_secret" {
  description = "2-leg OAuth client secret"
  value = module.main.oauth_2leg_client_secret
  sensitive = true
} 