// Generating MinIO Access Key for Postgres Backups
resource "random_password" "minio_access_secret" {
  length           = 16
  lower            = true
  numeric          = true
  special          = true
  override_special = "-_*"
  min_special      = 2
}

data "kubernetes_secret" "minio_postgres_credentials" {
  metadata {
    name      = var.postgres_user_name
    namespace = var.minio_namespace
  }
}

locals {
  postgres_user                     = nonsensitive(data.kubernetes_secret.minio_postgres_credentials.data["CONSOLE_ACCESS_KEY"])
  postgres_password                 = nonsensitive(data.kubernetes_secret.minio_postgres_credentials.data["CONSOLE_SECRET_KEY"])
  postgres_service_account_password = nonsensitive(random_password.minio_access_secret.result)
}

resource "null_resource" "create_service_account" {
  triggers = {
    "create_service_account" : true
  }

  provisioner "local-exec" {
    command = <<EOT
kubectl port-forward svc/minio-hl 9000 -n minio &
sleep 3
PROCESS_NUMBER=$(ps | grep kubectl | xargs | cut -f1 -d" ")

mc alias set photoatom https://localhost:9000 "${data.kubernetes_secret.minio_postgres_credentials.data["CONSOLE_ACCESS_KEY"]}" "${data.kubernetes_secret.minio_postgres_credentials.data["CONSOLE_SECRET_KEY"]}" --insecure

mc admin user svcacct add \
   --access-key "${var.postgres_service_account_name}" \
   --secret-key "${random_password.minio_access_secret.result}" \
   photoatom "${data.kubernetes_secret.minio_postgres_credentials.data["CONSOLE_ACCESS_KEY"]}" \
   --insecure

kill -9 "$PROCESS_NUMBER"
    EOT
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

  data = {
    "MINIO_ACCESS_KEY"    = var.postgres_service_account_name
    "MINIO_ACCESS_SECRET" = random_password.minio_access_secret.result
  }

  type = "Opaque"

  depends_on = [null_resource.create_service_account]
}

// Passwords for PostgreSQL Cluster Users
resource "random_password" "photoatom_password" {
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

resource "kubernetes_secret" "photoatom_database_credentials" {
  metadata {
    name      = var.photoatom_database_credentials_name
    namespace = var.namespace

    labels = {
      app       = "postgres"
      component = "secret"
    }
  }

  data = {
    "username" = "photoatom"
    "password" = random_password.photoatom_password.result
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
