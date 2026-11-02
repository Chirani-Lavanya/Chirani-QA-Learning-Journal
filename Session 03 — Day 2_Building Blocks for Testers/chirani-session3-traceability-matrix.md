# BookSwap — Deliverable 2: Test Execution & Traceability

**Prepared by:** Chirani Lavanya  
**Date:** 2 November 2026  
**Environment:** Prism 5.15.10 (`http://localhost:4010`), PostgreSQL 16, Postman

## 1. Test Execution Results

| ID | Test Performed | Expected Result | Actual Result | Status |
|---|---|---|---|---|
| API-01 | Get books with a valid token | 200 OK and book list returned. | 200 OK; two example books returned. | PASS* |
| API-02 | Get books without a token | 401 Unauthorized. | 401 Unauthorized. | PASS* |
| API-03 | Check book list for phone/address details | No contact details in API response. | No phone or address fields found. | PASS* |
| API-04 | Create a book with invalid ISBN `955123456`. | 422 identifying invalid ISBN. | 422 returned, but response incorrectly identified the title. | BLOCKED |
| API-05 | Request book 11 should relate to book 11. | Response should contain `bookId: 11`. | 201 returned with example `bookId: 101`. | BLOCKED |
| API-06 | Request unavailable book 110. | Request should be rejected. | 201 returned with example `bookId: 101`. | BLOCKED |
| DB-01 | Check pending requests for book 11 / borrower 9. | Verify whether duplicate seed records exist. | Two pending records found. | FINDING |
| DB-02 | Check loans 29 and 30. | Returned loans should have valid return dates. | Loan 29 has an earlier return date; Loan 30 has no return date. | FINDING |
| DB-03 | Check loans older than 30 days. | Identify outstanding loans older than 30 days. | Five loans were between 31 and 39 days old. | PARTIAL |
| DB-04 | Check books for invalid ISBN lengths. | ISBN should contain 10 or 13 characters. | Book 57 has a 9-character ISBN. | FINDING |
| DB-05 | Check members with missing phone numbers. | No missing phone values, according to the assignment's expected result. | Members 17 and 19 have missing phone values. | FINDING |

**Status explanations:**

- **PASS*** — The mock API returned the expected response. This does not prove that the real application works.
- **FINDING** — SQL successfully identified an inconsistency in the supplied database seed data.
- **BLOCKED** — The mock API returned a predefined example response that prevented the intended business rule from being verified.
- **PARTIAL** — The query identified relevant records, but the complete expected business behaviour could not be confirmed.

## 2. Traceability Matrix

| Requirement | What Must Be Tested | Result |
|---|---|---|
| FR-1 – Book Listing and Details | Catalogue, book details, ISBN validation and book creation. | Partially tested |
| FR-2 – Search and Filters | Search by title, author and ISBN; filter by condition. | Not tested |
| FR-3 – Borrow Requests | Request creation, duplicate prevention, unavailable books and owner notification. | Partially tested |
| FR-4 – Loan Tracking | Returned loans, overdue loans and borrower history. | Partially tested |
| FR-5 – Weekly Digest | Email containing the 10 newest books to each building member. | Not tested |
| NFR-1 – Performance | Search response below 300 ms (p95) for 5,000 books. | Not tested |
| NFR-2 – Email Outage | Catalogue remains functional when email is unavailable. | Not tested |
| NFR-3 – Book Photos | JPEG/PNG formats, maximum 5 MB and photos not stored in the application database. | Not tested |
| NFR-4 – Notifications | In-app notification delivered within 2 seconds. | Not tested |
| NFR-5 – Privacy | API must not return member addresses or phone numbers. | Partially tested |

## 3. Database Data-Quality Findings

The SQL verification identified five data-quality findings in the supplied PostgreSQL seed data.

### DEF-01 — Loan 29 has an incorrect return date

- **Loan ID:** 29
- **Borrowed date:** 2026-10-18
- **Returned date:** 2026-10-13
- **Expected:** Return date should not be earlier than borrowed date.
- **Requirement:** FR-4.

### DEF-02 — Loan 30 is missing its return date

- **Loan ID:** 30
- **Status:** returned
- **Returned date:** NULL
- **Expected:** A returned loan should have a return date.
- **Requirement:** FR-4.

### DEF-03 — Duplicate pending borrow requests

- **Book ID:** 11
- **Borrower ID:** 9
- **Pending request count:** 2
- **Expected:** Duplicate pending requests for the same book and borrower should not exist.
- **Requirement:** FR-3.

### DEF-04 — Invalid ISBN length

- **Book ID:** 57
- **Title:** Funny Boy
- **ISBN:** `955123456`
- **ISBN length:** 9 characters
- **Expected:** ISBN should contain 10 or 13 characters.
- **Requirement:** FR-1.

### DEF-05 — Missing member phone numbers

- **Member IDs:** 17 and 19
- **Phone values:** NULL or empty
- **Expected:** No missing phone values, according to the SQL verification expectation.
- **Requirement:** Data completeness check (the assignment maps this query to NFR-5).

**Important note:** These findings were identified in the supplied database seed data. They are not confirmed application defects. Further testing against a working application/backend is required to determine whether the application can create or prevent these conditions.

The missing phone number finding does not itself demonstrate a privacy violation. NFR-5 privacy was partially checked separately through API-03.

## 4. Important Observations

- The invalid ISBN request returned HTTP 422, but the response identified the wrong field (title). Therefore, ISBN validation could not be confidently confirmed.
- Borrow requests for books 11 and 110 both returned an example response for book 101.
- Database checks found duplicate pending requests for book 11 and borrower 9.
- The API is a Prism mock. It returns predefined example responses and does not perform real BookSwap business operations or save API requests to PostgreSQL.
- The overdue query identified five loans older than 30 days. The rule for whether a loan is officially overdue still needs clarification.
- SQL verification identified inconsistent loan dates, missing return dates, an invalid ISBN length and missing member phone values in the supplied seed data.

## 5. Coverage Gaps

The following tests still need to be completed using a working BookSwap application/backend:

1. **Search and condition filters (FR-2):** Search by title, author and ISBN, and verify filtering by condition.
2. **Borrow requests (FR-3):** Test own-book rejection, duplicate-request prevention, unavailable-book rejection and owner notifications.
3. **Loan tracking (FR-4):** Return a loan and verify borrower history and overdue behaviour.
4. **Weekly digest (FR-5):** Verify that the email contains the 10 newest books for each building member.
5. **Performance (NFR-1):** Verify search response time below 300 ms (p95) with 5,000 books.
6. **Email outage (NFR-2):** Verify that the catalogue remains functional when email is unavailable.
7. **Book photos (NFR-3):** Test JPEG/PNG formats, the 5 MB limit and photo storage behaviour.
8. **Notifications (NFR-4):** Verify in-app notification delivery within 2 seconds.
9. **Privacy (NFR-5):** Check all relevant API responses to ensure member addresses and phone numbers are not exposed.

## 6. Conclusion

API and database verification was performed using Postman, Prism and PostgreSQL.

The execution covered API authentication, book listing, privacy-related response checks, invalid ISBN input, borrow-request examples and database verification.

The SQL verification identified five data-quality findings in the supplied seed data, including duplicate pending requests, missing return dates, an incorrect loan date sequence, an invalid ISBN length and missing member phone values.

Some checks passed against the mock API responses or confirmed the supplied database state. However, the complete BookSwap business requirements could not be verified because the available API is a mock and does not implement the full business logic or database persistence.

Further testing against a working application/backend is required to verify the remaining functional and non-functional requirements.