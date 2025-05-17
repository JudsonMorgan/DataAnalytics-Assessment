WITH user_monthly_transaction AS (
    SELECT 
        sa.owner_id,
        DATE_FORMAT(sa.transaction_date, '%Y-%m-01') AS transaction_month,
        COUNT(*) AS transaction_count
    FROM 
        savings_savingsaccount sa
    WHERE 
        sa.transaction_date IS NOT NULL
    GROUP BY 
        sa.owner_id, DATE_FORMAT(sa.transaction_date, '%Y-%m-01')
),
user_avg_transaction_per_month AS (
    SELECT 
        owner_id,
        ROUND(AVG(transaction_count), 2) AS avg_transactions_per_month
    FROM 
        user_monthly_transaction
    GROUP BY 
        owner_id
),
categorized_users AS (
    SELECT 
        CASE 
            WHEN avg_transactions_per_month >= 10 THEN 'High Frequency'
            WHEN avg_transactions_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
            WHEN avg_transactions_per_month <=2 THEN 'Low Frequency'
        END AS frequency_category,
        COUNT(*) AS customer_count,
        ROUND(AVG(avg_transactions_per_month), 2) AS avg_transactions_per_month
    FROM 
        user_avg_transaction_per_month
    GROUP BY 
        frequency_category
)
SELECT *
FROM categorized_users
WHERE frequency_category IN ('High Frequency', 'Medium Frequency')
ORDER BY 
    FIELD(frequency_category, 'High Frequency', 'Medium Frequency');
