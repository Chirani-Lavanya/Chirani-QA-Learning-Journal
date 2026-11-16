# BookSwap Quality Test Pack — Session 4 / Day 03

**Track:** BISTEC Hearts Academy — QA Intern Onboarding  
**Owner:** Chirani Lavanya  
**Source basis:** Day 03 challenge brief and the uploaded Session 3 / Day 02 BookSwap ZIP.

This repository contains the four Day 03 deliverables, reusable test scripts, and the relevant Day 02 OpenAPI/SQL/Postman evidence.

## Repository layout

```text
bookswap-quality-tests/
├── README.md
├── nfr/
│   ├── nfr-test-map.md
│   ├── nfr-check-report.md
│   ├── search-smoke.k6.js
│   ├── k6-summary.txt
│   └── reliability-checks.md
├── security/
│   ├── security-checklist.md
│   ├── checks.sh
│   ├── security-headers.txt
│   ├── zap-report-required.txt
│   └── evidence/                    # generated local outputs
├── accessibility/
│   ├── accessibility-checklist.md
│   └── evidence/                    # axe/Lighthouse results
├── defects/
│   └── defect-report-set.md
└── references/session3/             # selected Day 02 project files and evidence
```

## 1. Start the supplied Day 02 stack

From the repository root:

```bash
cd references/session3
docker compose up -d
docker compose ps
```

The supplied compose file starts:

- Prism API mock: `http://localhost:4010`
- PostgreSQL: `localhost:5432` (database `bookswap`, user `bookswap`)
- Adminer: `http://localhost:8080`

The Day 02 README records that `GET /books` without a token returned 401 and `GET /books` with `Authorization: Bearer test-token` returned 200 on Prism.

Connect to PostgreSQL:

```bash
docker compose exec db psql -U bookswap -d bookswap
```

## 2. Deliverable 1 — NFR-to-Test Map

See `nfr/nfr-test-map.md`. All seven Day 03 NFRs are mapped to measurable checks, tool, sample size/duration, threshold, test type, level, and run-today/specialist status. The Day 03 search requirement **p99 < 800 ms** supersedes Day 02's old **p95 < 300 ms** target.

## 3. Deliverable 2 — Non-Functional Check Report

See `nfr/nfr-check-report.md`. It includes the real Day 02 Newman baseline (7 requests, 14/15 assertions, average 73 ms, max 371 ms) but correctly does not call this a p95/p99 or load-test result.

### Run k6 against Day 02 Prism (method only)

From the repository root:

```bash
docker run --rm -i -e BASE_URL=http://host.docker.internal:4010 \
  -e SEARCH_PATH=/books -e TOKEN=test-token \
  grafana/k6:0.57.0 run - < nfr/search-smoke.k6.js | tee nfr/k6-summary.txt
```

On Linux, add `--add-host=host.docker.internal:host-gateway` to `docker run` if needed. A Prism result validates the script and API shape only; it does not prove the real application meets the performance requirement.

If the separate Day 03 practice build is available, run its local API at the challenge-prescribed lower-load check:

```bash
docker run --rm -i -e BASE_URL=http://host.docker.internal:3000/api \
  -e SEARCH_PATH=/books -e TOKEN="$TOKEN_A" \
  grafana/k6:0.57.0 run --vus 5 - < nfr/search-smoke.k6.js | tee -a nfr/k6-summary.txt
```

The challenge cap is 20 VUs for 60 seconds. Do not claim that a 60-second run proves 10x traffic for four hours or a rolling 28-day SLO.

### Reliability tests

See `nfr/reliability-checks.md`. The supplied compose stack has no email service. The supplied OpenAPI/Prism mock has no real write path or idempotency implementation. Run the reliability checks only against the practice build and its connected database. The SQL schema in the Day 02 ZIP may be used for seed-data inspection, not as proof of API persistence.

## 4. Deliverable 3 — Security checklist

See `security/security-checklist.md` before running the checks. The `security/checks.sh` helper is limited to loopback targets and requires `CONFIRM_PRACTICE_BUILD=YES`.

Set only synthetic test credentials in your local terminal; do not commit tokens/passwords:

```bash
export CONFIRM_PRACTICE_BUILD=YES
export API_BASE=http://localhost:3000/api
export TOKEN_A='synthetic-member-a-token'
export TOKEN_B='synthetic-member-b-token'
export LOAN_A_ID='synthetic-loan-owned-by-member-a'
```

Then run:

```bash
bash security/checks.sh
```

The two-account BOLA and login rate-limit checks need working test accounts and a real practice auth/API service. The Day 02 OpenAPI has `PATCH /loans/{loanId}` but no `GET /loans/{loanId}` or `/auth/login`; do not assume those operations are available on Prism.

Capture headers from the practice UI:

```bash
curl -sS -I http://localhost:3000 | tee security/security-headers.txt
```

Run the passive ZAP baseline only against the authorised local practice build, following `security/zap-report-required.txt`. Review each alert; a scanner alert is not automatically a confirmed defect. Report potential security findings privately first and mark confirmed Jira issues Restricted.

## 5. Deliverable 4 — Defect Report Set

See `defects/defect-report-set.md`. It uses six actual Day 02 observations from the uploaded SQL/Newman evidence. The Day 02 SQL report explicitly says its five database findings are seed-data findings requiring application-level reproduction before classifying them as product defects. The invalid-ISBN mismatch is confirmed in the Prism/Newman mock evidence, but real application behaviour remains unknown.

These findings provide a defensible evidence-based start, **not five confirmed Day 03 application defects**. The challenge's performance, BOLA/security and accessibility defect types still require the practice build. 

## 6. Accessibility

See `accessibility/accessibility-checklist.md`. The Day 02 ZIP has no UI, so keyboard, NVDA, axe, Lighthouse, contrast, 200% zoom and 360×800 checks are blocked until the practice UI is available.

## 7. Before pushing to GitHub

Replace all `NOT RUN` / `BLOCKED` values only after capturing real results. Add k6, ZAP, axe and Lighthouse outputs under their evidence folders. Redact security evidence and never commit tokens, passwords, real personal data or unredacted response bodies.

```bash
git init
git add .
git status
git commit -m "Add Session 4 Day 03 BookSwap quality test pack"
git branch -M main
git remote add origin YOUR_GITHUB_REPOSITORY_URL
git push -u origin main
```
