terraform {
  required_providers {
    authentik = {
      source = "goauthentik/authentik"
      version = "2025.12.1"
    }
  }
}

# Variable for Authentik API URL
variable "authentik_api_url" {
  type    = string
  default = "https://sso.hsr.wtf"
}

# Variable for Authentik API Token
variable "authentik_api_token" {
  type      = string
  sensitive = true
}

provider "authentik" {
  url   = var.authentik_api_url
  token = var.authentik_api_token
}


# Test Group
resource "authentik_group" "test_group" {
  name = "Test Group"
}

# Test User
resource "authentik_user" "test_user" {
  username = "test-user"
  name     = "Test User"
  groups   = [authentik_group.test_group.id]
}
