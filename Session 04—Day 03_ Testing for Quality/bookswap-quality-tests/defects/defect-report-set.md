# BookSwap – Defect Report Set (Session 4 / Day 3)

**Owner:** Chirani Lavanya  
**Project:** BookSwap  
**Testing date:** 16 November 2026  
**Evidence sources:** Session 3 SQL verification, PostgreSQL seed database, Postman report, Newman JUnit report and Prism mock API.

## 1. Summary of candidate findings

| ID | Candidate title | Layer | Category | Proposed severity | Proposed priority | Status |
|---|---|---|---|---|---|---|
| CAND-01 | Duplicate pending borrow requests for Book 11 / Member 9 | Database | Reliability / data integrity | Medium | Medium | Seed-data finding |
| CAND-02 | Loan 30 is marked returned without a return date | Database | Functional / data integrity | Medium | Medium | Seed-data finding; latest dates verified |
| CAND-03 | Loan 29 has a return date before its borrowed date | Database | Functional / data integrity | Medium | Medium | Seed-data finding; latest dates verified |
| CAND-04 | Book 57 contains a 9-character ISBN | Database | Validation / data quality | Medium | Medium | Seed-data finding |
| CAND-05 | Member records 17 and 19 have missing phone values | Database | Data completeness | Low | Low | Seed-data finding |
| CAND-06 | Invalid ISBN mock response identifies the wrong field | API mock | Functional / API contract | Medium | Medium | Confirmed mock-response mismatch |

**Coverage note:** These six findings do not establish the challenge requirement of at least five confirmed defects across three or more Day 03 defect types. Performance, security, accessibility and reliability tests against the actual practice build remain necessary.

## 2. Candidate defect reports

### CAND-01 – Duplicate pending borrow requests for the same book and borrower

**Environment:** Supplied PostgreSQL 16 seed database, `bookswap`.

**Steps to reproduce:**

1. Open PowerShell in the `bookswap-quality-tests` folder.
2. Execute:

```powershell
docker compose -f .\references\session3\docker-compose.yml exec db psql -U bookswap -d bookswap
```

3. Execute the following SQL query:

```sql
SELECT book_id, borrower_id, COUNT(*) AS pending_request_count
FROM borrow_requests
WHERE status = 'pending'
GROUP BY book_id, borrower_id
HAVING COUNT(*) > 1;
```

**Expected result:** No duplicate pending-request groups should exist, assuming the business rule permits only one pending request per borrower and book.

**Actual result:** The query returned:

- `book_id = 11`
- `borrower_id = 9`
- `pending_request_count = 2`

**Affected layer:** Database.

**Proposed severity:** Medium.

**Proposed priority:** Medium.

**Reason:** Duplicate pending requests may create conflicting borrower or book-owner actions.

**Evidence:** Session 3 SQL Verification Query 6.

**Request ID:** Not applicable – direct seed-database SQL query.

**Classification:** Seed-data finding. Confirm the business rule and reproduce through the real API before raising a product defect.

---

### CAND-02 – Loan 30 is marked returned without a return date

**Environment:** Supplied PostgreSQL 16 seed database.

**Steps to reproduce:**

1. Connect to the `bookswap` database.
2. Execute:

```sql
SELECT id, status, borrowed_at, returned_at
FROM loans
WHERE id = 30;
```

**Expected result:** A loan marked as `returned` should have a valid `returned_at` value.

**Actual result:** The latest database query returned:

| ID | Status | Borrowed date | Returned date |
|---|---|---|---|
| 30 | returned | 2026-11-08 | NULL |

**Affected layer:** Database.

**Proposed severity:** Medium.

**Proposed priority:** Medium.

**Reason:** Missing return-date information may affect loan history, reporting and overdue calculations.

**Evidence:** Latest PostgreSQL query executed on 16 November 2026.

**Request ID:** Not applicable – direct seed-database SQL query.

**Classification:** Seed-data finding. Reproduce a return operation through the actual application before classifying this as a product defect.

---

### CAND-03 – Loan 29 has an impossible return-date sequence

