{{ config(materialized='table', tags=['mart']) }}

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(t.transaction_id) AS total_transactions,
    SUM(t.amount) AS total_amount,
    MIN(t.transaction_date) AS first_transaction,
    MAX(t.transaction_date) AS last_transaction
FROM {{ ref('fact_transactions') }} t
JOIN {{ ref('dim_accounts') }} a
    ON t.account_id = a.account_id
JOIN {{ ref('dim_customer') }} c
    ON a.customer_id = c.customer_id
GROUP BY 1,2,3