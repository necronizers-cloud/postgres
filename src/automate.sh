#!/bin/bash -e

echo "Setting up Client Certificates for Postgres..."
kubectl apply -f client-ca.yml
sleep 10
kubectl apply -f client-ca-issuer.yml
sleep 10
kubectl apply -f client-cert.yml
sleep 10

echo "Setting up Server Certificates for Postgres..."
kubectl apply -f server-ca.yml
sleep 10
kubectl apply -f server-ca-issuer.yml
sleep 10
kubectl apply -f server-cert.yml
sleep 10

echo "Setting up user credentials for Postgres..."
PHOTOATOM_CREDS_USERNAME="photoatom"
PHOTOATOM_CREDS_PASSWORD="$(openssl rand -base64 16)"

sed -i "s|CONFIG_PHOTOATOM_CREDS_USERNAME|$(echo $PHOTOATOM_CREDS_USERNAME | base64)|g" photoatom-creds-secret.yml
sed -i "s|CONFIG_PHOTOATOM_CREDS_PASSWORD|$(echo $PHOTOATOM_CREDS_PASSWORD | base64)|g" photoatom-creds-secret.yml

kubectl apply -f photoatom-creds-secret.yml

KEYCLOAK_CREDS_USERNAME="keycloak"
KEYCLOAK_CREDS_PASSWORD="$(openssl rand -base64 16)"

sed -i "s|CONFIG_KEYCLOAK_CREDS_USERNAME|$(echo $KEYCLOAK_CREDS_USERNAME | base64)|g" keycloak-creds-secret.yml
sed -i "s|CONFIG_KEYCLOAK_CREDS_PASSWORD|$(echo $KEYCLOAK_CREDS_PASSWORD | base64)|g" keycloak-creds-secret.yml

kubectl apply -f keycloak-creds-secret.yml

echo "Setting up Postgres Cluster..."
kubectl apply -f cluster.yml