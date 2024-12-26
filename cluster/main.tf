// CloudNative PG Cluster
resource "kubernetes_manifest" "cluster" {
  manifest = {
    "apiVersion" = "postgresql.cnpg.io/v1"
    "kind"       = "Cluster"
    "metadata" = {
      "labels" = {
        "app"       = "postgres"
        "component" = "cluster"
      }
      "name"      = var.cluster_name
      "namespace" = var.namespace
    }
    "spec" = {
      "backup" = {
        "barmanObjectStore" = {
          "data" = {
            "additionalCommandArgs" = [
              "--min-chunk-size=5MB",
              "--read-timeout=60",
              "-vv",
            ]
          }
          "destinationPath" = "s3://${var.backup_bucket_name}/"
          "endpointCA" = {
            "key"  = "ca.crt"
            "name" = var.minio_certificate_authority
          }
          "endpointURL" = "https://minio-hl.${var.minio_namespace}.svc.cluster.local:9000"
          "s3Credentials" = {
            "accessKeyId" = {
              "key"  = "MINIO_ACCESS_KEY"
              "name" = var.minio_access_credentials
            }
            "secretAccessKey" = {
              "key"  = "MINIO_ACCESS_SECRET"
              "name" = var.minio_access_credentials
            }
          }
          "wal" = {
            "compression" = "gzip"
          }
        }
        "volumeSnapshot" = {
          "className" = "csi-hostpath-snapclass"
        }
      }
      "bootstrap" = {
        "initdb" = {
          "database" = "application"
          "postInitSQL" = [
            "CREATE USER keycloak",
            "CREATE DATABASE keycloak OWNER keycloak",
            "CREATE USER cloud",
            "CREATE DATABASE cloud OWNER cloud",
          ]
        }
      }
      "description"           = "PostgreSQL Cluster for all applications in PhotoAtom"
      "enableSuperuserAccess" = true
      "imageName"             = "ghcr.io/cloudnative-pg/postgresql:16.2"
      "instances"             = 1
      "managed" = {
        "roles" = [
          {
            "bypassrls"       = false
            "comment"         = "Keycloak User for PostgreSQL"
            "connectionLimit" = -1
            "createdb"        = true
            "createrole"      = true
            "ensure"          = "present"
            "inherit"         = true
            "login"           = true
            "name"            = "keycloak"
            "passwordSecret" = {
              "name" = var.keycloak_database_credentials_name
            }
            "replication" = false
            "superuser"   = false
          },
          {
            "bypassrls"       = false
            "comment"         = "Cloud User for PostgreSQL"
            "connectionLimit" = -1
            "createdb"        = true
            "createrole"      = true
            "ensure"          = "present"
            "inherit"         = true
            "login"           = true
            "name"            = "cloud"
            "passwordSecret" = {
              "name" = var.cloud_database_credentials_name
            }
            "replication" = false
            "superuser"   = false
          },
        ]
      }
      "primaryUpdateStrategy" = "unsupervised"
      "resources" = {
        "limits" = {
          "cpu"    = "500m"
          "memory" = "1Gi"
        }
        "requests" = {
          "cpu"    = "500m"
          "memory" = "1Gi"
        }
      }
      "startDelay" = 300
      "storage" = {
        "pvcTemplate" = {
          "accessModes" = [
            "ReadWriteOnce",
          ]
          "resources" = {
            "requests" = {
              "storage" = "1Gi"
            }
          }
          "storageClassName" = "local-path"
          "volumeMode"       = "Filesystem"
        }
        "size" = "5Gi"
      }
    }
  }

  // Fields to ignore changes for
  computed_fields = ["spec.managed.roles[0].replication", "spec.managed.roles[0].superuser", "spec.managed.roles[0].bypassrls", "spec.managed.roles[1].bypassrls", "spec.managed.roles[1].superuser", "spec.managed.roles[1].replication"]
}
