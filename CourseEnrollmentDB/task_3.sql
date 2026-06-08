USE edu_courses;
GO

-- indexes for query optimization
CREATE INDEX idx_enrollment_user ON course_enrollment(user_id);
CREATE UNIQUE INDEX uq_users_email ON users_user(email);
CREATE INDEX idx_course_dates ON course(date_start, date_end);
CREATE INDEX idx_users_name ON users_user(last_name, first_name);
CREATE CLUSTERED INDEX cidx_enrollment_composite ON course_enrollment(user_id, group_id);
GO
