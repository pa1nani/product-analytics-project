-- Cohort Analysis (Long Format): Tracks user activity by signup date and day difference

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

-- Cohort Analysis (Matrix Format): Converts cohort data into pivot table for dashboarding

WITH signup_date_data AS ( 
    SELECT 
        user_id,
        DATE(MIN(timestamp)) AS signup_date
    FROM events
    WHERE event_type = 'signup'
    GROUP BY user_id
),

activity_data AS ( 
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

    COUNT(DISTINCT CASE WHEN day_number = 0 THEN user_id END) AS day_00,
    COUNT(DISTINCT CASE WHEN day_number = 1 THEN user_id END) AS day_01,
    COUNT(DISTINCT CASE WHEN day_number = 2 THEN user_id END) AS day_02,
    COUNT(DISTINCT CASE WHEN day_number = 3 THEN user_id END) AS day_03,
    COUNT(DISTINCT CASE WHEN day_number = 4 THEN user_id END) AS day_04

FROM activity_data
GROUP BY signup_date
ORDER BY signup_date;
