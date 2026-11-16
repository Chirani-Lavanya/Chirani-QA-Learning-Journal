# BookSwap – Security Testing Checklist

**Session:** 4 – Day 03: Testing for Quality  
**Project:** BookSwap  
**Tester:** Chirani Lavanya  
**Testing Date:** 16 November 2026  
**Testing Type:** Manual API Security Testing  

---

## 1. Objective

The objective of this security testing checklist is to identify potential security weaknesses in the BookSwap application by checking:

- Authentication and authorization
- Broken Object Level Authorization (BOLA)
- SQL injection and script injection
- Input validation and oversized input
- Personally Identifiable Information (PII) exposure
- Login rate limiting
- HTTP security headers
- OWASP ZAP security scanning

Testing should verify that users can access only permitted resources, input is handled safely, and sensitive personal information is protected.

## 2. Testing Environment

| Item | Details |
|---|---|
| Project | BookSwap |
| Testing type | Security Testing |
| Testing approach | Manual API Security Testing |
| Available API environment | Stoplight Prism Mock API |
| Available API URL | http://localhost:4010 |
| Required practice API | http://localhost:3000/api |
| API testing tool | PowerShell cURL |
| Container environment | Docker Desktop |
| Database | PostgreSQL 16 |
| Mock authentication header | Authorization: Bearer test-token |
| Testing date | 16 November 2026 |

### 2.1 Environment Limitation

The available Day 02 environment provides a Stoplight Prism mock API on port 4010.

The separate Day 03 BookSwap practice application expected on port 3000 has not been provided or confirmed as available.

The available environment contains:

- Prism mock API
- PostgreSQL seed database
- Adminer

It does not provide the separate application implementation, real authentication service, ownership validation, or application-side security controls required for complete security verification.

Therefore:

1. Results from port 4010 are observations of the Prism mock API.
2. Mock responses do not prove that the actual BookSwap application is secure or vulnerable.
3. Tests requiring real accounts, ownership validation, database persistence, or application-side input validation remain pending.
4. Blocked and inconclusive tests must not be reported as passed or failed.
5. No testing should be performed against production or unauthorised third-party systems.

## 3. Security Testing Checklist

### S1 – Missing Authentication Token

**Objective:** Verify whether the API prevents unauthenticated users from accessing protected resources.

**Endpoint:**

`GET /books`

**Test request:**

```powershell
curl.exe -i "http://localhost:4010/books"
```

**Expected result:**

- HTTP 401 Unauthorized.
- The API should reject requests without a valid authentication token.

**Actual result:**

- HTTP 401 Unauthorized was returned.

**Status:** Observed – Expected behaviour on mock API.

**Evidence:** Missing-token request returned HTTP 401.

**Limitation:** This observation does not establish the authentication behaviour of the actual BookSwap application.

---

### S2 – Invalid Authentication Token

**Objective:** Verify whether the API rejects an invalid or malformed authentication token.

**Endpoint:**

`GET /books`

**Test request:**

```powershell
curl.exe -i `
  -H "Authorization: Bearer abc" `
  "http://localhost:4010/books?page=1&pageSize=20"
```

**Expected result:**

- HTTP 401 Unauthorized.
- The API should reject invalid or expired tokens.

**Actual result:**

- HTTP 200 OK was returned.
- Two predefined catalogue records were returned.

**Status:** Observed – Unexpected mock API response.

**Evidence:** The mock API returned HTTP 200 when the invalid bearer token `abc` was supplied.

**Limitation:** Prism may not implement real JWT signature validation. This is not a confirmed authentication vulnerability in the actual application.

**Further action:**

Repeat the test against the actual practice API using invalid, malformed and expired JWTs.

---

### S3 – Broken Object Level Authorization (BOLA): Read Access

**Objective:** Verify whether one user can access another user's private resources by changing an object ID.

**Test scenario:**

1. Authenticate as Member A.
2. Identify a resource belonging to Member B.
3. Record the resource ID.
4. Change the resource ID in Member A's API request.
5. Attempt to access Member B's resource.
6. Inspect the response and verify whether private information is exposed.

**Expected result:**

- HTTP 403 Forbidden or an appropriate HTTP 404 response.
- Member A must not access Member B's private resources without authorization.

**Actual result:**

- The required `GET /loans/{loanId}` endpoint is not available in the supplied Day 02 OpenAPI specification.
- Separate real user authentication and ownership controls are unavailable.

**Status:** BLOCKED – Not executed.

**Reason:** The required endpoint and two authenticated test accounts are unavailable.

