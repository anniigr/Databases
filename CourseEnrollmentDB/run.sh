#!/usr/bin/env bash
# Creates the edu_courses database from scratch in a local SQL Server container and runs the
# scripts in order, then the smoke test. Needs Docker; works on Apple silicon (Azure SQL Edge)
# and on x86 (swap the image for mcr.microsoft.com/mssql/server:2022-latest if you prefer).
set -euo pipefail
cd "$(dirname "$0")"

PASSWORD="${MSSQL_SA_PASSWORD:-EduCourses!2026}"
CONTAINER=edu-sql

if ! docker ps --format '{{.Names}}' | grep -qx "$CONTAINER"; then
  echo "starting SQL Server container $CONTAINER"
  docker run -d --name "$CONTAINER" -e ACCEPT_EULA=1 -e MSSQL_SA_PASSWORD="$PASSWORD" \
    -p 127.0.0.1:1433:1433 mcr.microsoft.com/azure-sql-edge:latest >/dev/null
  echo "waiting for the server"; sleep 25
fi

sqlcmd() {
  docker run --rm --platform linux/amd64 --network host -v "$PWD:/scripts" \
    mcr.microsoft.com/mssql-tools /opt/mssql-tools/bin/sqlcmd \
    -S 127.0.0.1,1433 -U sa -P "$PASSWORD" -b -W "$@"
}

sqlcmd -Q "IF DB_ID('edu_courses') IS NOT NULL BEGIN ALTER DATABASE edu_courses SET SINGLE_USER WITH ROLLBACK IMMEDIATE; DROP DATABASE edu_courses; END"
for f in script_1 script_2 script_3 task_3 procedure; do
  echo "== $f.sql"; sqlcmd -i "/scripts/$f.sql"
done
echo "== smoke_test.sql"; sqlcmd -d edu_courses -i /scripts/smoke_test.sql
