#!/bin/bash -e

echo "Setting up namespace for deployment of CloudNative PG Cluster..."
kubectl apply -f namespace.yml

echo "Fetching MinIO Certificate Authority..."
MINIO_CA_SECRET_JSON=$(kubectl get secret -n photoatom-object-storage photoatom-ca-certificate-tls -o json)

echo "Adding Certificate Authority Details into manifest..."
CA_CRT=$(echo "$MINIO_CA_SECRET_JSON" | jq -rc '.data."ca.crt"')
TLS_CRT=$(echo "$MINIO_CA_SECRET_JSON" | jq -rc '.data."tls.crt"')
TLS_KEY=$(echo "$MINIO_CA_SECRET_JSON" | jq -rc '.data."tls.key"')

sed -i "s|MINIO_TLS_CERT_HERE|$TLS_CRT|g" minio-ca.yml
sed -i "s|MINIO_TLS_KEY_HERE|$TLS_KEY|g" minio-ca.yml
sed -i "s|MINIO_CA_CERT_HERE|$CA_CRT|g" minio-ca.yml

echo "Setting up MinIO Certificate Authority..."
kubectl apply -f minio-ca.yml