**Evidence required when the practice application is available:**

- Member A's authenticated request.
- Member B's resource ID.
- API response received by Member A.
- Evidence showing whether another member's information was exposed.

**Further action:**

Execute this test against the authorised practice application using two separate test accounts.

---

### S4 – Broken Object Level Authorization (BOLA): Modify Access

**Objective:** Verify whether one user can modify another user's resources without permission.

**Test scenario:**

1. Authenticate as Member A.
2. Identify a loan or resource belonging to Member B.
3. Record the resource ID and its current database values.
4. Attempt to modify the resource using Member A's account.
5. Inspect the API response.
6. Verify whether Member B's database record has changed.

**Expected result:**

- The application should reject unauthorized modifications.
- HTTP 403 Forbidden or an appropriate HTTP 404 response should be returned.
- Member B's data must remain unchanged.

**Actual result:**

- The OpenAPI specification includes `PATCH /loans/{loanId}`.
- Real ownership controls and separate user authentication are not available.
- The mock API does not establish whether database records are actually modified.

**Status:** BLOCKED – Real authorization validation not completed.

**Evidence required:**

- Member A's authenticated request.
- Member B's resource ID.
- API response.
- Before-and-after database evidence showing whether the record changed.

**Further action:**

Repeat the test against the actual practice application with two separate test accounts and its connected database.

---

### S5 – SQL Injection and Script Injection

**Objective:** Verify whether the API safely handles potentially malicious input.

#### S5.1 – SQL Injection

**Endpoint:**

`GET /books`

**Test request:**

```powershell
curl.exe -i --get `
  -H "Authorization: Bearer test-token" `
  --data-urlencode "search=' OR 1=1 --" `
  "http://localhost:4010/books"
```

**Expected result:**

- The API should safely handle the search input.
- It should not expose additional records or allow unauthorized database access.
- User input should be handled using secure query practices.

**Actual result:**

- HTTP 200 OK was returned.
- The same two predefined catalogue records were returned.
- No additional records were observed.

**Status:** Observed – No unexpected response from mock API.

**Limitation:**

Prism does not demonstrate real SQL query execution. This result cannot confirm SQL injection protection in the actual application.

**Further action:**

Repeat the test against the real practice API and verify the backend query handling.

#### S5.2 – Script Injection

**Endpoint:**

`GET /books`

**Test request:**

```powershell
curl.exe -i --get `
  -H "Authorization: Bearer test-token" `
  --data-urlencode "search=<script>alert(1)</script>" `
  "http://localhost:4010/books"
```

**Expected result:**

- The API should handle script-like input safely.
- Untrusted input should not be executed or returned in an unsafe context.

**Actual result:**

- HTTP 200 OK was returned.
- The predefined catalogue response was returned.
- The submitted script was not reflected in the JSON response.

**Status:** Observed – No script reflection in mock response.

**Limitation:**

This does not prove protection against stored or reflected XSS in the actual application. Browser-based testing is also required.

**Further action:**

Test the actual application using authorised test data and verify that untrusted input is safely handled and rendered.

---

### S6 – Oversized Input Validation

**Objective:** Verify whether the API validates excessively long input values.

**Test scenario:**

Submit a book with a title containing 5,000 characters.

**Request preparation:**

```powershell
$body = @{
    title = ("A" * 5000)
    author = "Test Author"
    isbn = "9789552199999"
    condition = "good"
} | ConvertTo-Json -Compress

[System.IO.File]::WriteAllText(
    ".\oversized-book.json",
    $body,
    [System.Text.UTF8Encoding]::new($false)
)
```

**API request:**

```powershell
curl.exe -i `
  -X POST `
  -H "Authorization: Bearer test-token" `
  -H "Content-Type: application/json" `
  --data-binary "@oversized-book.json" `
  "http://localhost:4010/books"
```

**Expected result:**

- The actual application should validate the maximum permitted title length.
- An oversized title should be rejected with an appropriate validation response, such as HTTP 400 or HTTP 422.
- The invalid book should not be saved.

**Actual result:**

- HTTP 201 Created was returned.
- The response contained a predefined example, Madol Doova, by Martin Wickramasinghe.
- The returned title was not the submitted 5,000-character title.

**Status:** INCONCLUSIVE – Mock limitation.

**Reason:**

The Prism mock returned a predefined response. It did not demonstrate whether the actual application validates or rejects oversized titles.

**Further action:**

Repeat this test against the actual BookSwap application and verify whether the request is rejected and whether any record is created.

---

### S7 – Personally Identifiable Information (PII) Exposure

**Objective:** Verify whether sensitive personal information is unnecessarily exposed through API responses.

**Test scenario:**

1. Send an authenticated catalogue request.
2. Inspect the returned JSON response.
3. Check for sensitive fields such as:
   - Phone number
   - Home address
   - Personal email address
   - Other unnecessary personal information

**Test request:**

```powershell
curl.exe -i `
  -H "Authorization: Bearer test-token" `
  "http://localhost:4010/books?page=1&pageSize=20"
