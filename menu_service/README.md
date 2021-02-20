# Test
Before anything, create a database test:

```bash
psql -h db -p 5432 -U cardapio
```

```bash
CREATE DATABASE cardapio
CREATE DATABASE cardapio_test
```

Check if databases were created:
```bash
\l
```

# Migrations

```bash
sequel -m migrate postgres://cardapio:cardapio@db:5432/cardapio
sequel -m migrate postgres://cardapio:cardapio@db:5432/cardapio_test
```

Check migrations
```bash
$ \c cardapio
$ \dt
```