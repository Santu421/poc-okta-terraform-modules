# Native OIDC Module Outputs

# Debug Outputs for Group Assignment Troubleshooting
output "debug_authz_groups" {
  description = "Debug information for authorization groups"
  value = {
    okta_authz_groups = var.okta_authz_groups
    ldap_groups_data = var.ldap_groups_data
    spapp_groups_data = var.spapp_groups_data
    okta_groups_count = length(var.okta_authz_groups)
    ldap_groups_count = length(var.ldap_groups_data)
    spapp_groups_count = length(var.spapp_groups_data)
    found_okta_groups = {
      for group_name, group_data in data.okta_group.authz_groups : group_name => {
        name = group_data.name
        id = group_data.id
        description = group_data.description
      }
    }
    found_ldap_groups = {
      for group_name, group_data in data.okta_group.ldap_groups : group_name => {
        name = group_data.name
        id = group_data.id
        description = group_data.description
      }
    }
    found_spapp_groups = {
      for group_name, group_data in data.okta_group.spapp_groups : group_name => {
        name = group_data.name
        id = group_data.id
        description = group_data.description
      }
    }
    missing_okta_groups = setsubtract(var.okta_authz_groups, keys(data.okta_group.authz_groups))
    missing_ldap_groups = setsubtract(var.ldap_groups_data, keys(data.okta_group.ldap_groups))
    missing_spapp_groups = setsubtract(var.spapp_groups_data, keys(data.okta_group.spapp_groups))
  }
}

output "na_oidc_app_id" {
  description = "Native OIDC application ID"
  value       = okta_app_oauth.na_oidc.id
}

output "na_oidc_client_id" {
  description = "Native OIDC client ID"
  value       = okta_app_oauth.na_oidc.client_id
}

output "na_oidc_client_secret" {
  description = "Native OIDC client secret"
  value       = okta_app_oauth.na_oidc.client_secret
  sensitive   = true
}

# output "na_oidc_group_id" {
#   description = "Native OIDC group ID"
#   value       = okta_group.na_oidc_group.id
# }

output "na_oidc_trusted_origin_id" {
  description = "Native OIDC trusted origin ID"
  value       = okta_trusted_origin.na_oidc_origin.id
}

output "na_oidc_bookmark_id" {
  description = "Native OIDC bookmark app ID"
  value       = try(okta_app_bookmark.na_oidc_bookmark[0].id, null)
} 