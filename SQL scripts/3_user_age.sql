WITH user_age_cohort AS (
    SELECT e.occurred_at,
        u.user_id,
        DATE_TRUNC('week', u.activated_at) AS activation_week,
        EXTRACT(
            'day'
            FROM e.occurred_at - u.activated_at
        ) AS age_at_event,
        EXTRACT(
            'day'
            FROM '2014-09-01'::TIMESTAMP - u.activated_at
        ) AS user_age
    FROM tutorial.yammer_users u
        JOIN tutorial.yammer_events e ON e.user_id = u.user_id
        AND e.event_type = 'engagement'
        AND e.event_name = 'login'
        AND e.occurred_at >= '2014-05-01'
        AND e.occurred_at < '2014-09-01'
    WHERE u.activated_at IS NOT NULL
)
SELECT DATE_TRUNC('week', a.occurred_at) AS "event_week",
    AVG(a.age_at_event) AS "avg_age",
    COUNT(
        DISTINCT CASE
            WHEN a.user_age > 56 THEN a.user_id
            ELSE NULL
        END
    ) AS "8+ weeks",
    COUNT(
        DISTINCT CASE
            WHEN a.user_age >= 28
            AND a.user_age <= 56 THEN a.user_id
            ELSE NULL
        END
    ) AS "4-8 weeks",
    COUNT(
        DISTINCT CASE
            WHEN a.user_age < 28 THEN a.user_id
            ELSE NULL
        END
    ) AS "Less than 4 weeks"
FROM user_age_cohort a
GROUP BY 1
ORDER BY 1
LIMIT 100;