```

**Expected result:**

- API responses should expose only the information required for the requested functionality.
- Phone numbers and addresses must not appear in API responses.

**Actual result:**

- The catalogue response was inspected.
- No phone number or home address fields were observed in the returned catalogue records.

**Status:** PARTIALLY CHECKED – No phone/address fields observed in the inspected catalogue response.

**Limitation:**

Only one catalogue response was inspected. This does not confirm that every API endpoint is free from PII exposure.

**Further action:**

Inspect all relevant API responses, including member profiles, book ownership, borrowing requests and loan responses, when the actual application is available.

---

### S8 – Login Rate Limiting

**Objective:** Verify whether the application limits repeated failed login attempts to reduce brute-force attacks.

**Test scenario:**

1. Send repeated login requests using invalid credentials.
2. Submit 20 failed login attempts within 10 seconds.
3. Observe the responses.
4. Check whether the application applies rate limiting or temporary account lockout.

**Expected result:**

- According to the stated NFR, 20 failed login attempts within 10 seconds should trigger HTTP 429 or an appropriate account lockout response.

**Actual result:**

- The supplied Day 02 OpenAPI specification does not provide an `/auth/login` endpoint.
- No real authentication service is available in the mock environment.

**Status:** BLOCKED – Not executed.

**Reason:** Login endpoint and authentication service are unavailable.

**Further action:**

Execute this test against the actual application when the login functionality is available. Use only authorised test accounts and the approved test environment.

---

## 4. Security Headers Verification – S9

**Objective:** Check whether the API provides appropriate HTTP security headers.

**Headers to inspect:**

| Header | Purpose |
|---|---|
| Strict-Transport-Security | Enforces HTTPS connections |
| Content-Security-Policy | Helps mitigate XSS and content injection |
| X-Content-Type-Options | Prevents MIME-type sniffing |
| X-Frame-Options | Helps protect against clickjacking |
| Referrer-Policy | Controls referrer information |
| Permissions-Policy | Restricts browser features |

**Testing command:**

```powershell
curl.exe -i http://localhost:4010/books
```

**Actual observations from the captured Prism response headers:**

- HTTP 200 response was recorded for the inspected catalogue response.
- `Content-Type: application/json` was present.
- `Access-Control-Allow-Origin: *` was present.
- `Access-Control-Allow-Credentials: true` was present.
- `Access-Control-Allow-Headers: *` was present.
- `Access-Control-Expose-Headers: *` was present.
- CSP, HSTS, X-Content-Type-Options, X-Frame-Options, Referrer-Policy and Permissions-Policy were not present in the captured response.

**Status:** OBSERVED – Prism mock response headers captured.

**Security observation:**

The combination of wildcard CORS origin and credentials enabled should be reviewed against the actual application's intended CORS configuration. The mock response alone does not establish an exploitable vulnerability.

**Important limitation:**

The available endpoint uses local HTTP. Missing HSTS on a local HTTP mock endpoint should not automatically be reported as a security defect. HSTS should be evaluated against the actual application's HTTPS configuration.

**Evidence files:**

- `security/s9-security-headers.txt`
- `security/security-headers.txt`

**Further action:**

Repeat header verification against the actual practice application and review its CORS policy, HTTPS configuration and browser security headers.

---

## 5. OWASP ZAP Security Scan – S10

**Objective:** Identify potential security issues using OWASP ZAP.

**Tool:** OWASP ZAP

**Planned target:** `http://localhost:3000/api`

**Planned activities:**

1. Start the authorised BookSwap practice application.
2. Open OWASP ZAP.
3. Configure the practice application URL.
4. Perform an OWASP ZAP baseline scan.
5. Review generated alerts.
6. Record risk levels and affected endpoints.
7. Capture the generated HTML report.
8. Document recommendations for relevant findings.

**Actual result:**

- The separate practice application was not available at `localhost:3000`.
- A ZAP baseline scan against the required practice application was not completed.
- No actual ZAP alerts or HTML report were generated.

