# BookSwap — Non-Functional Check Report
**Session 4 / Day 3**

**Owner:** Chirani Lavanya  
**Execution date:** 16 November 2026  
**Status:** Partially completed — Day 02 baseline and Day 03 Prism mock tests executed. Practice-build checks remain blocked because the separate application environment was not supplied.

## 1. Setup and environment findings

| Field | Environment / evidence |
|---|---|
| API target | Stoplight Prism mock at `http://localhost:4010` |
| UI / practice API expected by Day 03 brief | `http://localhost:3000` / `http://localhost:3000/api` — not included in the supplied Day 02 ZIP |
| Database | PostgreSQL 16; database `bookswap`; user `bookswap` |
| Docker Compose services | `api-mock`, `db`, `adminer` |
| API specification paths | `GET /books`, `POST /books`, `POST /books/{bookId}/borrow-requests`, `PATCH /loans/{loanId}` |
| Routes not present in Day 02 OpenAPI | `/health`, `/auth/login`, `GET /loans/{loanId}` |
| k6 image | `grafana/k6:0.57.0` |
| Load-test limit | Maximum 20 VUs × 60 seconds |
| Build SHA | Not available — no separate practice build supplied |

**Environment limitation**

The Day 02 environment uses Stoplight Prism as an API mock. It returns example responses and does not represent a fully implemented application backend. API write requests are not persisted to the separate PostgreSQL seed database.

The supplied environment contains no separate UI, real authentication implementation, email service, monitoring/paging service or application audit log.

Docker Compose services were started successfully. PostgreSQL became healthy.

Database seed-data verification returned:

| Table | Actual row count |
|---|---:|
| members | 20 |
| books | 120 |
| borrow_requests | 30 |
| loans | 30 |

An unauthenticated `GET /books` request returned HTTP 401. An authenticated catalogue request using the supplied mock token returned HTTP 200.

## 2. Performance — Search endpoint

**N1 requirement:** 99% of search requests should complete in under 800 ms (p99), under the specified 10× normal request rate, measured over a rolling 28-day period.

The challenge permits a limited tester load check of 20 virtual users for 60 seconds. This is a short execution check and cannot establish the full 28-day SLO.

### 2.1 Day 03 k6 execution — Prism mock

**Target:** `http://host.docker.internal:4010`  
**Endpoint:** `GET /books`  
**Virtual users:** 20  
**Duration:** 60 seconds  
**Tool:** Grafana k6 `0.57.0`

| Metric | Requirement / purpose | Actual Prism result | Mock check |
|---|---|---:|---|
| Average response time | Informational | 7.66 ms | Recorded |
| Median response time | Informational | 5.68 ms | Recorded |
| p95 response time | Early warning | 16.23 ms | Recorded |
| p99 response time | Under 800 ms | 62.36 ms | Within threshold |
| Maximum response time | Informational | 107.23 ms | Recorded |
| Failed HTTP requests | Below 1% | 0.00% (0/1,200) | Within threshold |
| Requests completed | Record actual count | 1,200 | Recorded |
| Request rate | Record actual rate | 19.82 requests/second | Recorded |
| k6 checks | Successful checks | 100% (2,400/2,400) | Passed |

**Result:** The Prism mock load execution met the p99 and HTTP failure-rate thresholds for this limited test.

### 2.1.1 k6 Observations

The k6 load test was successfully executed against the Day 02 Prism mock API on 16 November 2026.

**Execution observations:**

1. **Test configuration:** The test used 20 virtual users for 60 seconds.
2. **Request volume:** A total of 1,200 HTTP requests were completed.
3. **Response time:** The average response time was 7.66 ms, while the median was 5.68 ms.
4. **95th percentile:** 95% of requests completed within 16.23 ms.
5. **99th percentile:** 99% of requests completed within 62.36 ms, below the 800 ms threshold.
6. **HTTP failure rate:** 0 out of 1,200 requests failed, resulting in a 0.00% failure rate.
7. **k6 checks:** All 2,400 checks passed (100%).

**Observation and interpretation:**

The Prism mock demonstrated fast response times and no HTTP request failures during this limited load test. The observed p99 response time and failure rate were within the specified thresholds.

**Evidence:** `nfr/k6-summary.txt`

### 2.2 Prior Day 02 Newman baseline

The Day 02 `chirani-session3-postman-report.md` and `reports/newman-results.xml` record:

- 7 HTTP requests executed.
- 15 assertions: 14 passed and 1 failed.
- Average response time: 73 ms.
- Maximum response time: 371 ms.
- Minimum response time: 17 ms.
- Total collection duration: 933 ms.

### 2.3 k6 execution command

The following PowerShell command was used to execute the Day 03 Prism mock test and save its output:

```powershell
Get-Content -Raw .\nfr\search-smoke.k6.js |
docker run --rm -i `
  -e BASE_URL=http://host.docker.internal:4010 `
  -e TOKEN=test-token `
  grafana/k6:0.57.0 run - 2>&1 |
Tee-Object -FilePath .\nfr\k6-summary.txt
```

**Evidence file:** `nfr/k6-summary.txt`

The separate practice-build test has not been executed because the practice API at `localhost:3000/api` was not available in the supplied project.

## 3. Reliability — Listing creation with email dependency down

| Field | Result |
|---|---|
| Expected behaviour | Listing creation succeeds (challenge example: HTTP 201); notification is queued; the request should not fail with HTTP 500 solely because email is unavailable |
| Available environment | Prism mock, PostgreSQL and Adminer |
| Email service | Not supplied |
| Actual HTTP status / response / request ID | Not run |
| Result | BLOCKED |

