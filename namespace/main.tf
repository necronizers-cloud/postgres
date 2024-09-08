// Namespace for Postgres Cluster
resource "kubernetes_namespace" "postgres" {
  metadata {
    name = var.namespace
    labels = {
      app       = "postgres"
      component = "namespace"
    }
  }
}