**Status:** BLOCKED – Not executed.

**Reason:** The required practice application is unavailable.

**Evidence:** `security/zap-report-required.txt` records the outstanding report requirement.

**Important:**

Do not claim that a ZAP scan passed or failed. Do not substitute a Prism-only scan for the required practice-build scan.

**Further action:**

Run the approved ZAP baseline scan against the actual local practice application when it becomes available and retain the generated HTML report.

---

## 6. Security Test Execution Summary

| Test ID | Security area | Actual observation | Status |
|---|---|---|---|
| S1 | Missing authentication token | HTTP 401 returned | Observed – Expected mock behaviour |
| S2 | Invalid authentication token | HTTP 200 returned | Observed – Unexpected mock response |
| S3 | BOLA read access | Required endpoint and two accounts unavailable | Blocked |
| S4 | BOLA modification | Real ownership validation unavailable | Blocked |
| S5.1 | SQL injection | Same predefined records returned | Mock-only observation |
| S5.2 | Script injection | Script not reflected in mock JSON response | Mock-only observation |
| S6 | Oversized input | HTTP 201; predefined response returned | Inconclusive |
| S7 | PII exposure | No phone/address fields in inspected catalogue response | Partially checked |
| S8 | Login rate limiting | Login endpoint unavailable | Blocked |
| S9 | Security headers | Prism response headers captured | Observed – Mock only |
| S10 | OWASP ZAP scan | Practice-build scan not executed | Blocked |

## 7. Key Findings and Limitations

### 7.1 Key observations

1. The mock API returned HTTP 401 when a request was made without an authentication token.
2. The mock API returned HTTP 200 when an invalid bearer token was supplied.
3. SQL injection input did not produce additional records in the inspected mock response.
4. Script injection input was not reflected in the inspected mock JSON response.
5. The oversized-title request returned HTTP 201, but the response contained a predefined example rather than the submitted title.
6. No phone number or home address fields were observed in the inspected catalogue response.
7. The captured mock response headers included wildcard CORS settings and did not include several common security headers.

### 7.2 Testing limitations

- The available API environment is a Prism mock rather than the complete BookSwap application.
- Real JWT validation and token expiry have not been verified.
- Real user ownership and access-control validation have not been completed.
- Database persistence of API write operations has not been established.
- Input validation and SQL injection protection have not been verified against a real application backend.
- Full PII exposure coverage has not been completed.
- Login rate limiting has not been tested.
- Security header observations are limited to the local mock.
- The required OWASP ZAP practice-build scan has not been executed.

## 8. Recommendations

1. Implement and verify proper JWT authentication for all protected endpoints.
2. Validate user ownership and permissions before allowing access to or modification of resources.
3. Use parameterised SQL queries and server-side input validation.
4. Apply maximum length restrictions to user-submitted fields.
5. Avoid exposing unnecessary personal information in API responses.
6. Implement rate limiting and appropriate account protection for login attempts.
7. Configure appropriate HTTP security headers and an appropriate CORS policy for the actual application.
8. Perform OWASP ZAP testing against the authorised practice application.
9. Repeat mock-only and inconclusive tests against the actual application before making final security conclusions.
10. Retain request/response evidence and redact authentication tokens and personal information before sharing test evidence.

## 9. Overall Conclusion

The security testing checklist was partially executed using the available BookSwap Prism mock API.

Initial observations were recorded for missing authentication tokens, invalid tokens, SQL injection input, script injection input, oversized input, PII exposure and HTTP security headers.

However, these observations are limited to the mock environment and do not establish the security of the actual BookSwap application.

Several important security checks remain incomplete because the separate practice application and its supporting authentication, authorization and backend services were unavailable.

The BOLA read and modify tests, login rate-limiting test and OWASP ZAP practice-build scan remain blocked. The invalid-token and oversized-input observations require further investigation against the actual application.

All blocked and inconclusive checks must be repeated when the authorised practice application becomes available.

---

## 10. Evidence Location

**Main checklist:** `security/security-checklist.md`

**Related evidence:**

- `security/s7-books-response.json`
- `security/s7-response-headers.txt`
- `security/s9-security-headers.txt`
- `security/security-headers.txt`
- `security/zap-report-required.txt`
- `security/README-evidence.md`
- `nfr/nfr-check-report.md`
- `nfr/k6-summary.txt`
- `references/session3/`

**Testing environment:** Local BookSwap Prism Mock API (`http://localhost:4010`)

**Testing date:** 16 November 2026