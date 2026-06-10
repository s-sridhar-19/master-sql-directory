-- ===================================================================
-- INTERVIEW TOPIC: Conditional Aggregation (Pivoting Data)
-- DIFFICULTY: Foundational / High-Probability
-- PROBLEM: Transform a vertical event log tracking user logins into a 
--          horizontal summary showing total logins broken down by 
--          device type for each year.
-- ===================================================================

----------------------------------------------------------------------
-- INPUT DATA VISUALIZATION
----------------------------------------------------------------------
--
-- Table: user_logins
-- +----------+---------------------+-------------+
-- | login_id | login_time          | device_type |
-- +----------+---------------------+-------------+
-- |        1 | 2025-03-14 10:00:00 | Desktop     |
-- |        2 | 2025-06-22 14:30:00 | Mobile      |
-- |        3 | 2026-01-05 09:15:00 | Desktop     |
-- |        4 | 2026-02-11 18:45:00 | Desktop     |
-- +----------+---------------------+-------------+

----------------------------------------------------------------------
-- THE CORRECT EXPLAIN PLAN (SUCCESSFUL APPROACH)
----------------------------------------------------------------------
-- Core Data Rule: Nest a conditional CASE WHEN statement inside your 
-- aggregate function. The CASE statement filters rows dynamically, 
-- and the aggregation function squashes them into clean columns.
SELECT 
    EXTRACT(YEAR FROM login_time) AS login_year,
    COUNT(CASE WHEN device_type = 'Desktop' THEN 1 END) AS desktop_logins,
    COUNT(CASE WHEN device_type = 'Mobile' THEN 1 END) AS mobile_logins
FROM user_logins
GROUP BY EXTRACT(YEAR FROM login_time)
ORDER BY login_year;

-- EXPECTED PORTFOLIO OUTPUT:
-- +------------+----------------+---------------+
-- | login_year | desktop_logins | mobile_logins |
-- +------------+----------------+---------------+
-- |       2025 |              1 |             1 |
-- |       2026 |              2 |             0 |
-- +------------+----------------+---------------+
-- Note: Rows with matching attributes are cleanly summarized 
-- horizontally, making the data ready for reporting dashboards.
