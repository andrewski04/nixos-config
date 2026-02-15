# Recovery Flow
resource "authentik_flow" "recovery" {
  name           = "Recovery"
  title          = "Reset your password"
  slug           = "recovery"
  designation    = "recovery"
  authentication = "require_unauthenticated"
}

# Policies

## Expression Policy: Skip if Restored
resource "authentik_policy_expression" "skip_if_restored" {
  name       = "recovery-skip-if-restored"
  expression = "return bool(request.context.get('is_restored', True))"
}

# Stages

## Identification Stage (for recovery)
resource "authentik_stage_identification" "recovery_identification" {
  name        = "recovery-identification"
  user_fields = ["email", "username"]
}

## Email Stage
resource "authentik_stage_email" "recovery_email" {
  name                     = "recovery-email"
  use_global_settings      = true
  subject                  = "Password Recovery"
  template                 = "email/password_reset.html"
  activate_user_on_success = true
}

## Prompt Stage (for setting new password)
resource "authentik_stage_prompt" "recovery_prompt" {
  name = "recovery-prompt"
  fields = [
    authentik_stage_prompt_field.password.id,
    authentik_stage_prompt_field.password_repeat.id
  ]
}

## Password Prompts
resource "authentik_stage_prompt_field" "password" {
  name        = "recovery-password"
  label       = "New Password"
  field_key   = "password"
  type        = "password"
  required    = true
  placeholder = "New Password"
  order       = 10
}

resource "authentik_stage_prompt_field" "password_repeat" {
  name        = "recovery-password-repeat"
  label       = "Confirm Password"
  field_key   = "password_repeat"
  type        = "password"
  required    = true
  placeholder = "Confirm Password"
  order       = 20
}

## User Write Stage (to save the new password)
resource "authentik_stage_user_write" "recovery_user_write" {
  name               = "recovery-user-write"
  user_creation_mode = "never_create"
}

## User Login Stage (to log the user in after reset)
resource "authentik_stage_user_login" "recovery_user_login" {
  name = "recovery-user-login"
}

# Bindings

## Bind Identification to Recovery Flow
resource "authentik_flow_stage_binding" "recovery_identification_binding" {
  target = authentik_flow.recovery.uuid
  stage  = authentik_stage_identification.recovery_identification.id
  order  = 10
}

## Bind Policy to Identification Binding (Skip if restored)
resource "authentik_policy_binding" "recovery_identification_policy_binding" {
  target = authentik_flow_stage_binding.recovery_identification_binding.id
  policy = authentik_policy_expression.skip_if_restored.id
  order  = 0
}

## Bind Email to Recovery Flow
resource "authentik_flow_stage_binding" "recovery_email_binding" {
  target = authentik_flow.recovery.uuid
  stage  = authentik_stage_email.recovery_email.id
  order  = 20
}

## Bind Policy to Email Binding (Skip if restored)
resource "authentik_policy_binding" "recovery_email_policy_binding" {
  target = authentik_flow_stage_binding.recovery_email_binding.id
  policy = authentik_policy_expression.skip_if_restored.id
  order  = 0
}

## Bind Prompt Stage to Recovery Flow
resource "authentik_flow_stage_binding" "recovery_prompt_binding" {
  target = authentik_flow.recovery.uuid
  stage  = authentik_stage_prompt.recovery_prompt.id
  order  = 30
}

## Bind User Write to Recovery Flow
resource "authentik_flow_stage_binding" "recovery_user_write_binding" {
  target = authentik_flow.recovery.uuid
  stage  = authentik_stage_user_write.recovery_user_write.id
  order  = 40
}

## Bind User Login to Recovery Flow
resource "authentik_flow_stage_binding" "recovery_user_login_binding" {
  target = authentik_flow.recovery.uuid
  stage  = authentik_stage_user_login.recovery_user_login.id
  order  = 100
}
