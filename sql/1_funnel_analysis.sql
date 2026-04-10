-- Funnel Analysis: Tracks user conversion across stages
        
WITH funnel AS ( 
SELECT event_type AS stage,
	   COUNT(DISTINCT user_id) AS users
FROM events
GROUP BY event_type)

SELECT stage,
	   users,
       ROUND(users * 100 / FIRST_VALUE(users) OVER ( ORDER BY
             CASE
                 WHEN stage = 'visit' THEN 1
                 WHEN stage = 'signup' THEN 2
                 WHEN stage = 'watch' THEN 3
                 WHEN stage = 'subscribe' THEN 4
			 END),2
             )AS conversion_percentage
FROM funnel
ORDER BY  CASE
                  WHEN stage = 'visit' THEN 1
                 WHEN stage = 'signup' THEN 2
                 WHEN stage = 'watch' THEN 3
                 WHEN stage = 'subscribe' THEN 4
			 END;
