# Main Terraform Configuration
# This file orchestrates the creation of Okta resources based on YAML configurations

# Extract short app name from app_config_path
locals {
  app_short_name = basename(var.app_config_path)
}

# Read and parse the metadata file
locals {
  metadata_file = file("${var.app_config_path}/${local.app_short_name}-metadata.yaml")
  metadata      = yamldecode(local.metadata_file)
  
  # Extract metadata values
  parent_cmdb_name    = local.metadata.parent_cmdb_name
  division            = local.metadata.division
  cmdb_app_short_name = local.metadata.cmdb_app_short_name
  team_dl             = local.metadata.team_dl
  requested_by        = local.metadata.requested_by
}

# Read and parse the environment-specific config file
locals {
  env_config_file = file("${var.app_config_path}/${var.environment}/${local.cmdb_app_short_name}-${var.environment}.yaml")
  env_config      = yamldecode(local.env_config_file)
  
  # Extract environment config values
  environment = local.env_config.environment
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
}

# Create 3-leg frontend OAuth app if enabled
module "oauth_3leg_frontend" {
  count  = local.app_config.create_3leg_frontend ? 1 : 0
  source = "../modules/spa_oidc"
  
  app_config_path = var.app_config_path
}

# Create 3-leg backend OAuth app if enabled
module "oauth_3leg_backend" {
  count  = local.app_config.create_3leg_backend ? 1 : 0
  source = "../modules/web_oidc"
  
  app_label = "${local.division}_${local.cmdb_app_short_name}_OIDC_WA"
  client_id = "${local.division}_${local.cmdb_app_short_name}_OIDC_WA"
  
  # Set profile with all metadata fields
  profile = jsonencode({
    parent_cmdb_name    = local.parent_cmdb_name
    division            = local.division
    cmdb_app_short_name = local.cmdb_app_short_name
    team_dl             = local.team_dl
    requested_by        = local.requested_by
  })
  
  # OAuth configuration
  redirect_uris = try(local.oauth_config.redirect_uris, [])
  post_logout_uris = try(local.oauth_config.post_logout_uris, [])
  
  # Group configuration
  group_name = "${local.division}_${local.cmdb_app_short_name}_WA_ACCESS_${upper(local.environment)}"
  group_description = "Access group for ${local.parent_cmdb_name} Backend (${local.environment})"
  
  # Trusted origin
  trusted_origin_name = "${local.division}_${local.cmdb_app_short_name}_WA_ORIGIN_${upper(local.environment)}"
  trusted_origin_url = try(local.trusted_origins[0].url, "https://${lower(local.cmdb_app_short_name)}-${local.environment}.example.com")
  trusted_origin_scopes = ["CORS", "REDIRECT"]
  
  # Bookmark
  bookmark_label = "${local.parent_cmdb_name} Backend Admin (${local.environment})"
  bookmark_url = try(local.bookmarks[0].url, "https://${lower(local.cmdb_app_short_name)}-${local.environment}.example.com")
}

# Create 3-leg native OAuth app if enabled
module "oauth_3leg_native" {
  count  = local.app_config.create_3leg_native ? 1 : 0
  source = "../modules/na_oidc"
  
  app_label = "${local.division}_${local.cmdb_app_short_name}_OIDC_NA"
  client_id = "${local.division}_${local.cmdb_app_short_name}_OIDC_NA"
  
  # Set profile with all metadata fields
  profile = jsonencode({
    parent_cmdb_name    = local.parent_cmdb_name
    division            = local.division
    cmdb_app_short_name = local.cmdb_app_short_name
    team_dl             = local.team_dl
    requested_by        = local.requested_by
  })
  
  # OAuth configuration
  redirect_uris = try(local.oauth_config.redirect_uris, [])
  post_logout_uris = try(local.oauth_config.post_logout_uris, [])
  
  # Group configuration
  group_name = "${local.division}_${local.cmdb_app_short_name}_NA_ACCESS_${upper(local.environment)}"
  group_description = "Access group for ${local.parent_cmdb_name} Native (${local.environment})"
  
  # Trusted origin
  trusted_origin_name = "${local.division}_${local.cmdb_app_short_name}_NA_ORIGIN_${upper(local.environment)}"
  trusted_origin_url = try(local.trusted_origins[0].url, "https://${lower(local.cmdb_app_short_name)}-${local.environment}.example.com")
  trusted_origin_scopes = ["CORS", "REDIRECT"]
  
  # Bookmark
  bookmark_label = "${local.parent_cmdb_name} Native Admin (${local.environment})"
  bookmark_url = try(local.bookmarks[0].url, "https://${lower(local.cmdb_app_short_name)}-${local.environment}.example.com")
} 