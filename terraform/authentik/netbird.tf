
data "authentik_flow" "default-authorization-flow" {
  slug = "default-provider-authorization-implicit-consent"
}



data "authentik_property_mapping_provider_scope" "scope_email" {
  managed = "goauthentik.io/providers/oauth2/scope-email"
}

data "authentik_property_mapping_provider_scope" "scope_openid" {
  managed = "goauthentik.io/providers/oauth2/scope-openid"
}

data "authentik_property_mapping_provider_scope" "scope_profile" {
  managed = "goauthentik.io/providers/oauth2/scope-profile"
}

data "authentik_property_mapping_provider_scope" "scope_api" {
  managed = "goauthentik.io/providers/oauth2/scope-authentik_api"
}



data "authentik_group" "admins" {
  name = "authentik Admins"
}

data "authentik_certificate_key_pair" "default" {
  name = "authentik Self-signed Certificate"
}

# Netbird Service Account
resource "authentik_user" "netbird_sa" {
  username = "Netbird"
  name     = "Netbird"
  type     = "service_account"
  groups   = [data.authentik_group.admins.id]
}

# Netbird Service Account Token
resource "authentik_token" "netbird_sa_token" {
  identifier   = "netbird-api-token"
  user         = authentik_user.netbird_sa.id
  intent       = "app_password"
  expiring     = false
  retrieve_key = true
}

# Netbird Provider
resource "authentik_provider_oauth2" "netbird" {
  name      = "Netbird"
  client_id = "netbird"

  # Configuration parameters based on docs
  client_type = "public"
  allowed_redirect_uris = [

    {
      matching_mode = "regex"
      url           = "https://vpn.${var.domain}/.*"
    },
    {
      matching_mode = "strict"
      url           = "https://vpn.${var.domain}/auth"
    },
    {
      matching_mode = "strict"
      url           = "https://vpn.${var.domain}/silent-auth"
    },
    {
      matching_mode = "strict"
      url           = "http://localhost:53000"
    }
  ]

  property_mappings = [
    data.authentik_property_mapping_provider_scope.scope_email.id,
    data.authentik_property_mapping_provider_scope.scope_openid.id,
    data.authentik_property_mapping_provider_scope.scope_profile.id,
    data.authentik_property_mapping_provider_scope.scope_api.id
  ]

  authorization_flow = data.authentik_flow.default-authorization-flow.id
  invalidation_flow  = data.authentik_flow.default-provider-invalidation-flow.id
  signing_key        = data.authentik_certificate_key_pair.default.id

  # Advanced settings from docs
  access_code_validity       = "minutes=10"
  sub_mode                   = "user_id"
  include_claims_in_id_token = true
}

# Netbird Application
resource "authentik_application" "netbird" {
  name              = "Netbird"
  slug              = "netbird"
  protocol_provider = authentik_provider_oauth2.netbird.id
  meta_launch_url   = "https://vpn.${var.domain}"
}
