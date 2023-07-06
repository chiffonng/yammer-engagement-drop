/*
 Count number of active sessions, which leads to better performance 
 since it doesn't use DISTINCT
 
 WITH num_active_sessions AS (
 SELECT
 occurred_at,
 location
 FROM tutorial.yammer_events
 WHERE event_name = 'login'
 AND occurred_at >= '2014-06-30' 
 ), 
 top_regions AS (SELECT
 location,
 RANK() OVER(ORDER BY COUNT(*) DESC) AS rank
 FROM num_active_sessions
 GROUP BY 1)
 
 SELECT
 DATE_TRUNC('week', a.occurred_at) AS week,
 a.location,
 COUNT(*) AS active_sessions
 FROM num_active_sessions a
 INNER JOIN top_regions r
 ON a.location = r.location
 AND r.rank <= 5
 GROUP BY 1, 2 
 ORDER BY 1, 2;
 */
WITH active_users_by_region AS (
    SELECT user_id,
        occurred_at,
        location
    FROM tutorial.yammer_events
    WHERE event_name = 'login'
        AND occurred_at >= '2014-06-30'
),
top_regions AS (
    SELECT location,
        RANK() OVER(
            ORDER BY COUNT(*) DESC
        ) AS rank
    FROM active_users_by_region
    GROUP BY 1
)
SELECT DATE_TRUNC('week', u.occurred_at) AS week,
    u.location,
    COUNT(DISTINCT u.user_id) AS active_users
FROM active_users_by_region u
    INNER JOIN top_regions r ON u.location = r.location
    AND r.rank <= 5
GROUP BY 1, 2
ORDER BY 1, 2;