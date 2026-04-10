-- Retention Analysis: Measures user return behavior within 1 day of signup

WITH total_users_data AS ( SELECT user_id,
                                  MIN(timestamp) AS signup_time
						   FROM events
                           WHERE event_type = 'signup'
                           GROUP BY user_id),
	retention_users_data AS ( SELECT DISTINCT e.user_id
                              FROM events e
                              JOIN total_users_data t
                              ON e.user_id = t.user_id
                              WHERE event_type = 'watch'
                              AND e.timestamp >= t.signup_time
							  AND e.timestamp < t.signup_time + INTERVAL 1 DAY)
	
SELECT (SELECT COUNT(*) FROM total_users_data) AS total_users,
	   (SELECT COUNT(*) FROM retention_users_data) AS retained_users,
        ROUND((SELECT COUNT(*) FROM retention_users_data) * 100.0 / (SELECT COUNT(*) FROM total_users_data),2)
        AS retention_percentage;
