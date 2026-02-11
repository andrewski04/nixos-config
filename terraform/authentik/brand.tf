// disable default branding
data "authentik_brand" "authentik-default" {
  domain = "authentik-default"
}

import {
  to = authentik_brand.authentik-default
  id = data.authentik_brand.authentik-default.id
}

resource "authentik_brand" "authentik-default" {
  default = false
  domain = "authentik-default"
}

// enable hsrnet branding
resource "authentik_brand" "hsrnet" {
  domain = "hsr.wtf"
  default = true
  branding_title = "HsrNet Auth"
  branding_logo  = "https://sso.hsr.wtf/media/hsrnet-logo.png"
  branding_favicon = "https://sso.hsr.wtf/media/hsrnet-ico.ico"
  flow_authentication = authentik_flow.welcome_flow.uuid
  branding_custom_css = <<EOT
    body {
      --ak-global--background-image: null !important;
    }
  EOT
  attributes = jsonencode({
    settings = {
      theme = {
        base = "dark"
      }
    }
  })
}
