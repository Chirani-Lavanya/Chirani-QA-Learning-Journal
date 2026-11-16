# BookSwap — Reliability Checks (Session 4 / Day 3)

These checks belong on the authorised Day 03 practice build and the database connected to it. The uploaded Day 02 project is not sufficient to prove them: it contains a Prism mock (fixed examples, no persistence), a separate seeded PostgreSQL database, and no email/notification service.

## R1 — Listing creation while email/notification service is down

**Requirement:** Listing creation remains successful when the notification/email dependency is unavailable; the challenge's worked example expects HTTP 201 with a queued notification, not HTTP 500.

1. Start the actual practice application and record `docker compose ps`.
2. Identify the email/notification mock service from that practice project's Compose file. Do not guess its name.
3. Stop only that authorised local service using `docker compose stop <confirmed-service-name>`.
4. Send a valid synthetic `POST /books` request through Postman using the practice API and a synthetic Member A token.
5. Record method, URL, sanitized body, status, response body, `X-Request-ID`/correlation ID and evidence that the notification was queued.
6. Restart the dependency using `docker compose start <confirmed-service-name>`.

| Evidence | Expected | Actual |
|---|---|---|
| Email mock service | Confirmed and stopped locally | BLOCKED — no email service in Day 02 Compose |
| Listing response | 201 / successful listing creation | NOT RUN |
| Notification | Queued for retry/delivery | NOT RUN |
| Request ID / logs | Capture if available | NOT RUN |
| Result | Pass only when listing succeeds despite email being down | BLOCKED on supplied Day 02 ZIP |

## R2 — Retry with one Idempotency-Key creates one listing

**Requirement:** Two identical requests with the same `Idempotency-Key` must create exactly one persisted listing.

1. Confirm the real practice API endpoint and request schema.
2. Create one unique synthetic title and one new idempotency key.
3. Send the same valid `POST /books` body twice, using exactly the same key for both attempts.
4. Record both HTTP statuses, response bodies and request IDs.
5. Query the database that is actually connected to the practice API. If it uses the supplied Day 02 `books` table, a suitable count query is:

```sql
SELECT COUNT(*)
FROM books
WHERE title = 'QA-S4-IDEMP-REPLACE-WITH-UNIQUE-TITLE';
```

**Expected:** Exactly one matching row.

| Attempt 1 status | Attempt 2 status | SQL row count | Expected count | Result |
|---|---|---:|---:|---|
| NOT RUN | NOT RUN | NOT RUN | 1 | BLOCKED until practice API + connected DB available |

The Session 3 Prism mock does not persist POST requests and the seed database is not connected to it. Therefore running repeated POST requests against port 4010 cannot prove idempotency. The Day 02 schema also does not implement an idempotency-key table/column; verify the actual practice database before relying on any SQL statement.

## Evidence to attach

- Redacted request/response from both attempts.
- The same non-secret test Idempotency-Key value used in both attempts.
- Actual SQL query and output from the application-connected database.
- Compose output and logs showing the notification dependency was stopped during R1.
- Build identifier, local timestamp and request IDs/correlation IDs where available.
