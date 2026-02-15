# Welcome to hsrnet! Flow
resource "authentik_flow" "welcome_flow" {
  name        = "Welcome to hsrnet!"
  title       = "Welcome to hsrnet!"
  slug        = "auth"
  designation = "authentication"
}

# Data sources for default stages
data "authentik_stage" "identification" {
  name = "default-authentication-identification"
}

data "authentik_stage" "password" {
  name = "default-authentication-password"
}

data "authentik_stage" "mfa" {
  name = "default-authentication-mfa-validation"
}

data "authentik_stage" "login" {
  name = "default-authentication-login"
}

# Policies
resource "authentik_policy_expression" "skip_if_app_password" {
  name       = "test-not-app-password"
  expression = "return context.get('auth_method') != 'app_password'"
}

# Custom Identification Stage with Recovery
resource "authentik_stage_identification" "welcome_identification" {
  name          = "welcome-identification"
  user_fields   = ["username", "email"]
  recovery_flow = authentik_flow.recovery.uuid
}

# Bindings
resource "authentik_flow_stage_binding" "welcome_identification" {
  target = authentik_flow.welcome_flow.uuid
  stage  = authentik_stage_identification.welcome_identification.id
  order  = 10
}

resource "authentik_flow_stage_binding" "welcome_password" {
  target = authentik_flow.welcome_flow.uuid
  stage  = data.authentik_stage.password.id
  order  = 20
}

resource "authentik_flow_stage_binding" "welcome_mfa" {
  target = authentik_flow.welcome_flow.uuid
  stage  = data.authentik_stage.mfa.id
  order  = 30
}

resource "authentik_policy_binding" "welcome_mfa_policy" {
  target = authentik_flow_stage_binding.welcome_mfa.id
  policy = authentik_policy_expression.skip_if_app_password.id
  order  = 0
}

resource "authentik_flow_stage_binding" "welcome_login" {
  target = authentik_flow.welcome_flow.uuid
  stage  = data.authentik_stage.login.id
  order  = 100
}

# Device Code Flow
resource "authentik_flow" "device_code" {
  name           = "default-device-code-flow"
  title          = "Device code flow"
  slug           = "default-device-code-flow"
  designation    = "stage_configuration"
  authentication = "require_authenticated"
}
