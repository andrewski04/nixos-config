resource "authentik_application" "search" {
  name              = "Search"
  slug              = "search"
  meta_launch_url   = "https://search.${var.domain}"
}
