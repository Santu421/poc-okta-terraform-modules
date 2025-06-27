resource "okta_app_bookmark" "this" {
  label  = var.bookmark.label
  url    = var.bookmark.url
  status = var.bookmark.status

  # Optional attributes - only set if provided
  accessibility_error_redirect_url = try(var.bookmark.accessibility_error_redirect_url, null)
  accessibility_login_redirect_url = try(var.bookmark.accessibility_login_redirect_url, null)
  accessibility_self_service       = try(var.bookmark.accessibility_self_service, null)
  admin_note                       = try(var.bookmark.admin_note, null)
  app_links_json                   = try(var.bookmark.app_links_json, null)
  authentication_policy            = try(var.bookmark.authentication_policy, null)
  auto_submit_toolbar              = try(var.bookmark.auto_submit_toolbar, null)
  enduser_note                     = try(var.bookmark.enduser_note, null)
  hide_ios                         = try(var.bookmark.hide_ios, null)
  hide_web                         = try(var.bookmark.hide_web, null)
  logo                             = try(var.bookmark.logo, null)
  request_integration              = try(var.bookmark.request_integration, null)

  # Timeouts block
  dynamic "timeouts" {
    for_each = try(var.bookmark.timeouts, null) != null ? [var.bookmark.timeouts] : []
    content {
      create = try(timeouts.value.create, null)
      read   = try(timeouts.value.read, null)
      update = try(timeouts.value.update, null)
    }
  }
} 