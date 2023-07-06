SELECT DATE_TRUNC('day', created_at) AS signup_date,
    COUNT(*) AS daily_signups_all_users,
    COUNT(
        CASE
            WHEN state = 'active' THEN 1
        END
    ) AS daily_signups_active_users
FROM tutorial.yammer_users
WHERE created_at BETWEEN '2014-07-01' AND '2014-08-31'
GROUP BY 1
ORDER BY 1