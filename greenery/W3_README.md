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