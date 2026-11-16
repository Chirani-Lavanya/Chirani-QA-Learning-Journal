# BookSwap — NFR-to-Test Map
**Session 4 / Day 3**

**Scenario:** BookSwap is being trialled across 200 apartment buildings. A publicity feature may create a Sunday traffic spike.

**Owner:** Chirani Lavanya  
**Status:** Updated with Day 03 Prism k6 execution evidence. Practice-build checks remain pending where the required application or services are unavailable.

## 1. NFR inventory

| # | Non-functional requirement | ISO/IEC 25010 quality characteristic | User-visible impact if it fails |
|---|---|---|---|
| N1 | Catalogue search: 99% of requests under 800 ms at 10× normal request rate, measured over a rolling 28 days. | Performance efficiency | Members wait too long for search results and abandon the journey. |
| N2 | Listing creation success rate is 99.9%; retrying a failed attempt with the same `Idempotency-Key` must not create a duplicate listing. | Reliability | Listings fail or duplicate, confusing members and polluting the catalogue. |
| N3 | Every endpoint except `/health` requires a valid JWT; tokens expire within one hour; 20 failed logins in 10 seconds trigger 429 or lockout. | Security | Unauthenticated access or password guessing may compromise accounts. |
| N4 | A complete outage of the listings endpoint pages the on-call engineer within 3 minutes. | Reliability / operability | A listing outage may continue without the team noticing. |
| N5 | Every authentication failure and every loan creation or return is logged with request ID and member ID. | Security / accountability | The team cannot trace security events or loan actions. |
| N6 | Phone numbers and addresses never appear in any API response. | Security / privacy | Private member information is exposed to other users or clients. |
| N7 | Search, list-a-book and request-a-borrow journeys are keyboard- and screen-reader-operable, have no critical/serious axe issues, and text contrast is at least 4.5:1 (WCAG 2.2 AA). | Usability / accessibility | Members using assistive technology or low-vision settings cannot complete core tasks. |

## 2. Test map

| Test ID | NFR | Test type | Test level | Measurable check | Tool | Sample size / duration | Pass threshold | Run today? |
|---|---|---|---|---|---|---|---|---|
| T1 | N1 | Performance | System | Execute catalogue search requests and record p95, p99 and failed-request rate. | k6 | Challenge cap: 20 VUs × 60 seconds. | p99 < 800 ms and `http_req_failed` < 1%. | **Partially completed.** Prism mock test executed: 20 VUs, 60 seconds, p99 62.36 ms and 0.00% failed requests. Practice-build and full SLO checks remain pending. |
| T2a | N2 | Reliability | System / integration | Create valid listings and calculate successful responses / total valid attempts × 100. | Postman or curl; API logs | Controlled request sample. A 1,000-request run may be used for an observed rate, subject to the approved load limit. | Observed success rate ≥ 99.9%; assess against the agreed measurement period and sample. | Blocked for real application verification. Prism does not persist writes. |
| T2b | N2 | Reliability | Integration | Send the same valid `POST /books` twice with one identical `Idempotency-Key`; count matching rows in PostgreSQL. | Postman/curl + psql | 2 POST attempts using one key; 1 SQL count query. | Both retries resolve consistently and the database contains exactly one listing for the unique test request. | Blocked on the supplied Day 02 Prism/seed stack. Run only against the practice API and its connected database. |
| T3a | N3 | Security — authentication | Integration / system | Call protected endpoints with no token, a garbage token and an expired token. Check `/health` without a token. | curl or Postman | At least 3 negative/positive requests against the relevant routes; repeat for critical protected endpoints. | Missing, invalid and expired JWTs receive 401; `/health` remains accessible without a token. | Missing-token check executed on Prism: `GET /books` returned 401. Real JWT checks remain blocked until the practice API and authentication service are available. |
| T3b | N3 | Security — rate limiting | System | Submit 20 failed login attempts within a 10-second window. | curl loop / Postman Runner | 20 attempts within 10 seconds. | 429 response or documented account lockout within the attempt window. | Blocked: no `/auth/login` route or working authentication service is supplied in Day 02. |
| T3c | N3 | Security — token expiry | Integration | Inspect token expiry claim and verify an expired token is rejected. | Local JWT inspection tool / curl | 1 valid token claim inspection plus 1 expired-token request. | Token lifetime ≤ 3,600 seconds; expired token receives 401. | Blocked: `test-token` is a static mock bearer value; no JWT issuing or expiry service is supplied. |
| T4 | N4 | Reliability / monitoring | System / operational acceptance | Simulate complete listings-endpoint outage in the approved local environment and measure time from outage start to on-call page. | Practice-build service controls + monitoring/alerting system | 1 controlled outage; record outage-start and page-receipt timestamps. | Page delivered within 180 seconds. | Blocked unless the practice build includes the required paging integration. |
| T5 | N5 | Security / auditability | Integration | Trigger one authentication failure, one loan creation and one loan return; inspect each corresponding log event for request ID and member ID. | curl/Postman + application logs | At least 3 events: one of each event type. | 3/3 events are logged and each contains a non-empty request ID and member ID. | Blocked: no application audit-log source or complete loan write implementation is supplied. |
| T6 | N6 | Security / privacy | System | Inspect documented list endpoints and search responses; search JSON for phone/address fields and synthetic values. | curl/Postman + grep/jq | All list endpoints in the API specification; include at least 50 records where pagination allows. | No phone number or address field/value appears in any API response. | Partially observed: one authenticated catalogue response returned HTTP 200 and was inspected. Full endpoint and pagination coverage remains pending. |
| T7 | N7 | Accessibility | System / acceptance | Complete each of the 3 core journeys using keyboard and screen reader; run axe; measure contrast; check 200% zoom. | Keyboard, NVDA/VoiceOver, axe, Lighthouse, contrast analyser | 3 journeys; every interactive control in each journey; axe scan per journey. | All journeys operable; zero critical/serious axe findings; text contrast ≥ 4.5:1; no loss/overlap at 200% zoom. | Blocked until the practice UI is available. Manual checks are required in addition to automated audits. |
| T8 | N7 — supporting compatibility check | Compatibility | System | Repeat each core journey at a 360 × 800 viewport. | Chrome DevTools device mode | 3 journeys at 360 × 800. | No clipped/overlapping controls; all journey actions remain usable. | Blocked until the practice UI is available. |

