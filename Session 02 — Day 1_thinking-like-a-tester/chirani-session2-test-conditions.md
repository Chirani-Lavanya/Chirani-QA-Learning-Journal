# Session 02 — Day 1: Test Conditions List

**Project:** LearnLanka Tutoring Marketplace  
**Deliverable:** Test Conditions List  
**Author:** Chirani Lavanya 

---

## 1. Purpose

This document lists the test conditions for the LearnLanka Tutoring Marketplace.

A test condition describes something that needs to be tested without providing detailed, step-by-step test-case instructions.

The test conditions cover:

- Functional Requirements (FR)
- Non-Functional Requirements (NFR)
- Constraints (CON)
- Positive testing
- Negative testing
- Boundary and combination testing

## 2. Test Conditions

### 2.1 Functional Requirements

| Test Condition ID | Requirement | Test Condition | Type |
|---|---|---|---|
| TC-01 | FR-1 | Verify that students can search for tutors by subject. | Positive |
| TC-02 | FR-1 | Verify that students can filter tutors by grade level. | Positive |
| TC-03 | FR-1 | Verify that students can filter tutors by Sinhala, Tamil, and English. | Positive |
| TC-04 | FR-1 | Verify that students can filter tutors by price band. | Positive |
| TC-05 | FR-1 | Verify search results when no tutors match the selected filters. | Negative |
| TC-06 | FR-1 | Verify search results when several filters are selected together. | Boundary/Combination |
| TC-07 | FR-2 | Verify that a student can book an available one-hour session and pay by card. | Positive |
| TC-08 | FR-2 | Verify that a student can book an available one-hour session and pay using eZ Cash. | Positive |
| TC-09 | FR-2 | Verify that successful payment changes the booking status to Confirmed. | Positive |
| TC-10 | FR-2 | Verify that a successfully booked time slot is no longer available to other students. | Positive |
| TC-11 | FR-2 | Verify the system response when card or eZ Cash payment fails. | Negative |
| TC-12 | FR-2 | Verify that two students cannot successfully book the same slot at the same time. | Negative/Concurrency |
| TC-13 | FR-3 | Verify that a tutor can publish and update their availability. | Positive |
| TC-14 | FR-3 | Verify that a tutor can accept a booking. | Positive |
| TC-15 | FR-3 | Verify that a tutor can decline a booking. | Positive |
| TC-16 | FR-3 | Verify that a tutor can cancel a confirmed booking when more than 12 hours remain before the session. | Boundary |
| TC-17 | FR-3 | Verify that a tutor cannot cancel a confirmed booking when fewer than 12 hours remain. | Boundary/Negative |
| TC-18 | FR-3 | Verify cancellation behaviour when exactly 12 hours remain before the session. | Boundary |
| TC-19 | FR-4 | Verify that the platform calculates a 15% commission on a completed session. | Positive |
| TC-20 | FR-4 | Verify that the tutor's amount after commission is calculated correctly. | Positive |
| TC-21 | FR-4 | Verify that tutor payouts are processed weekly by bank transfer. | Positive |
| TC-22 | FR-4 | Verify payout calculations for sessions that are cancelled or not completed. | Negative/Clarification Needed |
| TC-23 | FR-5 | Verify that a student can rate a tutor after a completed session using 1–5 stars. | Positive |
| TC-24 | FR-5 | Verify that a tutor can rate a student after a completed session using 1–5 stars. | Positive |
| TC-25 | FR-5 | Verify that a rating comment can be submitted within the permitted comment-length limit. | Boundary |
| TC-26 | FR-5 | Verify that ratings cannot be submitted for sessions that have not been completed. | Negative |
| TC-27 | FR-5 | Verify that ratings and comments appear on the appropriate profile. | Positive |
| TC-28 | FR-5 | Verify the system response to an empty comment or a comment exceeding the permitted limit. | Negative/Boundary |

### 2.2 Non-Functional Requirements

