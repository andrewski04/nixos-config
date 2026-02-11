// get default user settings flow
data "authentik_flow" "default-user-settings-flow" {
  slug = "default-user-settings-flow"
}

// get default invalidation flow
data "authentik_flow" "default-invalidation-flow" {
  slug = "default-invalidation-flow"
}

// get default provider invalidation flow
data "authentik_flow" "default-provider-invalidation-flow" {
  slug = "default-provider-invalidation-flow"
}

// enable hsrnet branding
resource "authentik_brand" "hsrnet" {
  domain              = var.domain
  default             = false
  branding_title      = "HsrNet Auth"
  branding_logo       = "${var.authentik_api_url}/media/hsrnet-logo.png"
  branding_favicon    = "${var.authentik_api_url}/media/hsrnet-ico.ico"
  flow_authentication = authentik_flow.welcome_flow.uuid
  flow_invalidation   = data.authentik_flow.default-invalidation-flow.id
  #flow_recovery       = data.authentik_flow.default-recovery-flow.id
  #flow_unenrollment   = data.authentik_flow.default-unenrollment-flow.id
  flow_user_settings = data.authentik_flow.default-user-settings-flow.id
  #flow_device_code    = data.authentik_flow.default-provider-authorization-device-code-flow.id
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
