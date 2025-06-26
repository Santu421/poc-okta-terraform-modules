# Main Terraform Configuration
# This file orchestrates the creation of Okta resources based on YAML configurations

locals {
  # Read and parse the metadata file (shared across all modules)
  metadata_file = file("${var.app_config_path}/${basename(var.app_config_path)}-metadata.yaml")
  metadata      = yamldecode(local.metadata_file)
  
  # Common profile for all modules
  common_profile = jsonencode({
    parent_cmdb_name    = local.metadata.parent_cmdb_name
    division            = local.metadata.division
    cmdb_app_short_name = local.metadata.cmdb_app_short_name
    team_dl             = local.metadata.team_dl
    requested_by        = local.metadata.requested_by
  })
  
  # Read and parse the environment-specific config file
  env_config_file = file("${var.app_config_path}/${var.environment}/${local.metadata.cmdb_app_short_name}-${var.environment}.yaml")
  env_config      = yamldecode(local.env_config_file)
  
  # Extract environment config values
  app_config  = local.env_config.app_config
  
  # Optional fields that may not exist in simple configs
  oauth_config = try(local.env_config.oauth_config, {})
  trusted_origins = try(local.env_config.trusted_origins, [])
  bookmarks = try(local.env_config.bookmarks, [])
}

# Create 2-leg OAuth app if enabled
module "oauth_2leg" {
  count  = local.app_config.create_2leg ? 1 : 0
  source = "../modules/oauth_2leg"
  
  app_config_path = var.app_config_path
  environment     = var.environment
  profile         = local.common_profile
  division        = local.metadata.division
  cmdb_app_short_name = local.metadata.cmdb_app_short_name
}

# Create 3-leg frontend OAuth app if enabled
# module "oauth_3leg_frontend" {
#   count  = local.app_config.create_3leg_frontend ? 1 : 0
#   source = "../modules/spa_oidc"
#   
#   app_config_path = var.app_config_path
#   environment     = var.environment
#   profile         = local.common_profile
#   division        = local.metadata.division
#   cmdb_app_short_name = local.metadata.cmdb_app_short_name
# }

# Create 3-leg backend OAuth app if enabled
# module "oauth_3leg_backend" {
#   count  = local.app_config.create_3leg_backend ? 1 : 0
#   source = "../modules/web_oidc"
#   
#   app_config_path = var.app_config_path
#   environment     = var.environment
#   profile         = local.common_profile
#   division        = local.metadata.division
#   cmdb_app_short_name = local.metadata.cmdb_app_short_name
# }

# Create 3-leg native OAuth app if enabled
# module "oauth_3leg_native" {
#   count  = local.app_config.create_3leg_native ? 1 : 0
#   source = "../modules/na_oidc"
#   
#   app_config_path = var.app_config_path
#   environment     = var.environment
#   profile         = local.common_profile
#   division        = local.metadata.division
#   cmdb_app_short_name = local.metadata.cmdb_app_short_name
# } 