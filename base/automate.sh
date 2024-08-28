#!/bin/bash -e

# echo "Setting up namespace for deployment of CloudNative PG Cluster..."
# kubectl apply -f namespace.yml

# echo "Fetching MinIO Certificate Authority..."
# MINIO_CA_SECRET_JSON=$(kubectl get secret -n photoatom-object-storage photoatom-ca-certificate-tls -o json)

# echo "Adding Certificate Authority Details into manifest..."
# CA_CRT=$(echo "$MINIO_CA_SECRET_JSON" | jq -rc '.data."ca.crt"')
# TLS_CRT=$(echo "$MINIO_CA_SECRET_JSON" | jq -rc '.data."tls.crt"')
# TLS_KEY=$(echo "$MINIO_CA_SECRET_JSON" | jq -rc '.data."tls.key"')

# sed -i "s|MINIO_TLS_CERT_HERE|$TLS_CRT|g" minio-ca.yml
# sed -i "s|MINIO_TLS_KEY_HERE|$TLS_KEY|g" minio-ca.yml
# sed -i "s|MINIO_CA_CERT_HERE|$CA_CRT|g" minio-ca.yml

# echo "Setting up MinIO Certificate Authority..."
# kubectl apply -f minio-ca.yml

echo "Generating Access Keys for MinIO..."
MINIO_ACCESS_KEY="postgres-access"
MINIO_ACCESS_SECRET=$(openssl rand -base64 16)

echo "Fetching user details for MinIO..."
POSTGRES_USER_NAME=$(kubectl get secret -n photoatom-object-storage postgres-storage-user -o json | jq -rc '.data.CONSOLE_ACCESS_KEY' | base64 --decode)
POSTGRES_USER_PASSWORD=$(kubectl get secret -n photoatom-object-storage postgres-storage-user -o json | jq -rc '.data.CONSOLE_SECRET_KEY' | base64 --decode)

echo "Saving Access Keys in MinIO for Postgres..."
kubectl port-forward svc/minio-hl 9000 -n photoatom-object-storage &
sleep 3
PROCESS_NUMBER=$(ps | grep kubectl | xargs | cut -f1 -d" ")

mc alias set photoatom https://localhost:9000 "$POSTGRES_USER_NAME" "$POSTGRES_USER_PASSWORD" --insecure

mc admin user svcacct add \
   --access-key "$MINIO_ACCESS_KEY" \
   --secret-key "$MINIO_ACCESS_SECRET" \
   photoatom "$POSTGRES_USER_NAME" \
   --insecure

kill -9 "$PROCESS_NUMBER"

echo "Setting up MinIO Access Keys for Postgres..."
sed -i "s|MINIO_ACCESS_KEY_HERE|$(echo $MINIO_ACCESS_KEY | base64)|g" minio-access-key.yml
sed -i "s|MINIO_ACCESS_SECRET_HERE|$(echo $MINIO_ACCESS_SECRET | base64)|g" minio-access-key.yml

kubectl apply -f minio-access-key.yml