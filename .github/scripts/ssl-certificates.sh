#!/bin/bash -e

function generate_ssl_certificates {

  PG_USERS=$1

  for PG_USER in $PG_USERS
  do
    echo "Checking SSL Certificate for the user: $PG_USER..."

    # Check if SSL Certificates have been generated for the given user
    SSL_CHECK=$(kubectl get secrets -n postgres | grep -c "$PG_USER-pg-cert" || true)

    # Create SSL Certificate for the given user
    if [[ "$SSL_CHECK" == "0" ]]
    then
      echo "Creating SSL Certificate for the user: $PG_USER..."
      kubectl cnpg certificate "$PG_USER-pg-cert" --cnpg-cluster postgresql-cluster --cnpg-user "$PG_USER" --namespace postgres
    else
      echo "SSL Certicate for the user: $PG_USER already exists..."
    fi

  done

}

generate_ssl_certificates "keycloak photoatom"