**Environment:** Supplied PostgreSQL 16 seed database.

**Steps to reproduce:**

1. Connect to the `bookswap` database.
2. Execute:

```sql
SELECT id, status, borrowed_at, returned_at
FROM loans
WHERE id = 29;
```

**Expected result:** A loan's return date must not be earlier than its borrowed date.

**Actual result:** The latest database query returned:

| ID | Status | Borrowed date | Returned date |
|---|---|---|---|
| 29 | returned | 2026-11-06 | 2026-11-01 |

The return date is five days earlier than the borrowed date.

**Affected layer:** Database.

**Proposed severity:** Medium.

**Proposed priority:** Medium.

**Reason:** Incorrect date sequences may affect loan history, overdue calculations and reporting.

**Evidence:** Latest PostgreSQL query executed on 16 November 2026.

**Request ID:** Not applicable – direct seed-database SQL query.

**Classification:** Seed-data finding. Verify whether the same inconsistency can be created through the actual application.

---

### CAND-04 – Book 57 has a 9-character ISBN

**Environment:** Supplied PostgreSQL 16 seed database.

**Steps to reproduce:**

1. Connect to the `bookswap` database.
2. Execute:

```sql
SELECT id, title, isbn, LENGTH(isbn) AS isbn_length
FROM books
WHERE LENGTH(isbn) NOT IN (10, 13);
```

**Expected result:** No invalid ISBN lengths should be returned, based on the Session 3 SQL verification assumption that ISBNs contain 10 or 13 characters.

**Actual result:**

- Book ID: 57
- Title: Funny Boy
- ISBN: `955123456`
- Length: 9 characters

**Affected layer:** Database.

**Proposed severity:** Medium.

**Proposed priority:** Medium.

**Reason:** An invalid catalogue identifier may affect book lookup and validation.

**Evidence:** Session 3 SQL Verification Query 8.

**Request ID:** Not applicable – direct seed-database SQL query.

**Classification:** Seed-data finding. Confirm the accepted ISBN formats and reproduce through the actual book-creation API.

---

### CAND-05 – Member records have missing phone values

**Environment:** Supplied PostgreSQL 16 seed database.

**Steps to reproduce:**

1. Connect to the `bookswap` database.
2. Execute:

```sql
SELECT id, display_name
FROM members
WHERE phone IS NULL OR phone = '';
```

**Expected result:** This depends on whether the business requirements make phone numbers mandatory.

**Actual result:** Member IDs 17 and 19 were returned with missing phone values.

**Affected layer:** Database.

**Proposed severity:** Low.

**Proposed priority:** Low.

**Reason:** Incomplete contact information may affect communication if a phone number is required.

**Evidence:** Session 3 SQL Verification Query 4.

**Request ID:** Not applicable – direct seed-database SQL query.

**Classification:** Data-completeness observation. This does not prove a privacy breach or an application defect. Confirm the mandatory-field requirement first.

---

### CAND-06 – Invalid ISBN validation response identifies the wrong field in Prism

**Environment:** Supplied Prism mock API at `http://localhost:4010`.

**Steps to reproduce:**

1. Import the Session 3 Postman collection and environment.
2. Execute `07 - Create book with invalid ISBN`.
3. Supply the invalid ISBN `955123456` with otherwise valid fields.
4. Inspect the HTTP status and response body.

**Expected result:**

- HTTP 422 validation response.
- The response should identify the `isbn` field as invalid.

**Actual result:**

- HTTP 422 was returned.
- The validation response identified `title` rather than `isbn`.
- Newman assertion `Validation response identifies ISBN field` failed.
- Overall Newman result: 14 of 15 assertions passed.

**Affected layer:** API mock / contract example.

**Proposed severity:** Medium.

**Proposed priority:** Medium.

**Reason:** An incorrect mock validation example can mislead API contract verification.

**Evidence:**

- `references/session3/reports/newman-results.xml`
- `references/session3/chirani-session3-postman-report.md`

**Request ID:** Not available in the Newman failure output.

**Classification:** Confirmed Prism mock-response mismatch. Actual BookSwap application behaviour remains unknown.

