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

# Bindings
resource "authentik_flow_stage_binding" "welcome_identification" {
  target = authentik_flow.welcome_flow.uuid
  stage  = data.authentik_stage.identification.id
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

resource "authentik_flow_stage_binding" "welcome_login" {
  target = authentik_flow.welcome_flow.uuid
  stage  = data.authentik_stage.login.id
  order  = 100
}
