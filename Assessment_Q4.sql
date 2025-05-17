WITH user_transactions AS (
    SELECT 
        sa.owner_id,
        COUNT(*) AS total_transactions,
        SUM(sa.confirmed_amount)/100 AS total_transaction_value
    FROM 
        savings_savingsaccount sa
    WHERE 
        sa.confirmed_amount > 0
    GROUP BY 
        sa.owner_id
),
user_tenure AS (
    SELECT 
        u.id AS customer_id,
        CONCAT(COALESCE(u.first_name, ''), ' ', COALESCE(u.last_name, '')) AS name,
        TIMESTAMPDIFF(MONTH, u.created_on, CURDATE()) AS tenure_months
    FROM 
        users_customuser u
    WHERE 
        u.first_name NOT IN ('First name', '') AND
        u.last_name NOT IN ('Last name', '')
),
user_clv AS (
    SELECT 
        tenure.customer_id,
        tenure.name,
        tenure.tenure_months,
        tx.total_transactions,
        ROUND(tx.total_transaction_value / tx.total_transactions * 0.001, 2) AS avg_profit_per_transaction,
        ROUND((tx.total_transactions / tenure.tenure_months) * 12 * (tx.total_transaction_value / tx.total_transactions * 0.001), 2) AS estimated_clv
    FROM 
        user_tenure tenure
    JOIN 
        user_transactions tx ON tenure.customer_id = tx.owner_id
    WHERE 
        tenure.tenure_months > 0
)
SELECT 
    customer_id,
    name,
    tenure_months,
    total_transactions,
    estimated_clv
FROM 
    user_clv
ORDER BY 
    estimated_clv DESC;
