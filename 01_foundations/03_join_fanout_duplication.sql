-- ===================================================================
-- INTERVIEW TOPIC: Join Fan-out Data Duplication
-- DIFFICULTY: Foundational / High-Probability
-- PROBLEM: Calculate the total sales revenue generated for each product 
--          by joining the sales table with the promotions table.
-- ===================================================================

----------------------------------------------------------------------
-- INPUT DATA VISUALIZATION
----------------------------------------------------------------------
--
-- Table A: sales
-- +------------+---------+---------+
-- | product_id | sale_id | revenue |
-- +------------+---------+---------+
-- |        101 |       1 |     500 |
-- |        101 |       2 |     300 |
-- +------------+---------+---------+
-- Note: Total real revenue for Product 101 is 800.
--
-- Table B: promotions
-- +------------+------------+
-- | product_id | promo_name |
-- +------------+------------+
-- |        101 | BlackFriday|
-- |        101 | CyberMonday|
-- +------------+------------+
-- Note: Product 101 qualifies for TWO different active campaigns.

----------------------------------------------------------------------
-- THE CANDIDATE TRAP (WRONG APPROACH)
----------------------------------------------------------------------
-- This standard join creates a many-to-many Cartesian product. 
-- Each sale row duplicates for every matching promotion row, causing 
-- your financial calculations to blow up.
SELECT 
    s.product_id, 
    SUM(s.revenue) AS faulty_total_revenue
FROM sales s
LEFT JOIN promotions p ON s.product_id = p.product_id
GROUP BY s.product_id;

-- EXPECTED BLOW-UP OUTPUT:
-- +------------+-----------------------+
-- | product_id | faulty_total_revenue  |
-- +------------+-----------------------+
-- |        101 |                  1600 |  <-- WRONG! (Double the real amount)
-- +------------+-----------------------+


----------------------------------------------------------------------
-- THE CORRECT EXPLAIN PLAN (SUCCESSFUL APPROACH)
----------------------------------------------------------------------
-- Core Data Rule: Always AGGREGATE metrics BEFORE executing your joins 
-- when dealing with non-unique keys to guarantee a safe 1-to-Many relationship.
WITH consolidated_sales AS (
    SELECT 
        product_id, 
        SUM(revenue) AS true_revenue
    FROM sales
    GROUP BY product_id
)
SELECT 
    s.product_id, 
    s.true_revenue,
    p.promo_name
FROM consolidated_sales s
LEFT JOIN promotions p ON s.product_id = p.product_id;

-- EXPECTED PORTFOLIO OUTPUT:
-- +------------+--------------+-------------+
-- | product_id | true_revenue | promo_name  |
-- +------------+--------------+-------------+
-- |        101 |          800 | BlackFriday |
-- |        101 |          800 | CyberMonday |
-- +------------+--------------+-------------+
-- Note: The analytics correctly show both applicable campaigns 
-- without inflating our actual cash metrics!


