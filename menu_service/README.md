# Test
Before anything, create a database test:

```bash
psql -h db -p 5432 -U cardapio
```

```bash
CREATE DATABASE cardapio_test
```

# Migrations

```bash
sequel -m migrate postgres://cardapio:cardapio@db:5432/cardapio
```

```bash
sequel -m migrate postgres://cardapio:cardapio@db:5432/cardapio_test
```