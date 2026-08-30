{{ config(materialized='table', tags=['staging']) }}

WITH cleaned AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY customer_since DESC) AS rn
    FROM mydb.myschema.raw_customers
    WHERE customer_id IS NOT NULL
)

SELECT
    customer_id,
    first_name,
    last_name,
    gender,
    date_of_birth,
    city,
    state,
    country,
    customer_since
FROM cleaned
WHERE rn = 1