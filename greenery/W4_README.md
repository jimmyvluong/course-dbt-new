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
![Where snapshots are created](https://github.com/jimmyvluong/course-dbt/blob/3cd29c6b2d7985184dc73bb9de00071af6dabbb8/greenery/where_snapshots_are_created.png "Where snapshots are created.")

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

![The new records in the orders_status snapshot](https://github.com/jimmyvluong/course-dbt/blob/242dea5d5b447a024e3309bc7d91026b67eaaaa0/greenery/snapshot_example.png "orders_status snapshot")

2. Modeling challenge
- Note: I created a simple model called `funnel_users.sql` that has the overall product funnel metrics already calculated. It is likely best practice to leave this step up to the BI tool or the analyst. 
- The more interesting model is `int_session_events_agg_user.sql`, which has user information and can be broken down by geography.

```sql
with event_counts as (
SELECT
  stg_greenery__events.session_id
  , MAX(CASE WHEN stg_greenery__events.event_type = 'add_to_cart' then 1 else 0 end) AS add_to_cart
  , MAX(CASE WHEN stg_greenery__events.event_type = 'checkout' then 1 else 0 end) AS checkout
  , MAX(CASE WHEN stg_greenery__events.event_type = 'page_view' then 1 else 0 end) AS page_view
  , MAX(CASE WHEN stg_greenery__events.event_type = 'package_shipped' then 1 else 0 end) AS package_shipped
FROM dbt_jimmy_l.stg_greenery__events
GROUP BY 1
)
,
funnel as (
SELECT
    SUM(checkout) as checkount_count
  , SUM(add_to_cart) as add_to_cart_count
  , SUM(page_view) as page_view_count
  , (SUM(add_to_cart::float)/SUM(page_view::float)) as add_to_cart_rate
  , (SUM(checkout::float)/SUM(add_to_cart::float)) as checkout_rate
  FROM event_counts
)

SELECT * FROM funnel;
```

An interesting finding is that by state, Georgia has significant drop from add_to_cart to checkout rates
```sql
SELECT
    state
  , SUM(checkout) as checkount_count
  , SUM(add_to_cart) as add_to_cart_count
  , SUM(page_view) as page_view_count
  , ROUND((SUM(add_to_cart::numeric)/SUM(page_view::numeric)),2) as add_to_cart_rate
  , ROUND((SUM(checkout::numeric)/SUM(add_to_cart::numeric)),2) as checkout_rate
FROM dbt_jimmy_l.int_session_events_agg_user
GROUP BY 1
ORDER BY checkout_rate ASC;
```
![Georgia's low checkout rate](https://github.com/jimmyvluong/course-dbt/blob/edc3f75d5806ce45255cab063fa54081907b39f5/greenery/georgia_low_checkout_rate.png "Georgia's low checkout rate")

**Exposures**
- Exposures are important to implement so that analysts working in dbt know what downstream impacts changes to models will have outside of just dbt runs. 
- If a run fails or a test errors, it’s important to know how that will affect things like critical reporting dashboards or a data science algorithm.
- With exposures, we know which models are most critical to the business and can make sure that the right stakeholders are notified if something goes wrong.
```yml
version: 2

exposures:  
  - name: Product Funnel Dashboard
    description: >
      Models that are critical to our product funnel dashboard
    type: dashboard
    maturity: high
    owner:
      name: Jimmy
      email: jimmy@greenery.com
    depends_on:
      - ref('fct_sessions')
```
------------------------------------------------------
------------------------------------------------------
------------------------------------------------------

**Useful things I learned this week**

1. There are TWO main strategies for snapshots.
- Timestamp/updated at
- If the configured updated_at timestamp for a row is more recent than the last time the snapshot ran, then dbt will invalidate the old record and record the new one. 
- If the timestamps are unchanged, then dbt will not take any action in the snapshot. 
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
- Check columns (check if a column value changed)
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

6. Artifacts (need to add to this section)
-----
-----
-----
**Going back to do some needed exploratory data analysis.**

**ORDERS**
- A good table to use to explore order counts is int_orders_promos which is simply the orders table with a promo flag.
1. How many orders are there in total?
```sql
SELECT COUNT(*) FROM dbt_jimmy_l.int_orders_promos;
```
> There are 361 total orders.

2. How many users ordered at least 1 time?
```sql
SELECT count(DISTINCT user_id)
from dbt_jimmy_l.int_orders_promos;
```
> 124 unique users orderd at least 1 time.

3. How many orders are there per customer?
```sql
SELECT user_id, count(1) as number_of_orders
from dbt_jimmy_l.int_orders_promos
group by 1
order by 2 desc;
```
> There are anywhere from 1 to 8 orders per customer.

4. What percent of customers ordered 2 or more times?
```sql
WITH user_order_count AS (
  SELECT user_id, count(1) as number_of_orders
  from dbt_jimmy_l.int_orders_promos
  group by 1
  order by 2 desc
)

SELECT SUM(CASE WHEN number_of_orders > 1 THEN 1 else 0 end) AS number_of_customers_ordering_2_or_more
, SUM(1) number_of_total_customers
, SUM(CASE WHEN number_of_orders > 1 THEN 1.0 else 0 end)/ SUM(1) AS percent_2_or_more_orders
FROM user_order_count;
```
|number_of_customers_ordering_2_or_more|number_of_total_customers|percent_2_or_more_orders|
|:---|:---|:---|
|99|124|0.79|
---
**EVENTS**
- No session can have a checkout event_type if it DID NOT have an add_to_cart event_type as well.
1. How many total event_id are there?
> 3,553
2. What are the different event_type?
```sql
SELECT distinct event_type FROM dbt_jimmy_l.stg_greenery__events;
```
- There are 4 event_type
- (page_view, add_to_cart, checkout, package_shipped)
---
