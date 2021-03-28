# Development

```bash
./setup.sh
```

# Test

# Migrations

```bash
sequel -m migrate postgres://cardapio:cardapio@db:5432/menu_test
```

Check migrations
```bash
$ \c cardapio
$ \dt
```