## 3. Additional Day 03 defect types to investigate

The following are test targets, not confirmed defects. Add a report only when a test actually demonstrates a failure.

| Suggested ID | Defect type | Test scenario | Evidence required |
|---|---|---|---|
| D-07 | Performance | Execute k6 search test against the practice build. Investigate if the stated threshold is breached. | k6 p95/p99/error summary, build identifier and timestamps |
| D-08 | Security – BOLA | Member B attempts to read or modify Member A's synthetic loan. | Redacted requests and responses, account identities and database verification |
| D-09 | Accessibility | Test keyboard and screen-reader operation on core journeys and run axe. | Affected journey/control, reproduction steps, axe rule ID and evidence |
| D-10 | Reliability | Test listing creation during email outage and retry with the same Idempotency-Key. | HTTP responses, idempotency key, SQL row count and relevant logs |

**Security reporting note:** If a genuine security vulnerability is confirmed, report it privately to the reviewer or lead and use Restricted Jira handling as instructed by the challenge.

## 4. Results summary

| Metric | Challenge expectation | Current position |
|---|---|---|
| Candidate findings documented | At least 5 | 6 documented |
| Confirmed Day 03 application defects | At least 5 required by the challenge | Not established |
| Defect types | At least 3 types | Not yet demonstrated |
| Reproduction steps | Developer-actionable steps | Included for all six candidates |
| Expected and actual results | Clearly documented | Included |
| Affected layer | Identified | Included |
| Severity and priority | Separate assessments | Proposed separately |
| Evidence | Supporting evidence | SQL and Newman references included |
| Security ticket handling | Restricted handling for confirmed security findings | No confirmed security finding yet |

## 5. AI review and reflection

| Finding | What still needs investigation | Current decision |
|---|---|---|
| Duplicate pending requests | Reproduce repeated requests through the actual API and confirm the business rule | Keep as candidate |
| Loan 30 missing return date | Reproduce a return operation through the application | Keep as candidate |
| Loan 29 incorrect date sequence | Verify whether the application permits an invalid return date | Keep as candidate |
| Invalid ISBN | Confirm the ISBN validation requirement and compare actual API behaviour | Keep as candidate |
| Missing phone values | Confirm whether phone is mandatory | Keep as data-completeness finding |
| Invalid ISBN mock response | Compare the Prism response with the actual API response | Confirmed mock mismatch only |

### Reflection

The SQL checks revealed data inconsistencies that could not be identified from the Prism example responses alone.

This exercise demonstrated the importance of checking both API behaviour and database records during QA testing.

For future defect reports, I should capture:

1. The exact API request.
2. The actual API response and HTTP status.
3. The request ID, where available.
4. The related database query and result.
5. Expected and actual behaviour.
6. Severity and priority as separate assessments.

This makes a defect easier for a developer to reproduce and investigate.

## 6. Final conclusion

Six candidate findings have been documented using the supplied PostgreSQL seed database and Prism mock API evidence.

The latest database verification confirmed the current date inconsistencies for loans 29 and 30:

- Loan 29: borrowed on 6 November 2026 and returned on 1 November 2026.
- Loan 30: borrowed on 8 November 2026 and marked returned without a return date.

The Newman report also confirmed one failed assertion involving the invalid ISBN mock response.

However, these findings do not establish six defects in the actual BookSwap application. They must be investigated against the practice build before being raised as product defects.

The Day 03 performance, BOLA, accessibility and reliability defect categories still require actual practice-build execution. The missing practice application prevents those tests from being completed at this stage.

**Overall status:** Candidate defect reports prepared. Actual application defect validation remains pending.

---

## 7. Evidence locations

- `defects/defect-report-set.md`
- `defects/sql-verification-evidence.md`
- `references/session3/chirani-session3-sql-verification.md`
- `references/session3/chirani-session3-postman-report.md`
- `references/session3/reports/newman-results.xml`
- `nfr/k6-summary.txt`
- `security/security-checklist.md`

**Testing date:** 16 November 2026  
**Tester:** Chirani Lavanya