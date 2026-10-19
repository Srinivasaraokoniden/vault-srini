output "role_id" {
  description = "AppRole Role ID for the Srinivas application"
  value       = module.srinivas_transit.role_id
}

output "secret_id" {
  description = "AppRole Secret ID for the Srinivas application"
  value       = module.srinivas_transit.secret_id
  sensitive = true
}