| Test Condition ID | Requirement | Test Condition | Type |
|---|---|---|---|
| TC-29 | NFR-1 | Verify that search results meet the response-time target of under 800 ms at the 95th percentile when tested from a Sri Lankan ISP. | Performance |
| TC-30 | NFR-1 | Verify search response times under expected and increased search loads. | Performance |
| TC-31 | NFR-2 | Verify that the booking endpoint meets the monthly uptime target of 99.5%. | Reliability |
| TC-32 | NFR-2 | Verify that booking requests are handled correctly during service interruptions and recovery. | Reliability |
| TC-33 | NFR-3 | Verify that the video-session service supports 200 simultaneous sessions within the first six months. | Load/Capacity |
| TC-34 | NFR-3 | Verify video-session behaviour when concurrent usage exceeds the target capacity of 200 sessions. | Boundary/Capacity |
| TC-35 | NFR-4 | Verify that required consent is captured and recorded for relevant personal-data processing. | Privacy/Compliance |
| TC-36 | NFR-4 | Verify that a user can submit a personal-data deletion request and that the request follows the defined process. | Privacy/Compliance |
| TC-37 | NFR-4 | Verify that personal data is handled according to applicable Sri Lankan PDPA requirements. | Privacy/Compliance |
| TC-38 | NFR-5 | Verify that payment card data is processed through the payment gateway and is not stored on LearnLanka servers. | Security/Compliance |
| TC-39 | NFR-5 | Verify that payment processing uses the configured PCI-DSS-compliant gateway. | Security/Compliance |
| TC-51 | NFR-1 | Verify whether the search response-time target is met when the 95th-percentile response time reaches or exceeds 800 ms. | Boundary/Negative |
| TC-52 | NFR-2 | Verify the effect on monthly uptime when the booking endpoint experiences downtime. | Negative |
| TC-53 | NFR-4 | Verify that a deletion request is handled appropriately when required identity verification is incomplete. | Negative |
| TC-54 | NFR-5 | Verify that sensitive payment-card data is not stored on LearnLanka servers after a failed payment. | Negative |

### 2.3 Constraints

| Test Condition ID | Requirement | Test Condition | Type |
|---|---|---|---|
| TC-40 | CON-1 | Verify that the main user journeys work on mobile devices, with particular attention to Android devices. | Compatibility |
| TC-41 | CON-1 | Verify that pages and controls remain usable on different supported mobile screen sizes. | Compatibility/Usability |
| TC-42 | CON-2 | Verify that the deployed solution is compatible with the selected Azure hosting approach once the architecture is confirmed. | Environment/Compatibility |
| TC-43 | CON-3 | Verify that the configured third-party video provider supports joining and conducting a tutoring session. | Integration |
| TC-44 | CON-3 | Verify the video-session experience when the selected provider is unavailable or a connection fails. | Negative/Recovery |
| TC-45 | CON-4 | Verify that card payments are integrated with the configured PayHere gateway. | Integration |
| TC-46 | CON-4 | Verify that tutor payouts are compatible with the configured Sampath Vishwa bank-transfer process. | Integration |
| TC-47 | CON-5 | Verify that all UI strings on the search screen are displayed in Sinhala when Sinhala is selected. | Localization |
| TC-48 | CON-5 | Verify that all UI strings on the search screen are displayed in Tamil when Tamil is selected. | Localization |
| TC-49 | CON-5 | Verify that all UI strings on the search screen are displayed in English when English is selected. | Localization |
| TC-50 | CON-5 | Verify that Sinhala and Tamil text displays correctly without missing characters, clipping, or layout problems. | Localization/Usability |
| TC-55 | CON-1 | Verify that essential search and booking controls remain usable on a small supported Android screen. | Boundary |
| TC-56 | CON-2 | Verify the deployment approach against the client's confirmed hosting decision if Azure is not selected. | Negative/Compatibility |
| TC-57 | CON-4 | Verify the system's response when the configured PayHere payment service is unavailable. | Negative/Integration |
| TC-58 | CON-5 | Verify that missing Sinhala, Tamil, or English translations are detected on relevant UI screens. | Negative/Localization |

## 3. Negative and Boundary Conditions

The following conditions specifically examine invalid inputs, failures, limits, or competing actions.

| Test Condition ID | Requirement | Negative or Boundary Scenario |
|---|---|---|
| TC-05 | FR-1 | No tutors match the selected search filters. |
| TC-11 | FR-2 | Card or eZ Cash payment fails. |
| TC-12 | FR-2 | Two students attempt to book the same slot simultaneously. |
| TC-17 | FR-3 | A tutor attempts to cancel a booking less than 12 hours before the session. |
| TC-18 | FR-3 | A tutor attempts to cancel exactly 12 hours before the session. |
| TC-22 | FR-4 | A session is cancelled or not completed, and the payout calculation needs to be checked against an agreed business rule. |
| TC-26 | FR-5 | A rating is attempted before the session is completed. |
| TC-28 | FR-5 | A comment is empty or exceeds the allowed length. |
| TC-34 | NFR-3 | More than 200 concurrent video sessions are attempted. |
| TC-44 | CON-3 | The video provider is unavailable or the connection fails. |
| TC-51 | NFR-1 | Search response time reaches or exceeds the 800 ms p95 target. |
| TC-52 | NFR-2 | The booking endpoint experiences downtime affecting monthly uptime. |
| TC-53 | NFR-4 | A deletion request is submitted with incomplete identity verification. |
| TC-54 | NFR-5 | Check that payment-card data is not stored after a failed payment. |
| TC-55 | CON-1 | Essential controls are tested on a small supported Android screen. |
| TC-56 | CON-2 | The deployment approach is checked if Azure is not selected. |
| TC-57 | CON-4 | The PayHere payment service is unavailable. |
| TC-58 | CON-5 | A required Sinhala, Tamil, or English translation is missing. |

