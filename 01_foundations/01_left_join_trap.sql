-- ===================================================================
-- INTERVIEW TOPIC: The LEFT JOIN Filtering Trap
-- DIFFICULTY: Foundational / Premium
-- PROBLEM: List all employees and their 2026 bonus amounts. If they 
--          didn't get a bonus in 2026, still return the employee name with NULL.
-- ===================================================================

-- THE CANDIDATE TRAP (WRONG APPROACH)
-- Placing the filter in the WHERE clause kills the LEFT JOIN. 
-- It converts it into an INNER JOIN because NULL rows are filtered out.
SELECT e.employee_id, e.employee_name, b.bonus_amount
FROM employees e
LEFT JOIN bonus b ON e.employee_id = b.employee_id
WHERE b.bonus_year = 2026;


-- THE CORRECT EXPLAIN PLAN (SUCCESSFUL APPROACH)
-- To keep it a true LEFT JOIN, the conditional filter must live 
-- entirely inside the ON clause of the join itself.
SELECT e.employee_id, e.employee_name, b.bonus_amount
FROM employees e
LEFT JOIN bonus b 
    ON e.employee_id = b.employee_id 
    AND b.bonus_year = 2026;