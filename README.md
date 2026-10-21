# Databases

Coursework for the Databases course at Warsaw University of Technology.

| Part | What it is |
| --- | --- |
| [`CourseEnrollmentDB/`](CourseEnrollmentDB/) | A T-SQL project: schema for course enrollments, a schema migration, seed data, indexes and a transactional stored procedure with tiered discounts. Includes a Docker-based runner and a smoke test; verified against SQL Server (Azure SQL Edge). |
| [`notes/database-exam-notes-pl.md`](notes/database-exam-notes-pl.md) | Exam notes (Polish): relational model, integrity and ERD, transactions and ACID, indexes, JDBC, concurrency and isolation levels, stored procedures and triggers, distributed databases and replication, OLTP vs OLAP. |

## Quick start

```bash
cd CourseEnrollmentDB
./run.sh        # starts SQL Server in Docker, builds edu_courses from the scripts, runs the smoke test
```

See [`CourseEnrollmentDB/Readme.md`](CourseEnrollmentDB/Readme.md) for the data model, index
rationale and the stored procedure's validation and discount rules.
