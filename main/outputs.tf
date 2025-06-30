# Main Terraform Outputs

# 2-leg OAuth App Outputs
output "oauth_2leg_app_id" {
  description = "2-leg OAuth application ID"
  value       = try(module.oauth_2leg[0].oauth_2leg_app_id, null)
}

output "oauth_2leg_client_id" {
  description = "2-leg OAuth client ID"
  value       = try(module.oauth_2leg[0].oauth_2leg_client_id, null)
}

output "oauth_2leg_client_secret" {
  description = "2-leg OAuth client secret"
  value       = try(module.oauth_2leg[0].oauth_2leg_client_secret, null)
  sensitive   = true
}

output "oauth_2leg_trusted_origin_id" {
  description = "2-leg OAuth trusted origin ID"
  value       = try(module.oauth_2leg[0].oauth_2leg_trusted_origin_id, null)
}

output "oauth_2leg_bookmark_id" {
  description = "2-leg OAuth bookmark app ID"
  value       = try(module.oauth_2leg[0].oauth_2leg_bookmark_id, null)
}

# Summary Outputs
output "app_metadata" {
  description = "Application metadata from YAML"
  value = {
    parent_cmdb_name    = local.metadata.parent_cmdb_name
    division            = local.metadata.division
    cmdb_app_short_name = local.metadata.cmdb_app_short_name
    team_dl             = local.metadata.team_dl
    requested_by        = local.metadata.requested_by
    environment         = var.environment
  }
}

output "created_modules" {
  description = "List of modules that were created"
  value = {
    oauth_2leg          = local.app_config.create_2leg
    oauth_3leg_frontend = local.app_config.create_3leg_frontend
    oauth_3leg_backend  = local.app_config.create_3leg_backend
    oauth_3leg_native   = local.app_config.create_3leg_native
  }
} 