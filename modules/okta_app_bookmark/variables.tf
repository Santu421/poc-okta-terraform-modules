variable "bookmark" {
  description = "Bookmark application configuration"
  type = object({
    name   = string
    label  = string
    url    = string
    status = optional(string, "ACTIVE")
    
    # Optional attributes
    accessibility_error_redirect_url = optional(string)
    accessibility_login_redirect_url = optional(string)
    accessibility_self_service       = optional(bool, false)
    admin_note                       = optional(string)
    app_links_json                   = optional(string)
    authentication_policy            = optional(string)
    auto_submit_toolbar              = optional(bool)
    enduser_note                     = optional(string)
    hide_ios                         = optional(bool)
    hide_web                         = optional(bool)
    logo                             = optional(string)
    request_integration              = optional(bool)
    
    # Timeouts block
    timeouts = optional(object({
      create = optional(string)
      read   = optional(string)
      update = optional(string)
    }))
  })
  
  validation {
    condition = contains(["ACTIVE", "INACTIVE"], var.bookmark.status)
    error_message = "status must be one of: ACTIVE, INACTIVE"
  }
} 