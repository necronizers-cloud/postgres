variable "namespace" {
  default     = "postgres"
  description = "Namespace to be used for deploying Postgres Cluster and related resources."
}

variable "minio_namespace" {
  default     = "minio"
  description = "Namespace to be used for deploying MinIO Tenant and related resources."
}

variable "cluster_name" {
  default     = "postgresql-cluster"
  description = "Name for the PostgreSQL Name"
}

variable "backup_bucket_name" {
  default     = "postgres"
  description = "MinIO Bucket Name for backing up PITR data"
}

variable "minio_certificate_authority" {
  default     = "minio-ca-certificate-tls"
  description = "MinIO Certificate Authority details"
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
