


# Test Group
resource "authentik_group" "test_group" {
  name = "Test Group"
}

# Test User
resource "authentik_user" "test_user" {
  username = "test-user"
  name     = "Test User"
  groups   = [authentik_group.test_group.id]
}
