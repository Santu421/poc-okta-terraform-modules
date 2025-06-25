# Main Terraform Configuration
# This file orchestrates the creation of Okta resources based on YAML configurations

terraform {
  required_version = ">= 1.0"
  required_providers {
    okta = {
      source  = "okta/okta"
      version = "~> 4.0"
    }
  }
}

# Okta Provider Configuration
provider "okta" {
  org_name  = var.okta_org_name
  base_url  = var.okta_base_url
  api_token = var.okta_api_token
}

# Read and parse the metadata file
locals {
  metadata_file = file("${var.app_config_path}/metadata.yaml")
  metadata      = yamldecode(local.metadata_file)
  
  # Extract metadata values
  parent_cmdb_name    = local.metadata.parent_cmdb_name
  division_name       = local.metadata.division_name
  cmdb_app_short_name = local.metadata.cmdb_app_short_name
  team_dl             = local.metadata.team_dl
  requested_by        = local.metadata.requested_by
}

# Read and parse the environment-specific config file
locals {
  env_config_file = file("${var.app_config_path}/${var.environment}.yaml")
  env_config      = yamldecode(local.env_config_file)
  
  # Extract environment config values
  environment = local.env_config.environment
  app_config  = local.env_config.app_config
  oauth_config = local.env_config.oauth_config
  trusted_origins = local.env_config.trusted_origins
  bookmarks = local.env_config.bookmarks
}

# Create 2-leg OAuth app if enabled
module "oauth_2leg" {
  count  = local.app_config.create_2leg ? 1 : 0
  source = "./modules/oauth_2leg"
  
  app_label = "${local.division_name}_${local.cmdb_app_short_name}_API_SVCS_${upper(local.environment)}"
  
  # Pass through any optional parameters from YAML if they exist
  auto_submit_toolbar = try(local.env_config.auto_submit_toolbar, null)
  hide_ios            = try(local.env_config.hide_ios, null)
  hide_web            = try(local.env_config.hide_web, null)
  issuer_mode         = try(local.env_config.issuer_mode, null)
  notes               = try(local.env_config.notes, null)
  status              = try(local.env_config.status, null)
  
  # Trusted origin (if specified in YAML)
  trusted_origin_name = try(local.trusted_origins[0].name, null)
  trusted_origin_url  = try(local.trusted_origins[0].url, null)
  trusted_origin_scopes = try(local.trusted_origins[0].scopes, ["CORS"])
  trusted_origin_status = try(local.trusted_origins[0].status, "ACTIVE")
  
  # Bookmark (if specified in YAML)
  bookmark_label = try(local.bookmarks[0].name, null)
  bookmark_url   = try(local.bookmarks[0].url, null)
  bookmark_status = try(local.bookmarks[0].status, "ACTIVE")
  bookmark_auto_submit_toolbar = try(local.bookmarks[0].auto_submit_toolbar, false)
  bookmark_hide_ios = try(local.bookmarks[0].hide_ios, false)
  bookmark_hide_web = try(local.bookmarks[0].hide_web, false)
}

# Create 3-leg frontend OAuth app if enabled
module "oauth_3leg_frontend" {
  count  = local.app_config.create_3leg_frontend ? 1 : 0
  source = "./modules/spa_oidc"
  
  app_label = "${local.division_name}_${local.cmdb_app_short_name}_OIDC_SPA_${upper(local.environment)}"
  
  # OAuth configuration
  grant_types = ["authorization_code", "refresh_token"]
  redirect_uris = local.oauth_config.redirect_uris
  post_logout_uris = try(local.oauth_config.post_logout_uris, [])
  response_types = ["code"]
  token_endpoint_auth_method = "none"
  
  # Group configuration
  group_name = "${local.division_name}_${local.cmdb_app_short_name}_SPA_ACCESS_${upper(local.environment)}"
  group_description = "Access group for ${local.parent_cmdb_name} Frontend (${local.environment})"
  
