## BookSwap – Test Case Set

Session 3, Day 2 Challenge | Deliverable 

## Name: Chirani Lavanya

Environment: BookSwap API mock (Stoplight Prism) and PostgreSQL seed database.

## 1. Scope and Entry / Exit Criteria

Scope

- FR-1: Create and view book listings.
- FR-2: Search books and filter by condition.
- FR-3: Submit and validate borrow requests.
- FR-4: Track loans, overdue books and borrower history.
- FR-5: Weekly digest containing the 10 newest books for each building.
- NFR-5: Do not expose members’ phone numbers or addresses in API responses.
Out of scope for execution with the supplied mock: Real email delivery, in-app notifications, photo upload and performance measurements. The supplied Prism mock returns example responses and does not implement application business logic or database writes. UI cases are prepared for the later UI session.

Entry criteria

- Docker services are running and PostgreSQL seed data is loaded.
- Prism is available at http://localhost:4010.
- Postman and a non-empty bearer token are available for authenticated API checks.
Exit criteria
- Execute the applicable API and DB checks and record evidence in Deliverable 2.
- Mark each case Pass, Fail or Blocked.
- Record defects and blocked checks.
- Verify that API responses do not expose phone numbers or addresses.

## 2. Test Cases

# BookSwap – Test Case Set

| TC-ID | Title | Req Ref | Priority | Layer | Preconditions | Test Data | Steps | Expected Result |
|---|---|---|---|---|---|---|---|---|
| BS-TC-001 | Create a book with valid details | FR-1 | High | API | Prism running; token available | Title: QA Practice Book; Author: Test Author; ISBN: 9789552199999; Condition: good | 1. Send POST /books with valid JSON and bearer token. 2. Inspect response. | API contract specifies 201 Created; response contains submitted book details. Verify actual persistence against the real application, not Prism. |
| BS-TC-002 | Reject a book with an invalid ISBN | FR-1 | High | API | Prism running; token available | ISBN: 955123456; other required fields valid | 1. Send POST /books with invalid ISBN. 2. Inspect response. | API contract specifies 422 Unprocessable Entity; real application must not create the invalid listing. |
| BS-TC-003 | View the book catalogue | FR-1 | High | API | Prism running; token available | page=1, pageSize=20 | 1. Send GET /books?page=1&pageSize=20. 2. Inspect response structure. | 200 OK; response follows catalogue response schema and includes book listing details. |
| BS-TC-004 | Search the catalogue by title | FR-2 | High | API | Prism running; token available | Search term: Madol Doova | 1. Send GET /books?search=Madol%20Doova. 2. Inspect returned books. | Real application returns books matching the title search. Prism example data alone does not prove search logic. |
| BS-TC-005 | Filter books by condition | FR-2 | Medium | API | Prism running; token available | Condition: fair | 1. Send GET /books?condition=fair. 2. Inspect each returned book. | Real application returns only books with condition fair. |
| BS-TC-006 | Create a borrow request for an available book | FR-3 | High | API | Real application test data has an available book; borrower is not its owner. | Available book ID; valid borrower token; message: I would like to borrow this book. | 1. Send POST /books/{bookId}/borrow-requests with message and token. 2. Inspect response. | API contract specifies 201 Created; a pending request is created in the real application and owner is notified as required. |
| BS-TC-007 | Prevent a duplicate pending borrow request | FR-3 | High | DB / API | Seed data loaded; real API available for behaviour check. | Book ID 11; Borrower ID 9 | 1. Run SQL check. 2. Attempt another request for the same book and borrower through the real API. | Seed data contains duplicate pending requests to investigate. Real application should prevent another duplicate active request; API contract lists 409 Conflict for a conflict. |
| BS-TC-008 | Prevent a member from requesting their own book | FR-3 | High | DB / API | Seed data loaded; real API available for behaviour check. | Book ID 5; Owner ID 6; Borrower ID 6 | 1. Verify owner in books. 2. Inspect matching request in borrow_requests. 3. Attempt request through real API. | Real application must reject a member's request to borrow their own book. Supplied API definition does not specify the exact status code. |
| BS-TC-009 | Reject a borrow request for an unavailable book | FR-3 | High | API | Seed data loaded; verify book 110 is unavailable before testing. | Book ID 110; valid borrower token and message. | 1. Check book status in books. 2. Send POST /books/110/borrow-requests. 3. Inspect response and database. | Real application rejects the request and creates no borrow request. Supplied API definition does not specify the exact status code. |
| BS-TC-010 | Mark a loan as returned | FR-4 | High | API | Suitable existing loan available; token available. | Existing loan ID; body: {"status":"returned"} | 1. Send PATCH /loans/{loanId} with body and token. 2. Inspect response. 3. Verify real DB row. | API contract specifies 204 No Content; real database should show loan as returned. Prism does not perform the DB update. |
| BS-TC-011 | Identify loans overdue by more than 30 days | FR-4 | High | DB | PostgreSQL seed data loaded. | loans.status, loans.borrowed_at, loans.returned_at | 1. Run overdue-loan SQL check. 2. Review returned IDs and dates. | Identify loans still outstanding for more than 30 days. Returned loans must not be classified as currently overdue. |
| BS-TC-012 | Retrieve a borrower's loan history for a book | FR-4 | Medium | DB | PostgreSQL seed data loaded. | loans.book_id, loans.borrower_id | 1. Query loans for selected book and borrower. 2. Review loan status and dates. | Query returns matching borrowing history for that book and borrower. |
| BS-TC-013 | Verify the weekly digest contains the 10 newest books | FR-5 | Medium | UI / DB | Digest feature and email test environment available. | A building with eligible members; its 10 newest books. | 1. Identify 10 newest books for a building. 2. Inspect generated digest. 3. Compare book list. | Digest contains the 10 newest books from that member's building. Blocked until digest functionality is available. |
| BS-TC-014 | Verify eligible members receive the weekly digest | FR-5 | Medium | UI | Digest feature and test email accounts available. | Eligible members in the same building. | 1. Trigger or wait for scheduled digest. 2. Check test inboxes of eligible members. | Each eligible member receives the weekly digest for their building. Blocked with supplied Prism mock. |
| BS-TC-015 | Reject a request without a bearer token | Authentication | High | API | Prism running. | GET /books; no Authorization header. | 1. Send GET /books without Authorization header. 2. Inspect response. | 401 Unauthorized; protected response data is not returned. |
| BS-TC-016 | Verify catalogue responses do not expose private member data | NFR-5 | High | API | Prism running; token available. | GET /books | 1. Send GET /books with valid token. 2. Inspect all top-level and nested JSON fields. | No member phone numbers or addresses are included in API response. |
| BS-TC-017 | Verify search responses do not expose private member data | NFR-5 | High | API | Prism running; token available. | GET /books?search=Madol%20Doova | 1. Send search request with valid token. 2. Inspect all top-level and nested JSON fields. | No member phone numbers or addresses are included in API response. |

