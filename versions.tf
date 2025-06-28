terraform {
  required_version = ">= 1.0"
  required_providers {
    okta = {
      source  = "okta/okta"
      version = "4.20.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "0.9.1"
    }
  }
} 