// Fetching MinIO Access Key for Postgres Backups
data "kubernetes_secret" "postgres_backups_access_credentials" {
  metadata {
    name      = var.postgres_backups_access_credentials
    namespace = var.minio_namespace
  }
}

resource "kubernetes_secret" "minio_access_keys" {
  metadata {
    name      = var.minio_access_credentials
    namespace = var.namespace

    labels = {
      app       = "postgres"
      component = "secret"
    }
  }

  data = data.kubernetes_secret.postgres_backups_access_credentials.data

  type = "Opaque"
}

// Passwords for PostgreSQL Cluster Users
resource "random_password" "cloud_password" {
  length           = 16
  lower            = true
  numeric          = true
  special          = true
  override_special = "-_*/"
  min_special      = 2
}

resource "random_password" "keycloak_password" {
  length           = 16
  lower            = true
  numeric          = true
  special          = true
  override_special = "-_*/"
  min_special      = 2
}

resource "kubernetes_secret" "cloud_database_credentials" {
  metadata {
    name      = var.cloud_database_credentials_name
    namespace = var.namespace

    labels = {
      app       = "postgres"
      component = "secret"
    }
  }

  data = {
    "username" = "photoatom"
    "password" = random_password.cloud_password.result
  }

  type = "kubernetes.io/basic-auth"
}

resource "kubernetes_secret" "keycloak_database_credentials" {
  metadata {
    name      = var.keycloak_database_credentials_name
    namespace = var.namespace

    labels = {
      app       = "postgres"
      component = "secret"
    }
  }

  data = {
    "username" = "keycloak"
    "password" = random_password.keycloak_password.result
  }

  type = "kubernetes.io/basic-auth"
}
