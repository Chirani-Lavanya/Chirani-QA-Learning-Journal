# Session 02 — Day 1: Thinking Like a Tester

## Overview

This session focuses on reviewing requirements, identifying risks, and creating test conditions for the LearnLanka Tutoring Marketplace.

## Deliverables

1. `chirani-session2-requirements-review.md` — Requirements review.
2. `chirani-session2-risk-map.md` — Risk map.
3. `chirani-session2-test-conditions.md` — Test conditions covering functional requirements, non-functional requirements, and constraints.

## Test Coverage Validation

The test coverage checker is located in `tools/check_coverage.py`.

Validation results:

- **Total test conditions:** 58 (target: 25 or more).
- **Negative and boundary conditions:** 21 (target: 8 or more).
- **Requirements covered:** All 15 listed requirements have at least one condition and at least one negative or boundary condition according to the checker.

Run the checker from the Session 02 folder using:

```bash
python tools/check_coverage.py
```

## Learning Outcome

This session helped develop skills in reviewing requirements, identifying potential risks, designing negative and boundary test conditions, and checking requirement coverage.

