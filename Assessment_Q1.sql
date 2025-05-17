SELECT 
    u.id AS owner_id,
    TRIM(CONCAT(u.first_name, ' ', u.last_name)) AS name, 
    COUNT(DISTINCT CASE 
        WHEN p.is_regular_savings = 1 AND sa.confirmed_amount > 0 THEN sa.plan_id 
    END) AS savings_count,
    COUNT(DISTINCT CASE 
        WHEN p.is_a_fund = 1 AND sa.confirmed_amount > 0 THEN sa.plan_id 
    END) AS investment_count,
    ROUND(SUM(CASE 
        WHEN sa.confirmed_amount > 0 THEN sa.confirmed_amount 
        ELSE 0 
    END) / 100.0, 2) AS total_deposits
FROM 
    savings_savingsaccount sa
JOIN 
    plans_plan p ON sa.plan_id = p.id
JOIN 
    users_customuser u ON sa.owner_id = u.id
GROUP BY 
    u.id, u.first_name, u.last_name
HAVING 
    COUNT(DISTINCT CASE 
        WHEN p.is_regular_savings = 1 AND sa.confirmed_amount > 0 THEN sa.plan_id 
    END) > 0
    AND COUNT(DISTINCT CASE 
        WHEN p.is_a_fund = 1 AND sa.confirmed_amount > 0 THEN sa.plan_id 
    END) > 0
ORDER BY 
    total_deposits DESC;
