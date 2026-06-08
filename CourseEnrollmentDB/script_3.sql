USE edu_courses;
GO

INSERT INTO course (course_name, base_price, date_start, date_end) 
VALUES ('SQL Basics', 1000, '2026-09-01', '2026-12-01'), 
       ('Python Pro', 1500, '2026-10-01', '2027-01-01'), 
       ('Power BI', 2000, '2026-11-01', '2027-02-01');

INSERT INTO users_user (email, first_name, last_name, is_active, phone_number) 
VALUES ('j.kowalski@email.com', 'Jan', 'Kowalski', 1, '123456789'), 
       ('a.nowak@email.com', 'Anna', 'Nowak', 1, '987654321'), 
       ('p.zielinski@email.com', 'Piotr', 'Zielinski', 1, '555666777');

INSERT INTO groups (course_id, max_group_capacity) 
VALUES (1, 20), (2, 20), (3, 20);

INSERT INTO group_timetable (group_id, room, datetime_start, datetime_end) 
VALUES (1, 'A1', GETDATE(), GETDATE()), (2, 'A2', GETDATE(), GETDATE()), (3, 'A3', GETDATE(), GETDATE());

INSERT INTO course_enrollment (user_id, group_id, total_cost) 
VALUES (1, 1, 900), (2, 2, 1425), (3, 3, 1900);
GO
