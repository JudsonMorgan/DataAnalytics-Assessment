SELECT
    sa.plan_id,
    sa.owner_id,
    CASE 
        WHEN p.is_regular_savings = 1 THEN 'Savings'
        WHEN p.is_a_fund = 1 THEN 'Investment'
        ELSE 'Other'
    END AS type,
    MAX(DATE(sa.transaction_date)) AS last_transaction_date,
    DATEDIFF(CURDATE(), MAX(DATE(sa.transaction_date))) AS inactivity_days
FROM
    savings_savingsaccount sa
JOIN
    plans_plan p ON sa.plan_id = p.id
WHERE
    sa.confirmed_amount > 0 AND 
    (p.is_regular_savings = 1 OR p.is_a_fund = 1)
GROUP BY
    sa.plan_id, sa.owner_id, type
HAVING
    MAX(DATE(sa.transaction_date)) < DATE_SUB(CURDATE(), INTERVAL 365 DAY)
ORDER BY
    inactivity_days DESC;
