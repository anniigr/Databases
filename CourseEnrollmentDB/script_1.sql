CREATE DATABASE edu_courses;
GO
USE edu_courses;
GO

CREATE TABLE course (
    course_id INT IDENTITY(1,1) PRIMARY KEY,
    course_name NVARCHAR(100) NOT NULL,
    base_price MONEY NOT NULL,
    planned_groups_amount INT DEFAULT 1,
    date_start DATE,
    date_end DATE,
    is_active BIT DEFAULT 1
);

CREATE TABLE users_user (
    user_id INT IDENTITY(1,1) PRIMARY KEY,
    email NVARCHAR(255),
    first_name NVARCHAR(200),
    last_name NVARCHAR(200),
    is_active BIT,
    age INT
);

CREATE TABLE groups (
    group_id INT IDENTITY(1,1) PRIMARY KEY,
    group_type NVARCHAR(25) DEFAULT 'zajęciowa',
    course_id INT FOREIGN KEY REFERENCES course(course_id),
    max_group_capacity INT
);

CREATE TABLE group_timetable (
    group_id INT FOREIGN KEY REFERENCES groups(group_id),
    room NVARCHAR(10),
    datetime_start DATETIME,
    datetime_end DATETIME
);

CREATE TABLE course_enrollment (
    user_id INT FOREIGN KEY REFERENCES users_user(user_id),
    group_id INT FOREIGN KEY REFERENCES groups(group_id),
    enrollment_date DATETIME,
    total_cost MONEY,
    discount_type NVARCHAR(100) DEFAULT 'bezwarunkowy',
    discount_value MONEY,
    is_completed BIT DEFAULT 0,
    is_dropped BIT DEFAULT 0
);
GO
