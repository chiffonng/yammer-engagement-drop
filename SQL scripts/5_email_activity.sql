WITH email_activity AS (
    SELECT DATE_TRUNC('week', e1.occurred_at) AS week,
           COUNT(CASE WHEN e1.action = 'sent_weekly_digest' THEN e1.user_id ELSE NULL END) AS weekly_emails,
           COUNT(CASE WHEN e1.action = 'sent_weekly_digest' THEN e2.user_id ELSE NULL END) AS weekly_opens,
           COUNT(CASE WHEN e1.action = 'sent_weekly_digest' THEN e3.user_id ELSE NULL END) AS weekly_ct,
           COUNT(CASE WHEN e1.action = 'sent_reengagement_email' THEN e1.user_id ELSE NULL END) AS weekly_retain_emails,
           COUNT(CASE WHEN e1.action = 'sent_reengagement_email' THEN e2.user_id ELSE NULL END) AS weekly_retain_opens,
           COUNT(CASE WHEN e1.action = 'sent_reengagement_email' THEN e3.user_id ELSE NULL END) AS weekly_retain_ct
    FROM tutorial.yammer_emails e1
    LEFT JOIN tutorial.yammer_emails e2
        ON e2.user_id = e1.user_id
        AND e2.action = 'email_open'
        AND e2.occurred_at >= e1.occurred_at  
        AND e2.occurred_at < e1.occurred_at + INTERVAL '24 HOURS'
        
    LEFT JOIN tutorial.yammer_emails e3
        ON e3.user_id = e2.user_id
        AND e3.action = 'email_clickthrough'
        AND e3.occurred_at >= e2.occurred_at 
        AND e3.occurred_at < e2.occurred_at + INTERVAL '24 HOURS'
        
    WHERE e1.action IN ('sent_weekly_digest', 'sent_reengagement_email')
    GROUP BY 1
)
SELECT *
FROM email_activity
ORDER BY 1