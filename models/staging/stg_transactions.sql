{{ config(materialized='table', tags=['staging']) }}

WITH cleaned AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY transaction_id ORDER BY transaction_date DESC) AS rn
    FROM mydb.myschema.raw_transactions
    WHERE transaction_id IS NOT NULL
      AND account_id IS NOT NULL
      AND transaction_type IN ('credit', 'debit') 
)

SELECT
    transaction_id,
    account_id,
    transaction_date,
    transaction_type,
    amount,
    channel,
    merchant_category
FROM cleaned
WHERE rn = 1