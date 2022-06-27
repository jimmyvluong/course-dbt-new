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
