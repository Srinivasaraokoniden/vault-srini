output "payments_role_id" {
  value = module.payments_app.role_id
}

output "payments_secret_id" {
  value     = module.payments_app.secret_id
  sensitive = true
}

output "orders_role_id" {
  value = module.orders_app.role_id
}

output "orders_secret_id" {
  value     = module.orders_app.secret_id
  sensitive = true
}