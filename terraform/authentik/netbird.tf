
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


data "authentik_group" "admins" {
  name = "authentik Admins"
}

data "authentik_certificate_key_pair" "default" {
  name = "authentik Self-signed Certificate"
}

# Netbird Service Account
resource "authentik_user" "netbird_sa" {
  username = "netbird"
  name     = "netbird"
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
  name          = "Netbird"
  client_id     = "netbird"
  client_secret = "netbird-secret-placeholder-replaced-by-authentik"

  # Configuration parameters based on docs
  client_type = "public"
  allowed_redirect_uris = [

    {
      matching_mode = "regex"
      url           = "https://netbird.${var.domain}/.*"
    },
    {
      matching_mode = "strict"
      url           = "https://netbird.${var.domain}/auth"
    },
    {
      matching_mode = "strict"
      url           = "https://netbird.${var.domain}/silent-auth"
    },
    {
      matching_mode = "strict"
      url           = "http://localhost:53000"
    }
  ]

  property_mappings = [
    data.authentik_property_mapping_provider_scope.scope_email.id,
    data.authentik_property_mapping_provider_scope.scope_openid.id,
    data.authentik_property_mapping_provider_scope.scope_profile.id
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
  meta_launch_url   = "https://netbird.${var.domain}"
}

resource "local_file" "netbird_setup_env" {
  filename        = "/var/lib/netbird/setup.env"
  file_permission = "0600" # Initial permission
  content         = <<EOT
# Management variables
NETBIRD_AUTH_OIDC_CONFIGURATION_ENDPOINT="${var.authentik_api_url}/application/o/netbird/.well-known/openid-configuration"
NETBIRD_USE_AUTH0=false
NETBIRD_AUTH_CLIENT_ID="${authentik_provider_oauth2.netbird.client_id}"
NETBIRD_AUTH_SUPPORTED_SCOPES="openid profile email offline_access api"
NETBIRD_AUTH_AUDIENCE="${authentik_provider_oauth2.netbird.client_id}"
NETBIRD_AUTH_DEVICE_AUTH_CLIENT_ID="${authentik_provider_oauth2.netbird.client_id}"
NETBIRD_AUTH_DEVICE_AUTH_AUDIENCE="${authentik_provider_oauth2.netbird.client_id}"
NETBIRD_MGMT_IDP="authentik"
NETBIRD_IDP_MGMT_CLIENT_ID="${authentik_provider_oauth2.netbird.client_id}"
NETBIRD_IDP_MGMT_EXTRA_USERNAME="netbird"
NETBIRD_IDP_MGMT_EXTRA_PASSWORD="${authentik_token.netbird_sa_token.key}"
NETBIRD_AUTH_REDIRECT_URI="/auth"
NETBIRD_AUTH_SILENT_REDIRECT_URI="/silent-auth"
NETBIRD_AUTH_PKCE_DISABLE_PROMPT_LOGIN=true

# Dashboard variables (standard OIDC params)
AUTH_CLIENT_ID="${authentik_provider_oauth2.netbird.client_id}"
AUTH_AUTHORITY="${var.authentik_api_url}/application/o/netbird/"
AUTH_AUDIENCE="${authentik_provider_oauth2.netbird.client_id}"
EOT
}

resource "null_resource" "fix_netbird_env_permissions" {
  triggers = {
    file_content = local_file.netbird_setup_env.content
  }

  provisioner "local-exec" {
    command = "chown netbird:netbird /var/lib/netbird/setup.env || true"
  }
}
