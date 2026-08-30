{{ config(materialized='table', tags=['mart']) }}

SELECT
    a.account_id,
    c.customer_id,
    SUM(CASE WHEN t.transaction_type = 'credit' THEN t.amount ELSE 0 END) -
    SUM(CASE WHEN t.transaction_type = 'debit' THEN t.amount ELSE 0 END) AS current_balance,
    MAX(t.transaction_date) AS last_transaction_date
FROM {{ ref('fact_transactions') }} t
JOIN {{ ref('dim_accounts') }} a
    ON t.account_id = a.account_id
JOIN {{ ref('dim_customer') }} c
    ON a.customer_id = c.customer_id
GROUP BY 1,2