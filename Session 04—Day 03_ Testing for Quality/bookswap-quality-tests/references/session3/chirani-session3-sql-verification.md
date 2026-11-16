# BookSwap — SQL Verification Sheet

## 1. Database Connection

**Database:** PostgreSQL 16  
**Docker image:** `postgres:16-alpine`  
**Database name:** `bookswap`  
**Connection method:** VS Code terminal using Docker Compose and PostgreSQL CLI (`psql`).

Connection command:

```bash
docker compose exec db psql -U bookswap -d bookswap
```

**Container start time:**
- UTC: 2026-11-02 16:01:57
- Sri Lanka time: 2026-11-02 21:31:57

## 2. Initial Database Verification

The database contains four main tables:

- `books`
- `members`
- `borrow_requests`
- `loans`

### Initial row counts

```sql
SELECT
    (SELECT COUNT(*) FROM members) AS members,
    (SELECT COUNT(*) FROM books) AS books,
    (SELECT COUNT(*) FROM borrow_requests) AS requests,
    (SELECT COUNT(*) FROM loans) AS loans;
```

| Table | Expected count (assignment hint) | Actual count | Match? |
|---|---:|---:|---|
| Members | 20 | 20 | Yes |
| Books | 120 | 120 | Yes |
| Borrow requests | 30 | 30 | Yes |
| Loans | 30 | 30 | Yes |

## 3. SQL Verification Queries and Results

### Query 1 — Verify a book using its ISBN

**Requirement:** FR-1 — Book listing and details

**Question:** Does the database contain the book with ISBN `9789552100012`?

```sql
SELECT id, title, isbn, condition, status
FROM books
WHERE isbn = '9789552100012';
```

**Expected:** One matching book record.

**Actual:**

| id | title | isbn | condition | status |
|---:|---|---|---|---|
| 12 | Madol Doova | 9789552100012 | good | on_loan |

**Rows returned:** 1  
**Match:** Yes — the book record exists and its ISBN matches.

### Query 2 — Count available books in Building 12

**Requirement:** FR-1 — Book listing and availability

**Question:** How many available books are in Building 12?

```sql
SELECT COUNT(*) AS available_in_building_12
FROM books
WHERE status = 'available'
AND building_id = 12;
```

**Expected:** Not specified in the assignment brief.

**Actual:** 48

**Match:** Not assessed — the assignment does not provide an expected count for this query.

### Query 3 — Verify the status of Loan 3

**Requirement:** FR-4 — Loan tracking

**Question:** Is Loan 3 marked as returned, with a recorded return date?

```sql
SELECT id, status, borrowed_at, returned_at
FROM loans
WHERE id = 3;
```

**Expected:** Loan 3 should have status `returned` and a non-null return date.

**Actual:**

| id | status | borrowed_at | returned_at |
|---:|---|---|---|
| 3 | returned | 2026-09-04 | 2026-09-18 |

**Rows returned:** 1  
**Match:** Yes.

### Query 4 — Find members with missing phone numbers

**Requirement:** NFR-5 — Member data verification (as mapped in the assignment)

**Question:** Are there members whose phone number is missing?

```sql
SELECT id, display_name
FROM members
WHERE phone IS NULL OR phone = '';
```

**Expected:** 0 rows, according to the assignment's expected result.

**Actual:**

| id | display_name |
|---:|---|
| 17 | Member M17 |
| 19 | Member M19 |

**Rows returned:** 2  
**Match:** No.

**Finding:** Members 17 and 19 have missing phone numbers. This is a data-completeness issue. This database query alone does not establish whether private information is exposed through the API.

### Query 5 — Find outstanding loans older than 30 days

**Requirement:** FR-4 — Loan tracking

**Question:** Which outstanding loans have been borrowed for more than 30 days?

```sql
SELECT
    l.id AS loan_id,
    b.title,
    m.display_name AS borrower,
    l.borrowed_at,
    CURRENT_DATE - l.borrowed_at AS days_out
FROM loans l
JOIN books b ON b.id = l.book_id
JOIN members m ON m.id = l.borrower_id
WHERE l.status = 'out'
  AND l.borrowed_at < CURRENT_DATE - 30
ORDER BY days_out DESC;
```

**Expected:** Identify outstanding loans older than 30 days.

**Actual:**

| loan_id | title | borrower | borrowed_at | days_out |
|---:|---|---|---|---:|
| 13 | Yuganthaya | Member M20 | 2026-09-24 | 39 |
| 14 | Reef | Member M03 | 2026-09-26 | 37 |
| 15 | Madol Doova | Member M06 | 2026-09-28 | 35 |
| 16 | Yuganthaya | Member M09 | 2026-09-30 | 33 |
| 17 | Reef | Member M12 | 2026-10-02 | 31 |

**Rows returned:** 5  
**Match:** Query returned the expected type of records. Whether they are officially overdue depends on the system's loan-duration policy.

### Query 6 — Check duplicate pending borrow requests

**Requirement:** FR-3 — Borrow requests and duplicate prevention

**Question:** Are there multiple pending requests for the same book and borrower?

