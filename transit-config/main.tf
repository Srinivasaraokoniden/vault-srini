resource "vault_mount" "transit" {
  path        = "transit"
  type        = "transit"
  description = "Application encryption service"
}

resource "vault_transit_secret_backend_key" "app_key" {
  backend          = vault_mount.transit.path
  name             = "app-key"
  type             = "aes256-gcm96"
  deletion_allowed = false
}

resource "vault_policy" "transit_encrypt" {
  name = "transit-app-encrypt"

  policy = <<-EOT
    path "transit/encrypt/app-key" {
      capabilities = ["update"]
    }
    path "transit/decrypt/app-key" {
      capabilities = ["update"]
    }
  EOT
}

resource "vault_auth_backend" "approle" {
  type = "approle"
}

resource "vault_approle_auth_backend_role" "transit_app" {
  backend        = vault_auth_backend.approle.path
  role_name      = "transit-app"
  token_policies = [vault_policy.transit_encrypt.name]
  token_ttl      = 900
  token_max_ttl  = 1800

  bind_secret_id = true
}


resource "vault_approle_auth_backend_role_secret_id" "transit_app" {
  backend   = vault_auth_backend.approle.path
  role_name = vault_approle_auth_backend_role.transit_app.role_name
}



output "role_id" {
  description = "AppRole RoleID for the application"
  value       = vault_approle_auth_backend_role.transit_app.role_id
}

output "secret_id" {
  description = "AppRole SecretID for the application"
  value       = vault_approle_auth_backend_role_secret_id.transit_app.secret_id
  sensitive   = true
}

