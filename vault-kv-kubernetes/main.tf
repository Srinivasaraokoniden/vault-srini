# -------------------------------------------------
# 1. Create KV v2 secrets engine (optional)
# -------------------------------------------------

resource "vault_mount" "kv" {
  count = var.create_kv_mount ? 1 : 0

  path        = var.mount_path
  type        = "kv"
  description = var.mount_description

  options = {
    version = "2"
  }
}



# -------------------------------------------------
# 2. Create tenant-specific Vault policy
# -------------------------------------------------

resource "vault_policy" "tenant" {
  name = "${var.tenant_name}-kv-policy"

  policy = <<-EOT
    # Allow the tenant to create, update and read secrets
    path "${var.mount_path}/data/${var.tenant_path}" {
      capabilities = ["create", "update", "read"]
    }

    path "${var.mount_path}/data/${var.tenant_path}/*" {
      capabilities = ["create", "update", "read"]
    }

    # Allow listing and reading metadata
    path "${var.mount_path}/metadata/${var.tenant_path}" {
      capabilities = ["read", "list"]
    }

    path "${var.mount_path}/metadata/${var.tenant_path}/*" {
      capabilities = ["read", "list"]
    }
  EOT
}

# -------------------------------------------------
# 3. Create Kubernetes auth role for the tenant
# -------------------------------------------------

resource "vault_kubernetes_auth_backend_role" "tenant" {
  backend   = var.auth_mount_path
  role_name = var.role_name

  bound_service_account_names = [
    var.service_account_name
  ]

  bound_service_account_namespaces = [
    var.kubernetes_namespace
  ]

  token_policies = [
    vault_policy.tenant.name
  ]

  token_ttl     = var.token_ttl
  token_max_ttl = var.token_max_ttl
}