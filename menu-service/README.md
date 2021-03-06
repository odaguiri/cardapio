# Test
Before anything, create a database test:

```bash
psql -h db -p 5432 -U cardapio
```

```bash
CREATE DATABASE menu
CREATE DATABASE menu_test
```

Check if databases were created:
```bash
\l
```

# Migrations

```bash
sequel -m migrate postgres://cardapio:cardapio@db:5432/menu
sequel -m migrate postgres://cardapio:cardapio@db:5432/menu_test
```

Check migrations
```bash
$ \c cardapio
$ \dt
```
