# Session 02 — Day 1: Risk Map

**Project:** LearnLanka Tutoring Marketplace  
**Author:** Chirani Lavanya  
**Status:** First Draft

## 1. Purpose

The purpose of this risk map is to identify the most important risks in the LearnLanka tutoring marketplace and prioritise testing based on likelihood and impact.

## 2. Risk Scoring Method

Likelihood and impact are each scored from 1 to 3.

- **Likelihood:** 1 = Low, 2 = Medium, 3 = High
- **Impact:** 1 = Low, 2 = Medium, 3 = High

**Risk Score = Likelihood × Impact**

| Score | Priority |
|---|---|
| 1–2 | Low |
| 3–4 | Medium |
| 6–9 | High |

## 3. Ranked Risk Register

The following risks should be matched with the records in `data/risk-register.csv`.

| Risk ID | Risk | Likelihood | Impact | Score | Linked Test Conditions | Decision |
|---|---|---:|---:|---:|---|---|
| R-01 | A student is charged but the booking is not confirmed. | 3 | 3 | 9 | TC-07; TC-09; TC-11 | Mitigate |
| R-02 | Two students book the same tutor slot. | 3 | 3 | 9 | TC-10; TC-12 | Mitigate |
| R-03 | Cancellation and refund rules cause incorrect refunds. | 3 | 3 | 9 | TC-16; TC-17; TC-18 | Mitigate |
| R-04 | Payment card information is stored on LearnLanka servers. | 2 | 3 | 6 | TC-38; TC-39 | Mitigate |
| R-05 | Search results are slower than the required response time. | 2 | 3 | 6 | TC-29; TC-30 | Mitigate |
| R-06 | Personal information is not handled according to privacy requirements. | 2 | 3 | 6 | TC-35; TC-36; TC-37 | Mitigate |
| R-07 | Weekly tutor payouts are calculated incorrectly. | 2 | 3 | 6 | TC-19; TC-20; TC-21; TC-22 | Mitigate |
| R-08 | The video service fails during tutoring sessions. | 2 | 3 | 6 | TC-33; TC-34; TC-44 | Mitigate |
| R-09 | Search results are incomplete when several filters are selected. | 2 | 2 | 4 | TC-05; TC-06 | Mitigate |
| R-10 | Users cannot understand important screens in their selected language. | 2 | 2 | 4 | TC-47; TC-48; TC-49; TC-50 | Mitigate |
| R-11 | Rating comments exceed the permitted limit or contain inappropriate content. | 2 | 2 | 4 | TC-25; TC-26; TC-28 | Mitigate |
| R-12 | The application is difficult to use on some Android screen sizes. | 2 | 2 | 4 | TC-40; TC-41 | Monitor |
| R-13 | Booking availability is affected by a service interruption. | 2 | 3 | 6 | TC-31; TC-32 | Mitigate |
| R-14 | The payment gateway integration fails. | 2 | 3 | 6 | TC-08; TC-11; TC-45 | Mitigate |
| R-15 | Tutor payouts fail because of a bank-transfer integration issue. | 2 | 3 | 6 | TC-21; TC-46 | Mitigate |

**Note:** These scores are initial estimates for the exercise, not measured production data. The ranked output must be checked against the actual CSV and the course-provided risk-scoring script.

## 4. Why the Top Three Risks Matter

### R-01: Payment succeeds but booking is not confirmed

This could cause students to lose money without receiving the session they paid for. It may also create support requests and reduce trust in the platform. Payment and booking-state consistency should therefore receive high testing priority.

### R-02: Double booking

If two students successfully book the same slot, the tutor may be unable to provide both sessions. This could result in cancellations, refunds, and a poor student experience. Concurrent booking behaviour must be tested.

### R-03: Incorrect cancellation or refund handling

The formal requirements and founders' statements conflict about cancellation and refunds. This creates a risk of incorrect financial outcomes and disputes. The business rules should be clarified before finalising the expected results.

## 5. One-Hour Testing Priorities

If only one hour were available, I would prioritise these existing test conditions:

| Order | Test Condition | Reason |
|---|---|---|
| 1 | TC-11 | Check payment-failure handling and prevent misleading payment outcomes. |
| 2 | TC-12 | Check that two students cannot successfully book the same slot. |
| 3 | TC-09 | Verify that a successful payment results in a confirmed booking. |
| 4 | TC-16 | Check cancellation when more than 12 hours remain, including the refund outcome. |
| 5 | TC-38 | Check that payment card data is not stored on LearnLanka servers. |

These are prioritisation choices for the exercise. Actual execution time and access to the required test environments must be considered.

## 6. Risks Not Tested in Version 1

The following are candidates for deferral only if the project owner explicitly accepts the remaining risk and the deferral is permitted by applicable obligations.

| Risk | Reason for Possible Deferral | Required Risk Owner |
|---|---|---|
| Detailed visual layout issues across less common mobile screen sizes | Prioritise critical booking and payment flows first. | Product Owner |
| Search performance under unusually high load beyond the agreed test profile | Test the agreed performance target first, then schedule broader load testing. | Technical Lead |
| Video capacity above the initial target of 200 simultaneous sessions | Validate the agreed launch capacity first. | Technical Lead |
| Minor translation or layout issues on non-critical screens | Prioritise complete and understandable critical user journeys. | Product Owner |

**Important:** These are proposed deferrals, not approved decisions. The responsible owner must accept the risk before it is treated as deferred. Legal, privacy, payment-security, and other mandatory obligations must not be waived simply to save testing time.

## 7. Risk Summary

- The highest initial risk score is **9**.
- Payment and booking consistency, double booking, and cancellation/refund handling are the highest-priority risks.
- Risks involving payment security, personal data, availability, performance, and tutor payouts also require attention.
- The initial risk scores should be reviewed when clearer requirements, technical information, or test evidence become available.

## 8. Validation

Before completing this deliverable:

1. Confirm that all risk IDs and scores match `data/risk-register.csv`.
2. Confirm that each linked test condition exists in `chirani-session2-test-conditions.md`.
3. Run the course-provided `python3 tools/score_risks.py` script from the Session 02 Day 1 folder.
4. Replace the draft ranking with the actual script output if it differs.
5. Record the script result and correct any errors before submission.
