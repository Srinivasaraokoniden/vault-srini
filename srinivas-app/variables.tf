variable "transit_mount_path" {
  description = "Transit secrets engine mount path"
  type        = string
}

variable "transit_key_name" {
  description = "Transit encryption key name"
  type        = string
}

variable "policy_name" {
  description = "Encrypt/decrypt policy name"
  type        = string
}

variable "approle_mount_path" {
  description = "Vault AppRole auth mount path"
  type        = string
}

variable "approle_name" {
  description = "Application AppRole name"
  type        = string
}

variable "token_ttl" {
  type        = number
  description = "Vault token TTL in seconds"
}

variable "token_max_ttl" {
  type        = number
  description = "Maximum Vault token TTL in seconds"
}