-- Drop-off Analysis: Identifies users who did not move to the next stage in the funnel

WITH visit AS(
              SELECT DISTINCT user_id FROM events WHERE event_type = 'visit'),
     signup AS(
              SELECT DISTINCT user_id FROM events WHERE event_type = 'signup'),
	 watch AS(
              SELECT DISTINCT user_id FROM events WHERE event_type = 'watch'),
	 subscribe AS(
              SELECT DISTINCT user_id FROM events WHERE event_type = 'subscribe')

SELECT 'After_visit' AS stage, COUNT(v.user_id) as dropped_users
FROM visit v
LEFT JOIN signup s
ON v.user_id = s.user_id
WHERE s.user_id is NULL

UNION ALL

SELECT 'After_signup', COUNT(s.user_id) as dropped_users
FROM signup s
LEFT JOIN watch w
ON s.user_id = w.user_id
WHERE w.user_id is NULL

UNION ALL

SELECT 'After_watching', COUNT(w.user_id) as dropped_users
FROM watch w
LEFT JOIN subscribe sub
ON w.user_id = sub.user_id
WHERE sub.user_id is NULL
