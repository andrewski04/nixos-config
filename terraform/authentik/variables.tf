variable "authentik_api_url" {
  type    = string
  default = "https://sso.hsr.wtf"
}

variable "authentik_api_token" {
  type      = string
  sensitive = true
}

variable "domain" {
  type    = string
  default = "hsr.wtf"
}
