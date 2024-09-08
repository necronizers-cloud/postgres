// Fetch MinIO Certificate Authority for PITR Backups
data "kubernetes_secret" "minio_certificate_authority" {
  metadata {
    name      = var.minio_certificate_authority
    namespace = var.minio_namespace
  }
}

resource "kubernetes_secret" "minio_certificate_authority" {
  metadata {
    name      = var.minio_certificate_authority
    namespace = var.namespace

    labels = {
      app       = "postgres"
      component = "secret"
    }
  }

  data = {
    "tls.crt" = data.kubernetes_secret.minio_certificate_authority.data["tls.crt"]
    "tls.key" = data.kubernetes_secret.minio_certificate_authority.data["tls.key"]
    "ca.crt"  = data.kubernetes_secret.minio_certificate_authority.data["ca.crt"]
  }

  type = "kubernetes.io/tls"
}
