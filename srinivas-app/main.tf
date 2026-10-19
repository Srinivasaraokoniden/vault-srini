module "srinivas_transit" {
  source = "git::https://github.com/Srinivasaraokoniden/vault-transit.git?ref=v1.0.0"

  transit_mount_path = var.transit_mount_path
  transit_key_name   = var.transit_key_name
  policy_name        = var.policy_name

  approle_mount_path = var.approle_mount_path
  approle_name       = var.approle_name

  token_ttl     = var.token_ttl
  token_max_ttl = var.token_max_ttl
}