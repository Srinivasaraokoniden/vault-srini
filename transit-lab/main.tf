module "payments_app" {
  source = "../transit-conf"

  transit_mount_path = "app-crypto"
  transit_key_name   = "payments-key"

  approle_mount_path = "transit-app-auth"
  approle_name       = "payments-api-role"
  policy_name        = "payments-encrypt-only"

  token_ttl     = 900
  token_max_ttl = 1800
}

# Example: create a second, independent Transit setup
module "orders_app" {
  source = "../transit-conf"

  transit_mount_path = "orders-crypto"
  transit_key_name   = "orders-key"

  approle_mount_path = "orders-app-auth"
  approle_name       = "orders-api-role"
  policy_name        = "orders-encrypt-only"

  token_ttl     = 900
  token_max_ttl = 1800
}