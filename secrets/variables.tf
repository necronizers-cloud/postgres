variable "namespace" {
  default     = "postgres"
  description = "Namespace to be used for deploying Postgres Cluster and related resources."
}

variable "minio_namespace" {
  default     = "minio"
  description = "Namespace to be used for deploying MinIO Tenant and related resources."
}

variable "postgres_user_name" {
  default     = "postgres-user"
  description = "Name for the PostgreSQL user secret"
}

variable "postgres_service_account_name" {
  default     = "postgres-access"
  description = "MinIO Service Account name for Postgres Cluster WAL Backups"
}

variable "minio_access_credentials" {
  default     = "minio-access-key"
  description = "Secret name for MinIO Access Keys"
}

variable "photoatom_database_credentials_name" {
  default     = "photoatom-database-credentials"
  description = "Database Credentials Secret Name for PhotoAtom Application"
}

variable "keycloak_database_credentials_name" {
  default     = "keycloak-database-credentials"
  description = "Database Credentials Secret Name for Keycloak"
}