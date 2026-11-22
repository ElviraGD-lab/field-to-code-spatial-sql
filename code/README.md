# Code

One SQL script per chapter, named `chNN_slug.sql`. Each script runs top to bottom in `psql` on PostgreSQL 18 with PostGIS:

```bash
psql -d spatial_sql -f code/ch02_towers.sql
```

The scripts are the same code that appears in the lessons, in the same order.
