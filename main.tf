resource "kubernetes_namespace_v1" "vault" {
  metadata {
    name = "vault"
  }
}
resource "helm_release" "vault" {
  name      = "vault"
  namespace = kubernetes_namespace_v1.vault.metadata[0].name

  # Use the local Helm chart in this folder
  chart = "${path.module}/vault"

  values = [
    file("${path.module}/vaules-local.yaml")
  ]

  wait    = true
  timeout = 600
}