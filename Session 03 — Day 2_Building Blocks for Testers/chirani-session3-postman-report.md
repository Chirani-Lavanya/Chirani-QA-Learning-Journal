# BookSwap — Postman Smoke Report

## 1. Setup

- **Mock stack:** Docker Compose with Stoplight Prism API mock
- **Base URL:** `http://localhost:4010`
- **Collection:** `postman/chirani-session3-bookswap.postman_collection.json`
- **Environment:** `postman/bookswap-local.postman_environment.json`

**Environment variables:**

- `baseUrl` = `http://localhost:4010`
- `token` = `test-token`
- `bookId` = `101`

Previously verified:

- An unauthenticated `GET /books` request returned `401 Unauthorized`.
- An authenticated `GET /books` request using `Authorization: Bearer test-token` returned `200 OK`.

### Newman execution command

Run from the Session 3 Day 2 project folder:

```bash
npx newman@6.2.1 run postman/chirani-session3-bookswap.postman_collection.json -e postman/bookswap-local.postman_environment.json --reporters cli,junit --reporter-junit-export reports/newman-results.xml
```

## 2. Results Summary

| Metric | Target | Achieved |
|---|---|---|
| Requests in collection | 6 or more | 7 |
| Requests with assertions | 100% | 7/7 (100%) |
| Test scripts executed | 7 | 7 |
| Total assertions | All pass | 15 |
| Passed assertions | All pass | 14 |
| Failed assertions | 0 | 1 |
| Negative requests | 3 or more | 3 |
| Newman execution | Completed | Completed with 1 assertion failure |
| Average response time | Record actual result | 73 ms |
| Maximum response time | Record actual result | 371 ms |
| Total execution duration | Record actual result | 933 ms |

**Note:** The collection contains three negative scenarios: missing title, missing authentication token, and invalid ISBN. The invalid ISBN scenario returned a validation response, but its ISBN-specific assertion failed because the response identified the `title` field instead.

## 3. Request Execution Results

| No. | Request | Expected/Observed HTTP Status | Result |
|---|---|---|---|
| 01 | List books | 200 OK | PASS |
| 02 | Create book - check mock example response | 201 Created | PASS |
| 03 | Create book without title | 422 Unprocessable Entity | PASS |
| 04 | Submit borrow request | 201 Created | PASS |
| 05 | List books without token | 401 Unauthorized | PASS |
| 06 | Search books by ISBN and check privacy | 200 OK | PASS |
| 07 | Create book with invalid ISBN | 422 Unprocessable Entity | FAIL – response mismatch |

## 4. Findings

1. **Authentication:** The authenticated catalogue request returned `200 OK`, while the same request without an Authorization header returned `401 Unauthorized`. This confirms the authentication responses provided by the mock.

2. **Create book response:** The create-book request returned `201 Created` with a predefined example book titled `Madol Doova`, even though the submitted request contained a different title. The assertion verifies the observed mock example response. It does not prove that the API creates a book using the submitted data. Actual create-book business logic requires verification against a functioning backend.

3. **Missing title validation:** A create-book request without the required title returned `422 Unprocessable Entity`. The response identified the missing `title` field, and the corresponding assertions passed.

4. **Borrow request:** The borrow-request endpoint returned `201 Created` with a pending status. However, the response contained predefined example data and did not demonstrate that the requested book ID was processed or that a borrow request was persisted in the database.

5. **Privacy check:** The tested catalogue response did not contain `phone` or `address` fields. This is a limited API response check and does not prove that all endpoints meet the privacy requirement (NFR-5).

6. **DEF-06 – ISBN validation response mismatch:** A create-book request was submitted with an invalid 9-digit ISBN (`955123456`). The mock returned `422 Unprocessable Entity`, but the response identified the `title` field instead of the `isbn` field. The assertion checking whether the validation response identified the ISBN field therefore failed. This indicates a mismatch in the mock's configured response and requires further investigation. It does not independently prove a defect in the actual BookSwap application.

## 5. Newman Execution Results

The Newman execution completed and generated the JUnit report. However, one assertion failed.

- Total requests executed: 7
- Request-level failures: 0
- Test scripts executed: 7
- Assertions executed: 15
- Assertions passed: 14
- Assertions failed: 1
- Total execution duration: 933 ms
- Average response time: 73 ms
- Maximum response time: 371 ms
- Minimum response time: 17 ms

**Overall result: PARTIAL PASS — 14 of 15 assertions passed; 1 assertion failed.**

The JUnit report was generated at:

`reports/newman-results.xml`

A Node.js deprecation warning (`DEP0176`) appeared during execution. It did not cause the assertion failure.

## 6. Questions for the Developer Pair

1. What request body and validation rules are required for a successful `POST /books` operation?
2. Does the mock intentionally return predefined responses for borrow requests, or should the API return the requested book ID and persist the borrow request?
3. Is overdue status calculated from `borrowed_at` and the due date, or should the database store an explicit overdue status?
4. Should the catalogue search endpoint support searching by ISBN, title and author?
5. Why does the invalid ISBN request return a validation error identifying the `title` field instead of the `isbn` field?

## 7. Limitations

- Stoplight Prism provides predefined mock responses rather than implementing the complete application business logic.
- Successful HTTP responses from the mock do not confirm actual database persistence.
- The create-book response does not demonstrate that the submitted book data is stored.
- The borrow-request response does not demonstrate duplicate prevention or correct book ID handling.
- The privacy assertion checks only the tested catalogue response.
- The invalid ISBN scenario returned HTTP 422, but the response did not identify the expected ISBN field.
- Further testing against a functioning backend is required to verify actual business rules and data persistence.

## 8. Conclusion

The BookSwap Postman smoke collection contains seven requests and covers positive and negative API scenarios, including authentication, missing-title validation, invalid ISBN validation, borrowing and a limited privacy check.

The latest Newman execution completed with 14 of 15 assertions passing and one assertion failure. The failed assertion relates to the invalid ISBN scenario, where the mock response identified the `title` field instead of the `isbn` field.

The collection meets the target of at least three negative scenarios. However, the validation response mismatch should be investigated, and further testing against a functioning backend is required to verify actual book creation, borrow-request persistence, business rules, duplicate prevention and complete privacy requirements.