## 3. SQL Verification Checks

Run these against the PostgreSQL seed database. They inspect seed data; they do not prove that the application correctly rejects invalid requests.

BS-TC-007 – Duplicate pending requests

SELECT id, book_id, borrower_id, status

FROM borrow_requests
WHERE book_id = 11
  AND borrower_id = 9
  AND status = 'pending';
BS-TC-008 – Own-book request
SELECT b.id AS book_id,
       b.owner_id,
       br.borrower_id,
       br.status
FROM books b
JOIN borrow_requests br ON br.book_id = b.id
WHERE b.id = 5
  AND b.owner_id = br.borrower_id;
BS-TC-011 – Outstanding loans older than 30 days
SELECT id, book_id, borrower_id, borrowed_at, returned_at, status
FROM loans
WHERE status = 'out'
  AND returned_at IS NULL
  AND borrowed_at < CURRENT_DATE - INTERVAL '30 days';
BS-TC-016 / BS-TC-017 – Seed members with missing phone values
SELECT id, display_name, phone
FROM members
WHERE id IN (17, 19)
  AND (phone IS NULL OR phone = '');

## 4. Challenge Seed Data

## 2. Test Data Set

| Data Set | Seed Value | Purpose |
|---|---|---|
| DS-01 | Book ID 57; ISBN 955123456 | Invalid ISBN seed record. |
| DS-02 | Book ID 110 | Confirm unavailable status before the test. |
| DS-03 | Book ID 5; Owner ID 6; Borrower ID 6 | Own-book request seed record. |
| DS-04 | Book ID 11; Borrower ID 9 | Duplicate pending request seed records. |
| DS-05 | Member IDs 17 and 19 | Empty and NULL phone values for privacy checks. |
| DS-06 | Seeded loans rows | Loan status, dates and borrowing history checks. |

Use only IDs confirmed in the supplied seed data. For other API cases, select valid records from the database or create suitable data in a real test environment; do not assume example IDs exist.

## 5. UI Cases Prepared for the Later Session

When the BookSwap UI becomes available, use the related scenarios to check:

- Listing creation and ISBN validation (BS-TC-001–002).
- Catalogue display, title search and condition filtering (BS-TC-003–005).
- Borrow requests and invalid request scenarios (BS-TC-006–009).
- Returned loans, overdue status and borrower history (BS-TC-010–012).
- Weekly digest and delivery (BS-TC-013–014).
- Authentication and privacy (BS-TC-015–017).

## 6. Execution Status
   
No execution results are claimed in this Deliverable 1 document. Record actual outcomes, evidence, defects and blocked tests in Deliverable 2 after running the checks.

Mock limitation: Stoplight Prism returns OpenAPI example responses. It does not implement the real application business rules or write changes to PostgreSQL. A sample 201, 204 or other response from Prism is not proof that the corresponding business operation succeeded.