The supplied Day 02 Compose file does not contain an email service or a working listing backend.

This test must be performed against the authorised practice build if it provides an email or notification dependency. The actual Compose service name must be identified before stopping or restarting any service.

## 4. Reliability — Retry with the same Idempotency-Key

| Field | Result |
|---|---|
| Expected behaviour | Two identical listing requests using the same `Idempotency-Key` should create exactly one persisted listing |
| Available environment | Prism mock and a separate PostgreSQL seed database |
| Idempotency implementation | Not supplied or verified |
| Actual request statuses | Not run against a real application |
| SQL row-count verification | Not run against the real application database |
| Result | BLOCKED |

Prism returns example responses and does not persist API writes to the PostgreSQL seed database. Therefore, the Day 02 environment cannot prove that duplicate listing creation is prevented.

The test must be repeated against the actual practice API and its connected database.

## 5. Health check and monitoring

| Check | Expected behaviour | Day 02 evidence | Result |
|---|---|---|---|
| `GET /health` without token | Health endpoint accessible without JWT | Route not present in Day 02 OpenAPI | BLOCKED |
| Operations health confirmation | Under 5 minutes | No monitoring view or health endpoint supplied | BLOCKED |
| Listings outage alert | On-call team paged within 180 seconds | No monitoring or paging service supplied | BLOCKED |

These checks require the practice application and its monitoring configuration.

## 6. Authentication and audit observations

| Check | Requirement | Actual evidence | Result |
|---|---|---|---|
| Missing token | Protected endpoint returns 401 | `GET /books` without an Authorization header returned HTTP 401 on Prism | Observed on mock |
| Supplied mock token | Catalogue request returns successful response | `GET /books?page=1&pageSize=20` with `Bearer test-token` returned HTTP 200 | Observed on mock |
| Garbage / expired JWT | Return 401 | JWT validation and expiry behaviour not verified | BLOCKED |
| JWT lifetime | Maximum 3,600 seconds | No real token issuance service supplied | BLOCKED |
| 20 failed logins within 10 seconds | Return 429 or apply lockout | `/auth/login` not present in Day 02 OpenAPI | BLOCKED |
| Audit records | Authentication failures, loan creation and returns include request ID and member ID | No application audit-log source supplied | BLOCKED |

**Observation:** The missing-token request returned HTTP 401, and the supplied mock token returned HTTP 200. These observations verify the mock's responses only. They do not prove real JWT signature validation, token expiry or access-control enforcement.

## 7. Accessibility quick check — three core journeys

The supplied Day 02 ZIP does not contain the BookSwap user interface. Therefore, accessibility checks could not be executed.

| Journey | Keyboard only | Screen-reader names | axe critical / serious issues | Lighthouse score | Contrast ≥ 4.5:1 | Zoom 200% | 360 × 800 | Result |
|---|---|---|---|---|---|---|---|---|
| Search | NOT RUN | NOT RUN | NOT RUN | NOT RUN | NOT RUN | NOT RUN | NOT RUN | BLOCKED — no UI |
| List a book | NOT RUN | NOT RUN | NOT RUN | NOT RUN | NOT RUN | NOT RUN | NOT RUN | BLOCKED — no UI |
| Request a borrow | NOT RUN | NOT RUN | NOT RUN | NOT RUN | NOT RUN | NOT RUN | NOT RUN | BLOCKED — no UI |

When the authorised practice UI is available, use `accessibility/accessibility-checklist.md` to assess all three journeys.

Automated axe and Lighthouse results should be supplemented with manual keyboard and screen-reader checks.

## 8. Results summary

| Area | Target / expected evidence | Current state |
|---|---|---|
| Search performance | p99 below 800 ms and failure rate below 1% | Prism mock test completed; both thresholds met in this limited run |
| Real application performance | Practice-build load test | NOT RUN — practice API unavailable |
| Listing creation during email outage | Successful listing creation and queued notification | BLOCKED |
| Idempotency | One persisted listing after two requests with the same key | BLOCKED |
| Health and monitoring | Health endpoint and on-call alert evidence | BLOCKED |
| Authentication | JWT validation, expiry and rate-limit evidence | Partially observed on mock; real behaviour not verified |
| Accessibility | Three journeys tested | BLOCKED — no UI |
| NFR checks completed | At least 5+ checks with actual evidence | Not yet achieved |

Blocked and not-run checks are not counted as passed or failed.

## 9. Caveats and limitations

1. The k6 result was obtained against the Day 02 Prism mock, not the real BookSwap application.
2. The Prism mock is not connected to the PostgreSQL seed database for persistent API writes.
3. The 20 VUs × 60-second test does not prove the 10× traffic requirement or the rolling 28-day SLO.
4. Newman average and maximum response times are not p95 or p99 percentile measurements.
5. Day 02 OpenAPI does not define `/health`, `/auth/login` or `GET /loans/{loanId}`.
6. The supplied Day 02 project does not include a UI, email dependency, monitoring/paging service or application audit logs.
7. The successful mock-token request does not prove JWT verification or expiry enforcement.
8. Actual application defects and failed NFR checks must be supported by reproducible evidence. Blocked checks must not be reported as failures or passes.
9. Record the build SHA, execution timestamp, request IDs and relevant redacted evidence when the practice build becomes available.

## 10. Final conclusion

The Day 03 performance test was successfully executed against the supplied Day 02 Prism mock using 20 virtual users for 60 seconds. It completed 1,200 requests with a p99 response time of 62.36 ms and an HTTP failure rate of 0.00%. Both measurements were within the specified thresholds for this limited mock test.
