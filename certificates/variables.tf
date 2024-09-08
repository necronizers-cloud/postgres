variable "namespace" {
  default     = "postgres"
  description = "Namespace to be used for deploying Postgres Cluster and related resources."
}

variable "minio_namespace" {
  default     = "minio"
  description = "Namespace to be used for deploying MinIO Tenant and related resources."
}

variable "minio_certificate_authority" {
  default     = "minio-ca-certificate-tls"
  description = "MinIO Certificate Authority details"
}
