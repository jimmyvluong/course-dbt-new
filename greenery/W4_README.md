1. **dbt snapshots**

```sql
# create the snapshot
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
![Where snapshots are created]()

```sql
# SQL to update the records
UPDATE
  orders
SET
  tracking_id = 'a807fe66-d8b1-4d38-b409-558fed8bd75f',
  shipping_service = 'ups',
  estimated_delivery_at = '2021-02-19T10:15:26Z',
  status = 'shipped'
WHERE
  order_id = '914b8929-e04a-40f8-86ee-357f2be3a2a2';

UPDATE
  orders
SET
  tracking_id = '8404ed05-0128-4aeb-8ed5-6e44908875c4',
  shipping_service = 'ups',
  estimated_delivery_at = '2021-02-19T10:15:26Z',
  status = 'shipped'
WHERE
  order_id = '05202733-0e17-4726-97c2-0520c024ab85';
```
```sql
# check to see what changed in the snapshot
SELECT
  order_id
  , shipping_service
  , status
FROM snapshots.orders_status_snapshot
WHERE order_id = '914b8929-e04a-40f8-86ee-357f2be3a2a2'
OR order_id = '05202733-0e17-4726-97c2-0520c024ab85';
```

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
5. Adding images to markdown: https://marinegeo.github.io/2018-08-10-adding-images-markdown/#:~:text=Images%20can%20be%20added%20to,to%20show%20on%20mouseover%22)%20.
- ![alt text for screen readers](/path/to/image.png "Text to show on mouseover").