## 4. Requirement Coverage Summary

Requirement Group |	Requirements |	Coverage Status |
|---|---|---|
Functional	| FR-1 to FR-5	| All requirements have test conditions and at least one negative/boundary condition |
Non-Functional | NFR-1 to NFR-5	| All requirements have test conditions and at least one negative/boundary condition |
Constraints | CON-1 to CON-5 | All requirements have test conditions and at least one negative/boundary condition |
Total | 15 requirements and constraints |	15/15 requirements have test conditions and at least one negative/boundary condition |

### Coverage Checker Results

Metric | Latest Result |
|---|---|
Total test conditions |	58 |
Negative/boundary conditions | 21 |
Requirements with test conditions | 15/15 |
Requirements with at least one negative/boundary condition | 15/15 |

### Coverage Validation Summary

Total test conditions: 58, meeting the target of 25 or more.

Negative/boundary conditions: 21, meeting the target of 8 or more.

Requirement coverage: All 15 requirements (FR-1 to FR-5, NFR-1 to NFR-5 and CON-1 to CON-5) have associated test conditions.

Negative/boundary coverage: The checker confirms that every listed requirement has at least one negative/boundary condition.

## 5. Clarifications Needed

ID | Clarification Needed | Reason | 
|---|---|---|
CL-01 | What should happen when a user enters invalid or incomplete information? | To clarify input validation rules and expected error messages |
CL-02 | What are the minimum and maximum permitted values for relevant input fields? | To define boundary values and expected behavior outside permitted limits |
CL-03 | What should happen when two users attempt the same action simultaneously? | To clarify concurrent-use behavior and help prevent inconsistent data |
CL-04 | What should the system do when a request fails because of a network or server error? | To define error handling, retry behavior and user feedback |
CL-05 | What response-time limits are expected under normal and high-load conditions? | To establish measurable performance acceptance criteria |
CL-06 | What access permissions should apply to each user role? | To clarify authorization rules and prevent unauthorized access |
CL-07 | What should happen when a user submits the same request more than once? | To clarify duplicate-submission handling and prevent unintended duplicate records or transactions |
CL-08 | What should happen to relate data when a user cancels an action? | To clarify cancellation behavior and maintain data consistency |

## 6. Clarification Approach

1. Identify requirements that are ambiguous, incomplete or not measurable.
2. Record a specific question for each requirement that needs clarification.
3. Discuss the questions with the product owner or relevant stakeholder.
4. Document the agreed behaviour and acceptance criteria.
5. Update the affected test conditions and coverage information after clarification

| Requirement | Area | Question Requiring Clarification |
|---|---|---|
| FR-3 | Cancellation | Does the 12-hour cancellation rule include exactly 12 hours before the session? |
| FR-4 | Commission | Is the 15% commission calculated on the full session price before or after discounts, fees, or taxes? |
| FR-4 | Payouts | How are cancelled, refunded, disputed, or incomplete sessions handled in weekly payouts? |
| FR-5 | Ratings | What comment-length limit applies, and how should inappropriate comments be identified or handled? |
| NFR-1 | Performance | What test environment, search dataset size, and load profile should be used? |
| NFR-2 | Uptime | How is monthly uptime measured, and what exclusions, if any, apply? |
| NFR-3 | Capacity | What acceptable video quality and error rate are required at 200 simultaneous sessions? |
| NFR-4 | Privacy | What consent records must be stored, and what are the expected deletion-request timelines and exceptions? |
| NFR-5 | Payments | Which payment data, if any, may be retained as tokens or transaction references? |
| CON-2 | Hosting | Is Azure a mandatory deployment requirement or only the preferred hosting platform? |
| CON-3 | Video Provider | Will the product use Daily.co or 100ms at launch? |
| CON-5 | Localization | Must every page, error message, notification, and validation message be translated into all three languages? |

## 7. Reflection

Writing these test conditions helped me distinguish between a requirement and something that can be tested. I included positive conditions to verify expected behaviour and negative or boundary conditions to examine failures and limits.

I also identified areas where the requirements do not provide enough detail to decide a clear pass or fail. These need clarification before detailed test cases can be finalised.

The next step is to compare this list with the LearnLanka requirements and run the course-provided coverage-checking script. Any corrections required by the script or the course instructions should be made before submission.

