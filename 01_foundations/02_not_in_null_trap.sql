-- ===================================================================
-- INTERVIEW TOPIC: The NOT IN with NULL "Poison Pill"
-- DIFFICULTY: Foundational / Premium
-- PROBLEM: Find all users from the `users` table who are NOT listed 
--          in the `deleted_users` table.
-- ===================================================================

-- THE CANDIDATE TRAP (WRONG APPROACH)
-- If the `deleted_users` table contains even a SINGLE row where `user_id` IS NULL,
-- this entire query will return ZERO rows. 
SELECT user_id 
FROM users
WHERE user_id NOT IN (SELECT user_id FROM deleted_users);

-- WHY IT FAILS LOGICALLY:
-- In SQL, `NOT IN (1, 2, NULL)` translates to:
-- `user_id != 1 AND user_id != 2 AND user_id != NULL`
-- Because any comparison to NULL results in 'UNKNOWN', the entire 
-- WHERE clause evaluates to False/Unknown, wiping out your results.


-- THE CORRECT EXPLAIN PLAN (SUCCESSFUL APPROACH 1: NOT EXISTS)
-- `NOT EXISTS` uses three-valued logic safely. It checks for the absence of a 
-- matching row and is completely immune to the NULL poison pill.
SELECT u.user_id 
FROM users u
WHERE NOT EXISTS (
    SELECT 1 
    FROM deleted_users d 
    WHERE u.user_id = d.user_id
);


--  ALTERNATIVE SUCCESSFUL APPROACH 2: EXPLICIT FILTER
-- If you absolutely must use `NOT IN`, you must explicitly scrub out the NULLs first.
SELECT user_id 
FROM users
WHERE user_id NOT IN (
    SELECT user_id 
    FROM deleted_users 
    WHERE user_id IS NOT NULL
);

