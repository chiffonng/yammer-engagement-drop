-- Create lookup CTE (similar to lookup table)
WITH operating_systems AS (
    SELECT device,
        CASE
            WHEN device ~* 'ipad|kindle|iphone' THEN 'iOS'
            WHEN device ~* 'mac' THEN 'macOS'
            WHEN device ~* 'desktop|notebook|thinkpad|chromebook' THEN 'Windows'
            ELSE 'Android'
        END AS device_type
    FROM (
            SELECT DISTINCT device
            FROM tutorial.yammer_events
        ) AS devices
)
SELECT DATE_TRUNC('week', occurred_at) AS week,
    o.device_type,
    COUNT(DISTINCT user_id) AS active_users
FROM tutorial.yammer_events e
    JOIN operating_systems o ON o.device = e.device
    AND e.event_name = 'login'
GROUP BY 1,
    2
ORDER BY 1