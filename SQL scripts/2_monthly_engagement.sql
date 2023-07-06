SELECT DATE_TRUNC('month', occurred_at) AS month,
event_type,
COUNT(*) AS event_count
FROM tutorial.yammer_events
GROUP BY 1, 2