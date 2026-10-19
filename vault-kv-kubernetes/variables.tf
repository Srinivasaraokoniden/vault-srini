variable "create_kv_mount" {
  description = "Whether to create the shared KV v2 mount"
  type        = bool
  default     = false
}

variable "mount_path" {
  description = "Path of the KV v2 secrets engine"
  type        = string
  default     = "kv"
}

variable "mount_description" {
  description = "Description of the KV secrets engine"
  type        = string
  default     = "KV v2 secrets for tenant applications"
}

variable "tenant_name" {
  description = "Unique tenant identifier"
  type        = string
}

variable "tenant_path" {
  description = "Tenant-specific path inside the KV mount"
  type        = string
}

variable "auth_mount_path" {
  description = "Path where Kubernetes auth is enabled in Vault"
  type        = string
  default     = "kubernetes"
}

variable "role_name" {
  description = "Vault Kubernetes auth role name"
  type        = string
}

variable "service_account_name" {
  description = "Kubernetes ServiceAccount allowed to authenticate"
  type        = string
}

variable "kubernetes_namespace" {
  description = "Kubernetes namespace containing the ServiceAccount"
  type        = string
}

variable "token_ttl" {
  description = "Vault client token TTL in seconds"
  type        = number
  default     = 900
}

variable "token_max_ttl" {
  description = "Maximum Vault client token TTL in seconds"
  type        = number
  default     = 1800
}
