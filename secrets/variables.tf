variable "namespace" {
  default     = "postgres"
  description = "Namespace to be used for deploying Postgres Cluster and related resources."
}

variable "minio_namespace" {
  default     = "minio"
  description = "Namespace to be used for deploying MinIO Tenant and related resources."
}

variable "postgres_backups_access_credentials" {
  default     = "postgres-access-key"
  description = "Secret name for PG Backups Access Keys"
}


variable "postgres_service_account_name" {
  default     = "postgres-access"
  description = "MinIO Service Account name for Postgres Cluster WAL Backups"
}

variable "minio_access_credentials" {
  default     = "minio-access-key"
  description = "Secret name for MinIO Access Keys"
}

variable "cloud_database_credentials_name" {
  default     = "cloud-database-credentials"
  description = "Database Credentials Secret Name for Application"
}

variable "keycloak_database_credentials_name" {
  default     = "keycloak-database-credentials"
  description = "Database Credentials Secret Name for Keycloak"
}
