PART 1: Create new models to answer the first two questions (answer questions in README file)

- What is our overall conversion rate?
    - Conversion rate is defined as the # of unique sessions with a purchase event / total number of unique sessions. 
    - 62%

```
SELECT SUM(checkout)/COUNT(distinct session_id)::float AS conversion_rate
FROM dbt_jimmy_l.fct_sessions;
```
- What is our conversion rate by product?
    - Conversion rate by product is defined as the # of unique sessions with a purchase event of that product / total number of unique sessions that viewed that product

```
--- assume add to cart has NO cart abandonment
--- NEED TO ADD PRODUCT_ID to fct_sessions
SELECT 
product_id
, SUM(checkout)/COUNT(distinct session_id)::float AS conversion_rate
FROM dbt_jimmy_l.fct_sessions
GROUP BY 1;
```

---

PART 2: We’re getting really excited about dbt macros after learning more about them and want to apply them to improve our dbt project. 

PART 3: Post hook

PART 4: Install a package

PART 5: Make a new DAG.

---
**Useful things I learned this week**
1. `~` is string concatenation in Jinja
2. `schema.yml` files are cheap, I think the yml by mart makes sense (I actually split them all out as a personal preference to limit long running yml
3. No need to declare `ref` again in `JOINS` once you `ref` a model once in a `SELECT` statement.
4. With the way I have it currently for my columns - wouldn’t the SQL break if I change the name of stg_greneery__addresses file?
    5.  it would break but namespace changes don’t happen that frequently and should just be a find all and replace in the model (that’s how I’ve handled it!). I think it’s important to be verbose in your selects so people know exactly where these cols are coming from 
6. Quick link to dbt-utils github macros: https://github.com/dbt-labs/dbt-utils/blob/main/macros/sql/get_query_results_as_dict.sql
7. Operations are a way to run/invoke macros outside the context of a dbt run. This is called a run-operation. Certain macros may be helpful to run without needing to run a dbt model.
8. How to create a role:
```sql
psql
create role reporting;
\du
# OR
select rolname from pg_roles;
```


