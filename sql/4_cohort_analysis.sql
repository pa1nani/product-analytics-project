WITH signup_date_data AS (
    SELECT 
        user_id,
        DATE(MIN(timestamp)) AS signup_date
    FROM events 
    WHERE event_type = 'signup'
    GROUP BY user_id
),

retained_users_data AS (
    SELECT 
        e.user_id,
        s.signup_date,
        DATEDIFF(DATE(e.timestamp), s.signup_date) AS day_number
    FROM events e
    JOIN signup_date_data s
    ON e.user_id = s.user_id
    WHERE e.event_type = 'watch'
    AND DATE(e.timestamp) >= s.signup_date
)

SELECT 
    signup_date,
    day_number,
    COUNT(DISTINCT user_id) AS users
FROM retained_users_data
GROUP BY signup_date, day_number
ORDER BY signup_date, day_number;
