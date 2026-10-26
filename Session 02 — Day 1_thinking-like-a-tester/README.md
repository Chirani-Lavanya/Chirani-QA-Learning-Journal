# LearnLanka — Thinking Like a Tester

**BISTEC Hearts Academy — Session 2, Day 1**

This repository contains my four deliverables for the LearnLanka Tutoring Marketplace testing challenge.

## Deliverables

1. **Requirements Review Log** — identifies ambiguous, untestable, missing and conflicting requirements.
2. **Test Conditions List** — defines positive, negative and boundary conditions covering functional requirements, non-functional requirements and technical constraints.
3. **Risk Map and Risk Register** — prioritises risks using likelihood and impact scores.
4. **Testability Feedback** — reviews the reference user stories and suggests improvements to their acceptance criteria.

## Repository Structure

```text
Session 02 — Day 1_thinking-like-a-tester/
├── README.md
├── chirani-session2-requirements-review.md
├── chirani-session2-test-conditions.md
├── chirani-session2-risk-map.md
├── chirani-session2-testability-feedback.md
├── data/
│   └── risk-register.csv
└── tools/
    ├── check_coverage.py
    └── score_risks.py

## Requirements

- Python 3.11 or later
- A terminal

No external Python packages are required for the two validation scripts.

## How to Run the Scripts

Open a terminal in this folder.

### 1. Check Test-Condition Coverage

## Terminal
python3 tools/check_coverage.py

This script checks whether the test conditions cover all functional requirements (FR-1 to FR-5), non-functional requirements (NFR-1 to NFR-5) and technical constraints (CON-1 to CON-5).

**Expected passing results:**
- At least 25 test conditions
- At least 8 negative or boundary conditions
- Every required FR, NFR and CON covered
- Exit code `0`

### 2. Validate and Rank the Risk Register

## Terminal
python3 tools/score_risks.py

This script calculates risk scores, ranks risks by score and impact, and checks that linked test-condition IDs exist.

**Expected passing results:**
- At least 10 risks
- At least 3 risks scoring 6 or 9
- 100% of risks linked to valid test conditions
- At least 3 distinct risk scores
- Exit code `0`
- `VALIDATION PASSED` displayed

## Latest Validation Results

- **Test conditions:** 63 total, including 31 negative or boundary conditions. All 15 required FR, NFR and CON references are covered.
- **Risk register:** 15 risks, 8 scoring 6 or 9, 5 distinct risk scores and 0 invalid test-condition links. Validation passed.

## Purpose

The purpose of this challenge is to identify requirement gaps before development, derive testable conditions, prioritise risks and provide actionable feedback on acceptance criteria.

