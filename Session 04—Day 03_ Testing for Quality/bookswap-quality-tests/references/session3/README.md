# BookSwap – Session 3 Day 2: Building Blocks for Testers

## Project Overview

This project demonstrates API testing, database verification, and basic test automation for the BookSwap application as part of the QA Intern Onboarding Program.

## Project Structure

```text
Session 3 - Day 2/
├── api/
│   └── bookswap-openapi.yaml
├── db/
│   ├── 01-schema.sql
│   └── 02-seed.sql
├── postman/
│   ├── chirani-session3-bookswap.postman_collection.json
│   └── bookswap-local.postman_environment.json
├── reports/
│   └── newman-results.xml
├── chirani-session3-bookswap-test-cases.md
├── chirani-session3-traceability-matrix.md
├── chirani-session3-postman-report.md
├── chirani-session3-sql-verification.md
├── docker-compose.yml
└── README.md
```

## Prerequisites

- Docker Desktop
- Node.js and npm
- Postman
- Newman 6.2.1

## 1. Start the Docker Environment

Start Docker Desktop and open a terminal in the project directory.

Run:

```bash
docker compose up -d
```

Check the containers:

```bash
docker compose ps
```

## 2. Verify the API

**Base URL:**

```text
http://localhost:4010
```

Check the API without authentication:

```bash
curl -i http://localhost:4010/books
```

Check the API with authentication:

```bash
curl -i -H "Authorization: Bearer test-token" "http://localhost:4010/books?page=1&pageSize=20"
```

**Previously observed responses:**

- Without a token: `401 Unauthorized`
- With a valid test token: `200 OK`

## 3. Database Verification

The project uses PostgreSQL through Docker Compose.

Connect to the database:

```bash
docker compose exec db psql -U bookswap -d bookswap
```

The SQL verification queries and observed results are documented in:

`chirani-session3-sql-verification.md`

## 4. Postman Collection

Import the following files into Postman:

- `postman/chirani-session3-bookswap.postman_collection.json`
- `postman/bookswap-local.postman_environment.json`

Select the **BookSwap Local** environment.

**Environment variables:**

| Variable | Value |
|---|---|
| baseUrl | `http://localhost:4010` |
| token | `test-token` |
| bookId | `101` |

## 5. Run Automated API Tests Using Newman

Run this command from the project root:

```bash
npx newman@6.2.1 run postman/chirani-session3-bookswap.postman_collection.json -e postman/bookswap-local.postman_environment.json --reporters cli,junit --reporter-junit-export reports/newman-results.xml
```

The execution results will be saved in:

`reports/newman-results.xml`

### Latest Newman Execution Results

- Requests executed: 7
- Assertions executed: 15
- Assertions passed: 14
- Assertions failed: 1
- Average response time: 73 ms
- Maximum response time: 371 ms

The failed assertion relates to the invalid ISBN validation response. Further details are documented in `chirani-session3-postman-report.md`.

## 6. Deliverables

1. Test Case Set
2. Traceability Matrix with Execution Results
3. Postman Smoke Collection
4. SQL Verification Sheet
5. Postman/Newman Smoke Report

## Important Note

The BookSwap API runs as a Stoplight Prism mock server. Its example responses do not necessarily represent actual business logic or database persistence.

Mock API responses and database findings are documented separately in the testing reports.

## Conclusion

This project provided practical experience in test case design, API testing using Postman, automated API test execution using Newman, SQL-based database verification, and test result documentation.

It also helped demonstrate the importance of requirement traceability, negative testing, and identifying data-quality issues during software testing.

