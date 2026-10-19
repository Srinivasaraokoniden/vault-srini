
terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = ">= 5.0, < 6.0"
    }
  }
}

provider "vault" {

}

module "tenant_kv" {
  source = "../vault-kv-kubernetes"

  # The shared KV mount already exists.
  create_kv_mount = true

  mount_path        = "kv"
  mount_description = "Shared tenant KV v2 secrets"

  tenant_name = var.tenant_name
  tenant_path = var.tenant_path

  auth_mount_path      = "kubernetes"
  role_name            = var.role_name
  service_account_name = var.service_account_name
  kubernetes_namespace = var.kubernetes_namespace
  

  token_ttl     = 900
  token_max_ttl = 1800
}
