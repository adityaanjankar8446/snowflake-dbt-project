{{ config(materialized='table') }}

SELECT
    t.transaction_id,
    t.account_id,
    t.transaction_date,
    t.transaction_type,
    t.amount,
    t.channel,
    t.merchant_category
FROM {{ ref('stg_transactions') }} t
JOIN {{ ref('dim_accounts') }} a
  ON t.account_id = a.account_id