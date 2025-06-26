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

# 3-leg Frontend OAuth App Outputs
# output "oauth_3leg_frontend_app_id" {
#   description = "3-leg frontend OAuth application ID"
#   value       = try(module.oauth_3leg_frontend[0].spa_oidc_app_id, null)
# }

# output "oauth_3leg_frontend_client_id" {
#   description = "3-leg frontend OAuth client ID"
#   value       = try(module.oauth_3leg_frontend[0].spa_oidc_client_id, null)
# }

# output "oauth_3leg_frontend_group_id" {
#   description = "3-leg frontend OAuth group ID"
#   value       = try(module.oauth_3leg_frontend[0].spa_oidc_group_id, null)
# }

# output "oauth_3leg_frontend_trusted_origin_id" {
#   description = "3-leg frontend OAuth trusted origin ID"
#   value       = try(module.oauth_3leg_frontend[0].spa_oidc_trusted_origin_id, null)
# }

# output "oauth_3leg_frontend_bookmark_id" {
#   description = "3-leg frontend OAuth bookmark app ID"
#   value       = try(module.oauth_3leg_frontend[0].spa_oidc_bookmark_id, null)
# }

# 3-leg Backend OAuth App Outputs
# output "oauth_3leg_backend_app_id" {
#   description = "3-leg backend OAuth application ID"
#   value       = try(module.oauth_3leg_backend[0].web_oidc_app_id, null)
# }

# output "oauth_3leg_backend_client_id" {
#   description = "3-leg backend OAuth client ID"
#   value       = try(module.oauth_3leg_backend[0].web_oidc_client_id, null)
# }

# output "oauth_3leg_backend_client_secret" {
#   description = "3-leg backend OAuth client secret"
#   value       = try(module.oauth_3leg_backend[0].web_oidc_client_secret, null)
#   sensitive   = true
# }

# output "oauth_3leg_backend_group_id" {
#   description = "3-leg backend OAuth group ID"
#   value       = try(module.oauth_3leg_backend[0].web_oidc_group_id, null)
# }

# output "oauth_3leg_backend_trusted_origin_id" {
#   description = "3-leg backend OAuth trusted origin ID"
#   value       = try(module.oauth_3leg_backend[0].web_oidc_trusted_origin_id, null)
# }

# output "oauth_3leg_backend_bookmark_id" {
#   description = "3-leg backend OAuth bookmark app ID"
#   value       = try(module.oauth_3leg_backend[0].web_oidc_bookmark_id, null)
# }

# 3-leg Native OAuth App Outputs
# output "oauth_3leg_native_app_id" {
#   description = "3-leg native OAuth application ID"
#   value       = try(module.oauth_3leg_native[0].na_oidc_app_id, null)
# }

# output "oauth_3leg_native_client_id" {
#   description = "3-leg native OAuth client ID"
#   value       = try(module.oauth_3leg_native[0].na_oidc_client_id, null)
# }

# output "oauth_3leg_native_client_secret" {
#   description = "3-leg native OAuth client secret"
#   value       = try(module.oauth_3leg_native[0].na_oidc_client_secret, null)
#   sensitive   = true
# }

# output "oauth_3leg_native_group_id" {
#   description = "3-leg native OAuth group ID"
#   value       = try(module.oauth_3leg_native[0].na_oidc_group_id, null)
# }

# output "oauth_3leg_native_trusted_origin_id" {
#   description = "3-leg native OAuth trusted origin ID"
#   value       = try(module.oauth_3leg_native[0].na_oidc_trusted_origin_id, null)
# }

# output "oauth_3leg_native_bookmark_id" {
#   description = "3-leg native OAuth bookmark app ID"
#   value       = try(module.oauth_3leg_native[0].na_oidc_bookmark_id, null)
# }

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