  # Trusted origin
  trusted_origin_name = "${local.division_name}_${local.cmdb_app_short_name}_SPA_ORIGIN_${upper(local.environment)}"
  trusted_origin_url = try(local.trusted_origins[0].url, "https://${lower(local.cmdb_app_short_name)}-${local.environment}.example.com")
  trusted_origin_scopes = ["CORS", "REDIRECT"]
  
  # Bookmark
  bookmark_name = "${local.division_name}_${local.cmdb_app_short_name}_SPA_BOOKMARK_${upper(local.environment)}"
  bookmark_label = "${local.parent_cmdb_name} Frontend Admin (${local.environment})"
  bookmark_url = try(local.bookmarks[0].url, "https://${lower(local.cmdb_app_short_name)}-${local.environment}.example.com")
}

# Create 3-leg backend OAuth app if enabled
module "oauth_3leg_backend" {
  count  = local.app_config.create_3leg_backend ? 1 : 0
  source = "./modules/web_oidc"
  
  app_label = "${local.division_name}_${local.cmdb_app_short_name}_OIDC_WA_${upper(local.environment)}"
  
  # OAuth configuration
  grant_types = ["authorization_code", "refresh_token"]
  redirect_uris = local.oauth_config.redirect_uris
  post_logout_uris = try(local.oauth_config.post_logout_uris, [])
  response_types = ["code"]
  token_endpoint_auth_method = "client_secret_basic"
  
  # Group configuration
  group_name = "${local.division_name}_${local.cmdb_app_short_name}_WA_ACCESS_${upper(local.environment)}"
  group_description = "Access group for ${local.parent_cmdb_name} Backend (${local.environment})"
  
  # Trusted origin
  trusted_origin_name = "${local.division_name}_${local.cmdb_app_short_name}_WA_ORIGIN_${upper(local.environment)}"
  trusted_origin_url = try(local.trusted_origins[0].url, "https://${lower(local.cmdb_app_short_name)}-${local.environment}.example.com")
  trusted_origin_scopes = ["CORS", "REDIRECT"]
  
  # Bookmark
  bookmark_name = "${local.division_name}_${local.cmdb_app_short_name}_WA_BOOKMARK_${upper(local.environment)}"
  bookmark_label = "${local.parent_cmdb_name} Backend Admin (${local.environment})"
  bookmark_url = try(local.bookmarks[0].url, "https://${lower(local.cmdb_app_short_name)}-${local.environment}.example.com")
}

# Create 3-leg native OAuth app if enabled
module "oauth_3leg_native" {
  count  = local.app_config.create_3leg_native ? 1 : 0
  source = "./modules/na_oidc"
  
  app_label = "${local.division_name}_${local.cmdb_app_short_name}_OIDC_NA_${upper(local.environment)}"
  
  # OAuth configuration
  grant_types = ["password", "refresh_token", "authorization_code"]
  redirect_uris = local.oauth_config.redirect_uris
  post_logout_uris = try(local.oauth_config.post_logout_uris, [])
  response_types = ["code"]
  token_endpoint_auth_method = "client_secret_basic"
  
  # Group configuration
  group_name = "${local.division_name}_${local.cmdb_app_short_name}_NA_ACCESS_${upper(local.environment)}"
  group_description = "Access group for ${local.parent_cmdb_name} Native (${local.environment})"
  
  # Trusted origin
  trusted_origin_name = "${local.division_name}_${local.cmdb_app_short_name}_NA_ORIGIN_${upper(local.environment)}"
  trusted_origin_url = try(local.trusted_origins[0].url, "https://${lower(local.cmdb_app_short_name)}-${local.environment}.example.com")
  trusted_origin_scopes = ["CORS", "REDIRECT"]
  
  # Bookmark
  bookmark_name = "${local.division_name}_${local.cmdb_app_short_name}_NA_BOOKMARK_${upper(local.environment)}"
  bookmark_label = "${local.parent_cmdb_name} Native Admin (${local.environment})"
  bookmark_url = try(local.bookmarks[0].url, "https://${lower(local.cmdb_app_short_name)}-${local.environment}.example.com")
} 