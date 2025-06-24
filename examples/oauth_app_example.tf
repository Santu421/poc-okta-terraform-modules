# Example: OAuth App with all modules
terraform {
  required_providers {
    okta = {
      source  = "okta/okta"
      version = "~> 4.0"
    }
  }
}

# OAuth App
module "okta_oauth_app" {
  source = "../modules/okta_app_oauth"
  
  app = {
    name         = "example-app"
    label        = "Example OAuth App"
    grant_types  = ["authorization_code"]
    redirect_uris = ["https://example-app.example.com/callback"]
    response_types = ["code"]
    token_endpoint_auth_method = "client_secret_basic"
    auto_submit_toolbar = false
    hide_ios = false
    hide_web = false
  }
}

# Bookmark App
module "okta_bookmark" {
  source = "../modules/okta_app_bookmark"
  
  bookmark = {
    name   = "example-bookmark"
    label  = "Example Bookmark"
    url    = "https://example-bookmark.example.com"
    status = "ACTIVE"
  }
}

# Group
module "okta_group" {
  source = "../modules/okta_group"
  
  group = {
    name        = "Example Group"
    description = "Example group for testing"
  }
}

# Trusted Origin
module "okta_trusted_origin" {
  source = "../modules/okta_trusted_origin"
  
  trusted_origin = {
    name   = "example-origin"
    origin = "https://example-app.example.com"
    scopes = ["CORS", "REDIRECT"]
    status = "ACTIVE"
  }
}

# App-Group Assignments
module "okta_app_group_assignments" {
  source = "../modules/okta_app_group_assignment"
  
  assignments = [
    {
      app_name   = "Example OAuth App"
      group_name = "Example Group"
    },
    {
      app_name   = "Example Bookmark"
      group_name = "Example Group"
    }
  ]
}

# Outputs
output "oauth_app_id" {
  value = module.okta_oauth_app.app_id
}

output "oauth_client_id" {
  value = module.okta_oauth_app.client_id
}

output "bookmark_app_id" {
  value = module.okta_bookmark.app_id
}

output "group_id" {
  value = module.okta_group.group_id
} 