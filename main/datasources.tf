# Data sources for group IDs (used in profiles)
data "okta_group" "spa_ldap_groups" {
  for_each = local.spa_ldap_groups_data
  name     = each.value
  include_users = false
}

data "okta_group" "spa_spapp_groups" {
  for_each = local.spa_spapp_groups_data
  name     = each.value
  include_users = false
}

data "okta_group" "web_ldap_groups" {
  for_each = local.web_ldap_groups_data
  name     = each.value
  include_users = false
}

data "okta_group" "web_spapp_groups" {
  for_each = local.web_spapp_groups_data
  name     = each.value
  include_users = false
}

data "okta_group" "na_ldap_groups" {
  for_each = local.na_ldap_groups_data
  name     = each.value
  include_users = false
}

data "okta_group" "na_spapp_groups" {
  for_each = local.na_spapp_groups_data
  name     = each.value
  include_users = false
}

# Data sources for OKTA authorization groups (used for assignments)
data "okta_group" "spa_authz_groups" {
  for_each = local.spa_okta_authz_groups
  name     = each.value
  include_users = false
}

data "okta_group" "web_authz_groups" {
  for_each = local.web_okta_authz_groups
  name     = each.value
  include_users = false
}

data "okta_group" "na_authz_groups" {
  for_each = local.na_okta_authz_groups
  name     = each.value
  include_users = false
} 