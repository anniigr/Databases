USE edu_courses;
GO

-- column modifications and constraints
ALTER TABLE users_user ADD phone_number NVARCHAR(25);
ALTER TABLE users_user DROP COLUMN age;
ALTER TABLE course ADD CONSTRAINT chk_dates CHECK (date_start < date_end);
GO
