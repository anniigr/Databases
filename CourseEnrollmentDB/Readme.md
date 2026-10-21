# edu_courses — Course Enrollment Database (T-SQL)

## Overview

A relational database for managing course enrollments — built as a university assignment for the Databases course at Warsaw University of Technology.

Covers the full cycle: schema design → schema migrations → seed data → indexing → stored procedure with transaction handling.

---

## Data Model

5 tables: `course`, `groups`, `group_timetable`, `users_user`, `course_enrollment`

```
users_user ──< course_enrollment >── groups ── group_timetable
                                        │
                                      course
```

`course_enrollment` is the join table between users and groups. It also stores the final price and discount applied at the moment of enrollment — not recalculated later.

A few deliberate choices:
- `MONEY` type for all prices — avoids floating-point issues
- soft deletes via `is_active` on both users and courses — history stays intact
- `is_dropped` on enrollment marks a voluntary withdrawal, kept for audit purposes

---

## Files

| File | What's inside |
|:---|:---|
| `script_1.sql` | Database + all tables + foreign keys |
| `script_2.sql` | Schema changes: add `phone_number`, drop `age`, add CHECK on dates |
| `script_3.sql` | Seed data — 3+ rows per table |
| `task_3.sql` | Index definitions |
| `procedure.sql` | Stored procedure: enroll a user into a course |
| `smoke_test.sql` | Exercises the procedure: three enrollments (three discount tiers) and an error path |
| `run.sh` | Recreates the database in a local SQL Server container and runs everything in order |

---

## Indexes

| Index | Columns | Type | Why |
|:---|:---|:---|:---|
| `idx_enrollment_user` | `course_enrollment(user_id)` | non-clustered | speeds up joins with `users_user` |
| `uq_users_email` | `users_user(email)` | unique | email must be unique; also used for fast lookup on enrollment |
| `idx_course_dates` | `course(date_start, date_end)` | composite | filtering active/upcoming courses by date range |
| `cidx_enrollment_composite` | `course_enrollment(user_id, group_id)` | clustered | main access pattern for the table |
| `idx_users_name` | `users_user(last_name, first_name)` | composite | name-based filtering in admin views |

---

## Stored Procedure — `sp_EnrollUser`

Takes `@email` and `@course_id`, handles the whole enrollment flow.

**Validation steps:**
1. Course exists and is active
2. User is active — if the email doesn't exist yet, a new user is created automatically
3. At least one group has a free spot

**Discount logic:**

| Previous enrollments (n) | Type (`discount_type`) | Discount |
|:---|:---|:---|
| 0 | `bezwarunkowy` (unconditional) | −100 PLN flat |
| 1 | `staly 5%` (fixed) | −5% of base price |
| n ≥ 2 | `lojalnosciowy` (loyalty) | −(n + 1)% of base price |

The discount and the final price are stored on the enrollment row (`discount_value`,
`total_cost`), so later price changes do not rewrite history.

Everything runs inside a single transaction. 

```sql
BEGIN TRY
    BEGIN TRANSACTION;
        -- validation + discount calc + INSERT
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    THROW;
END CATCH
```

---

*Developed as part of the Databases course — Warsaw University of Technology*

## Run it locally

Needs Docker. The script starts Azure SQL Edge (SQL Server engine, runs on Apple silicon and x86), drops and recreates `edu_courses`, applies the scripts in order and runs the smoke test:

```bash
cd CourseEnrollmentDB
./run.sh
```

Output of the smoke test on 2026-10-21 (three enrollments of a new user):

```text
group_id course_name base_price discount_type  discount_value total_cost
1        SQL Basics  1000.0000  bezwarunkowy   100.0000       900.0000
2        Python Pro  1500.0000  staly 5%       75.0000        1425.0000
3        Power BI    2000.0000  lojalnosciowy  60.0000        1940.0000
expected error: Course is inactive or does not exist.
```

Each enrollment lands in the first group of the course that still has a free seat; a course with no free seat raises error 50003 and the transaction rolls back.
