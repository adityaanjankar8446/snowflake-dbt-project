{{ config(materialized='table', tags=['staging']) }}

WITH cleaned AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY account_id ORDER BY open_date DESC) AS rn
    FROM mydb.myschema.raw_accounts
    WHERE account_id IS NOT NULL 
     AND customer_id IS NOT NULL      
)

SELECT
    account_id,
    customer_id,
    account_type,
    open_date,
    status       
FROM cleaned
WHERE rn = 1                           