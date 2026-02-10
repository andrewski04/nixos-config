data "authentik_brand" "authentik-default" {
  domain = "authentik-default"
}

import {
  to = authentik_brand.authentik-default
  id = data.authentik_brand.authentik-default.id
}

resource "authentik_brand" "authentik-default" {
  domain         = "hsr.wtf"
  default        = true
  branding_title = "HsrNet Auth"
  branding_logo  = "https://auth.hsr.wtf/media/hsrnet-logo.png"
  branding_favicon = "https://auth.hsr.wtf/media/hsrnet-ico.ico"
  branding_custom_css = <<-EOT
    .pf-c-background-image {
      --ak-flow-background: #242424 !important;
      --pf-c-background-image--BackgroundColor: #242424 !important;
    }
  EOT
}