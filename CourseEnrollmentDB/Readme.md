# 🗄️ edu_courses — Course Enrollment Database

<p align="left">
  <img src="https://img.shields.io/badge/MS%20SQL%20Server-CC2927?style=for-the-badge&logo=microsoftsqlserver&logoColor=white"/>
  <img src="https://img.shields.io/badge/T--SQL-0078D4?style=for-the-badge&logo=microsoftsqlserver&logoColor=white"/>
  <img src="https://img.shields.io/badge/Stored%20Procedures-4CAF50?style=for-the-badge"/>
  <img src="https://img.shields.io/badge/Transactions-ACID-blue?style=for-the-badge"/>
</p>

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

| Previous enrollments | Type | Discount |
|:---|:---|:---|
| 0 | Unconditional | −100 PLN flat |
| 1 | Fixed 5% | −5% of base price |
| n ≥ 2 | Loyalty | −(n + 6)% of base price |

Everything runs inside a single transaction. If anything fails — validation, insert, whatever — it rolls back completely.

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
