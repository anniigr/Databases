-- Smoke test for sp_EnrollUser: three enrollments of one new user exercise the three
-- discount tiers, then the error paths. Run after script_1..3, task_3 and procedure.
SET NOCOUNT ON;

EXEC sp_EnrollUser 'smoke.test@example.com', 1;
EXEC sp_EnrollUser 'smoke.test@example.com', 2;
EXEC sp_EnrollUser 'smoke.test@example.com', 3;

SELECT e.group_id, c.course_name, c.base_price, e.discount_type, e.discount_value, e.total_cost
FROM course_enrollment e
JOIN users_user u ON u.user_id = e.user_id
JOIN groups g ON g.group_id = e.group_id
JOIN course c ON c.course_id = g.course_id
WHERE u.email = 'smoke.test@example.com'
ORDER BY e.enrollment_date;

-- Expected: 1st enrollment -100 PLN flat, 2nd -5 % of the base price, 3rd -(n + 1) % with n = 2 previous enrollments, i.e. 3 %.

BEGIN TRY
    EXEC sp_EnrollUser 'smoke.test@example.com', 999;
END TRY
BEGIN CATCH
    PRINT 'expected error: ' + ERROR_MESSAGE();
END CATCH;