```sql
SELECT
    book_id,
    borrower_id,
    COUNT(*) AS pending_request_count
FROM borrow_requests
WHERE status = 'pending'
GROUP BY book_id, borrower_id
HAVING COUNT(*) > 1
ORDER BY pending_request_count DESC;
```

**Expected:** 0 duplicate groups.

**Actual:**

| book_id | borrower_id | pending_request_count |
|---:|---:|---:|
| 11 | 9 | 2 |

**Rows returned:** 1  
**Match:** No.

**Finding:** Book 11 has two pending requests from borrower 9. This indicates a possible duplicate-request data issue that should be investigated against the application behaviour.

### Query 7 — Find returned loans with missing return dates

**Requirement:** FR-4 — Loan tracking

**Question:** Are any loans marked as returned without a return date?

```sql
SELECT
    id,
    book_id,
    borrower_id,
    status,
    borrowed_at,
    returned_at
FROM loans
WHERE status = 'returned'
  AND returned_at IS NULL;
```

**Expected:** 0 rows.

**Actual:**

| id | book_id | borrower_id | status | borrowed_at | returned_at |
|---:|---:|---:|---|---|---|
| 30 | 120 | 4 | returned | 2026-10-20 | NULL |

**Rows returned:** 1  
**Match:** No.

**Finding:** Loan 30 is marked as returned, but its return date is missing.

### Query 8 — Check invalid ISBN lengths

**Requirement:** FR-1 — Book listing and details

**Question:** Are there books with ISBN values that are not 10 or 13 characters long?

```sql
SELECT
    id,
    title,
    isbn,
    LENGTH(isbn) AS isbn_length
FROM books
WHERE LENGTH(isbn) NOT IN (10, 13)
ORDER BY id;
```

**Expected:** 0 rows, assuming ISBN values must contain 10 or 13 characters.

**Actual:**

| id | title | isbn | isbn_length |
|---:|---|---|---:|
| 57 | Funny Boy | 955123456 | 9 |

**Rows returned:** 1  
**Match:** No.

**Finding:** Book 57 has a 9-character ISBN, which does not meet the expected ISBN length rule.

### Query 9 — Check invalid loan date sequences

**Requirement:** FR-4 — Loan tracking

**Question:** Are there loans where the return date is earlier than the borrowed date?

```sql
SELECT
    id,
    book_id,
    borrower_id,
    borrowed_at,
    returned_at
FROM loans
WHERE returned_at IS NOT NULL
  AND returned_at < borrowed_at;
```

**Expected:** 0 rows.

**Actual:**

| id | book_id | borrower_id | borrowed_at | returned_at |
|---:|---:|---:|---|---|
| 29 | 116 | 3 | 2026-10-18 | 2026-10-13 |

**Rows returned:** 1  
**Match:** No.

**Finding:** Loan 29 has a return date five days earlier than its borrowed date.

## 4. Database Data-Quality Findings

The SQL verification identified the following inconsistencies in the seeded database:

| Finding | Record ID | Issue | Related requirement |
|---|---|---|---|
| Missing phone numbers | Members 17 and 19 | Phone values are missing | NFR-5 |
| Duplicate pending requests | Book 11, borrower 9 | Two pending requests exist for the same book and borrower | FR-3 |
| Missing return date | Loan 30 | Status is returned, but return date is NULL | FR-4 |
| Invalid ISBN | Book 57 | ISBN contains only 9 characters | FR-1 |
| Invalid loan date sequence | Loan 29 | Return date is earlier than borrowed date | FR-4 |

These are confirmed seed-data findings. They should be investigated further before being classified as application defects. In particular, duplicate requests should be reproduced through the API or application before concluding that duplicate prevention is broken.

## 5. Reflection

### Which test case could not be passed confidently without SQL?

Database verification was important for checking whether book, member, borrow-request and loan records were stored consistently.

For example, the duplicate pending request check identified two pending requests for Book 11 from Borrower 9. The API mock response alone could not confirm whether the database contained duplicate records.

SQL was also necessary to identify missing return dates, invalid ISBN lengths and incorrect loan date sequences.

### Where did the database disagree with the API mock?

The BookSwap API mock uses predefined example responses and does not provide real database persistence or full business logic. Therefore, an API response does not prove that a record was actually saved or that the database state is correct.

For this exercise:

- **API mock:** Used to verify response structure, status codes and the behaviour represented by the mock examples.
- **PostgreSQL database:** Used to verify seeded records, stored values, relationships, counts and data consistency.

The database is the source of truth for the actual seeded records. The API mock is the source for the responses it has been configured to return. Neither can replace the other for all verification questions.

## 6. Conclusion

A total of **9 SQL verification queries** were executed against the BookSwap PostgreSQL database.

The queries covered record lookup, COUNT, JOIN operations, date comparisons, duplicate detection and data-quality checks.

The verification identified several seed-data inconsistencies, including missing phone numbers, duplicate pending requests, missing return dates, invalid ISBN length and an incorrect loan date sequence.

These findings demonstrate how SQL can support QA testing by verifying stored data and identifying inconsistencies that may not be visible through API responses alone.