## 3. What needs a specialist or real environment

- **Sustained 10× normal traffic for 4 hours:** The challenge's 20-VU/60-second cap is a smoke-test limit, not a substitute for the full traffic spike.
- **Rolling 28-day search SLO:** A 60-second run cannot prove a 28-day performance target.
- **End-to-end paging within 3 minutes:** Requires monitoring and on-call notification integration.
- **99.9% listing success rate:** Requires a controlled environment, sufficient request volume and an agreed measurement period. Do not infer it from two requests or a short mock test.
- **JWT security and expiry:** Requires a real authentication service that issues and validates JWTs.
- **Accessibility:** Requires the actual user interface and manual keyboard/screen-reader testing.

## 4. Session 3 vs this session

Use the Session 4 challenge requirement: **99% of catalogue searches under 800 ms (p99) at 10× normal request rate**, over a rolling 28 days.

This explicitly replaces Session 3's 300 ms p95 target for one building.

Keep p95 in the report as an early-warning metric, but judge the stated search requirement against p99.

## 5. The NFR I would bet fails first

**NFR selected:** N1 — Performance efficiency.

**Reason:** The publicity feature may create a sudden traffic increase across 200 apartment buildings. Search performance is therefore an important risk to investigate.

**Available evidence:** The Day 03 Prism mock test completed 1,200 requests with a p99 response time of 62.36 ms and a 0.00% HTTP failure rate. These results were within the specified thresholds for the mock test.

**Limitation:** This does not prove that the real application will fail or pass under the expected traffic spike. The actual practice application has not been tested.

**Conclusion:** N1 is my selected risk to investigate first, based on the traffic scenario. A real application load test is required before confirming whether it fails.

## 6. Notes on test levels and types

- **Unit:** Tests an isolated function or class; usually developer-owned.
- **Integration:** Tests interactions such as API ↔ database; developer and tester.
- **System:** Tests complete application behaviour; tester-led.
- **Acceptance:** Tests business needs and user journeys; product owner and tester.

Test type and test level are separate classifications. For example, a security test can be an integration or system test.