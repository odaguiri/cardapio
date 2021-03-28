#!/bin/bash

DATABASE_AUTH_SERVICE=auth_service

# menu service
DATABASE_SUPERUSER=cardapio
DATABASE_USER=menu_service_acc
DATABASE_NAME=menu_service_db

kubectl exec deploy/postgres -it -- createuser -U ${DATABASE_SUPERUSER} -P ${DATABASE_USER}
kubectl exec deploy/postgres -- createdb -U ${DATABASE_SUPERUSER} -O ${DATABASE_USER} ${DATABASE_NAME}
