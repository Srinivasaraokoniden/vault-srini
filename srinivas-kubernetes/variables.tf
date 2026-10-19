

variable "tenant_name" {
  description = "Unique tenant name"
  type        = string
}

variable "tenant_path" {
  description = "Tenant's KV path"
  type        = string
}

variable "role_name" {
  description = "Vault Kubernetes auth role"
  type        = string
}

variable "service_account_name" {
  description = "Application Kubernetes ServiceAccount"
  type        = string
}

variable "kubernetes_namespace" {
  description = "Application Kubernetes namespace"
  type        = string
}

variable "initial_secret" {
  description = "Optional initial secret data for the tenant"
  type        = map(string)
  default     = {}
  sensitive   = true
}