USE edu_courses;
GO

CREATE OR ALTER PROCEDURE sp_EnrollUser
    @email NVARCHAR(255),
    @course_id INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        -- validate course
        IF NOT EXISTS (SELECT 1 FROM course WHERE course_id = @course_id AND is_active = 1)
            THROW 50001, 'Course is inactive or does not exist.', 1;

        -- add user
        IF NOT EXISTS (SELECT 1 FROM users_user WHERE email = @email)
            INSERT INTO users_user (email, first_name, last_name, is_active)
            VALUES (@email, 'New', 'User', 1);

        DECLARE @u_id INT = (SELECT user_id FROM users_user WHERE email = @email);

        -- validate user
        IF (SELECT is_active FROM users_user WHERE user_id = @u_id) = 0
            THROW 50002, 'User is inactive.', 1;

        -- check capacity
        IF NOT EXISTS (
            SELECT 1 FROM groups g 
            LEFT JOIN course_enrollment ce ON g.group_id = ce.group_id
            WHERE g.course_id = @course_id 
            GROUP BY g.group_id, g.max_group_capacity
            HAVING g.max_group_capacity > COUNT(ce.user_id)
        )
            THROW 50003, 'Group is at maximum capacity.', 1;

        -- discount logic
        DECLARE @cnt INT = (SELECT COUNT(*) FROM course_enrollment WHERE user_id = @u_id);
        DECLARE @base MONEY = (SELECT base_price FROM course WHERE course_id = @course_id);
        DECLARE @final MONEY, @disc MONEY, @type NVARCHAR(100);

        IF @cnt = 0 
            SELECT @disc = 100.00, @final = @base - 100.00, @type = 'bezwarunkowy';
        ELSE IF @cnt = 1 
            SELECT @disc = @base * 0.05, @final = @base * 0.95, @type = 'staly 5%';
        ELSE 
            SELECT @disc = @base * ((@cnt + 1.0) / 100.0), @final = @base * (1.0 - (@cnt + 1.0) / 100.0), @type = 'lojalnosciowy';

        -- Assign group
        DECLARE @g_id INT = (
            SELECT TOP 1 g.group_id FROM groups g 
            LEFT JOIN course_enrollment ce ON g.group_id = ce.group_id
            WHERE g.course_id = @course_id 
            GROUP BY g.group_id, g.max_group_capacity
            HAVING g.max_group_capacity > COUNT(ce.user_id)
        );
        
        INSERT INTO course_enrollment (user_id, group_id, total_cost, discount_type, discount_value)
        VALUES (@u_id, @g_id, @final, @type, @disc);

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO
