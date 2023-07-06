-- Create lookup CTE (similar to lookup table)
WITH device_types AS (
    SELECT device,
        CASE
            WHEN device ~* 'tablet|ipad|kindle|windows surface|nexus 10|nexus 7' THEN 'tablet'
            WHEN device ~* 'desktop|notebook|mac|thinkpad|chromebook' THEN 'desktop'
            WHEN device ~* 'phone|nokia|samsung|htc one|nexus 5' THEN 'phone'
            ELSE ''
        END AS device_type
    FROM (
            SELECT DISTINCT device
            FROM tutorial.yammer_events
        ) AS devices
)
SELECT DATE_TRUNC('week', occurred_at) AS week,
    d.device_type,
    COUNT(DISTINCT user_id) AS active_users
FROM tutorial.yammer_events e
    JOIN device_types d ON d.device = e.device
    AND e.event_name = 'login'
GROUP BY 1,
    2
ORDER BY 1