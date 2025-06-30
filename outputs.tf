# Root Terraform Outputs

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