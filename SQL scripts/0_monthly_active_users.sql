SELECT DATE_TRUNC('month', occurred_at) AS MONTH,
    COUNT(*) AS monthly_active_users
FROM tutorial.yammer_events
WHERE event_name = 'login'
GROUP BY 1