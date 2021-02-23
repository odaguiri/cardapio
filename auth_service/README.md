# Database Setup

```sh
# Your environments
DATABASE_NAME=auth
DATABASE_SUPERUSER=cardapio
DATABASE_HOST=db

# Create accounts
createuser -h ${DATABASE_HOST} -U ${DATABASE_SUPERUSER} -P ${DATABASE_NAME}
createuser -h ${DATABASE_HOST} -U ${DATABASE_SUPERUSER} -P ${DATABASE_NAME}_password

# Create database
createdb -h ${DATABASE_HOST} -U ${DATABASE_SUPERUSER} -O ${DATABASE_NAME} ${DATABASE_NAME}

# Setup your schema
psql -h ${DATABASE_HOST} -U ${DATABASE_SUPERUSER} -c "DROP SCHEMA public;" ${DATABASE_NAME}
psql -h ${DATABASE_HOST} -U ${DATABASE_SUPERUSER} -c "CREATE SCHEMA ${DATABASE_NAME} AUTHORIZATION ${DATABASE_NAME};" ${DATABASE_NAME}
psql -h ${DATABASE_HOST} -U ${DATABASE_SUPERUSER} -c "CREATE SCHEMA ${DATABASE_NAME}_password AUTHORIZATION ${DATABASE_NAME}_password;" ${DATABASE_NAME}
psql -h ${DATABASE_HOST} -U ${DATABASE_SUPERUSER} -c "GRANT USAGE ON SCHEMA ${DATABASE_NAME} TO ${DATABASE_NAME}_password;" ${DATABASE_NAME}
psql -h ${DATABASE_HOST} -U ${DATABASE_SUPERUSER} -c "GRANT USAGE ON SCHEMA ${DATABASE_NAME}_password TO ${DATABASE_NAME};" ${DATABASE_NAME}

# Support case insensitive logins
psql -U ${DATABASE_SUPERUSER} -h ${DATABASE_HOST} -c "CREATE EXTENSION citext SCHEMA ${DATABASE_NAME}" ${DATABASE_NAME}

# Run migrations
rake db:migrate
rake db:migrate_password
```

# Create an account

```bash
curl --header "Content-Type: application/json" --request POST --data '{"login": "login2@test.test", "login-confirm":"login2@test.test", "password":"password", "password-confirm":"password"}' http://localhost:3000/create-account
```

```bash
curl --verbose --header "Content-Type: application/json" --request POST --data '{"login": "login@test.test", "password":"password"}' http://localhost:3000/login
```