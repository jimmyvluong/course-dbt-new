1. **dbt snapshots**

```sql
{% snapshot orders_status_snapshot %}

  {{
    config(
      target_schema='snapshots',
      strategy='check',
      unique_key='order_id',
      check_cols=['status'],
    )
  }}

  SELECT * FROM {{ source('src_greenery', 'orders') }}

{% endsnapshot %}
```
- dbt snapshot created another row that shows updated field values such as:
    - `tracking_id`, `shipping_service`, and `status`
    - How it works: the snapshot checks the `status` column, and if it changes the snapshot will create this new row.

2. 
---
**Useful things I learned this week**

1. There are TWO main strategies for snapshots.
- Timestamp/updated at
```sql
{% snapshot inventory_snapshot %}

  {{
    config(
      target_schema='snapshots',
      unique_key='id',

      strategy='timestamp',
      updated_at='updated_at',
    )
  }}

  SELECT * FROM {{ source('mysql', 'inventory') }}

{% endsnapshot %}
```
- Check columns
```sql
{% snapshot orders_snapshot %}

  {{
    config(
      target_schema='snapshots',
      strategy='check',
      unique_key='id',
      check_cols=['status'],
    )
  }}

  SELECT * FROM {{ source('mysql', 'orders') }}

{% endsnapshot %}
```
2. dbt exposures documentation: https://docs.getdbt.com/docs/building-a-dbt-project/exposures#declaring-an-exposure
3. Refactoring legacy SQL to dbt: https://docs.getdbt.com/guides/getting-started/learning-more/refactoring-legacy-sql
4. Indexing tables: https://dataschool.com/sql-optimization/how-indexing-works/
- Indexes allow us to create sorted lists without having to create all new sorted tables, which would take up a lot of storage space.
```sql
# To test the speed of a query:
EXPLAIN ANALYZE SELECT * FROM friends WHERE name = 'Blake';
# Testing the speed of Mukunda's table with an index.
EXPLAIN ANALYZE SELECT * FROM dbt_jimmy_l.dim_users_mukunda 
WHERE 
  first_name = 'Eileen' 
and
  country = 'United States';
# Testing the speed of my table without an index.
EXPLAIN ANALYZE SELECT * FROM dbt_jimmy_l.dim_users_no_index
WHERE 
  first_name = 'Eileen' 
and
  country = 'United States';
```
