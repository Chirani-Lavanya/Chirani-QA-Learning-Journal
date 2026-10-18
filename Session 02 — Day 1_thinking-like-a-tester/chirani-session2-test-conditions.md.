# Session 02 — Day 1: Test Conditions List

**Project:** LearnLanka Tutoring Marketplace  
**Deliverable:** Test Conditions List  
**Author:** Chirani Lavanya  
**Status:** First Draft

## 1. Purpose

This document lists test conditions for the LearnLanka Tutoring Marketplace. A test condition describes something that needs to be tested. It does not provide the detailed step-by-step instructions of a test case.

The conditions below cover functional requirements (FR), non-functional requirements (NFR), and constraints (CON). Negative and boundary conditions are included where appropriate.

## 2. Test Conditions

### 2.1 Functional Requirements

| Test Condition ID | Requirement | Test Condition | Type |
|---|---|---|---|
| TC-01 | FR-1 | Verify that students can search for tutors by subject. | Positive |
| TC-02 | FR-1 | Verify that students can filter tutors by grade level. | Positive |
| TC-03 | FR-1 | Verify that students can filter tutors by Sinhala, Tamil, and English. | Positive |
| TC-04 | FR-1 | Verify that students can filter tutors by price band. | Positive |
| TC-05 | FR-1 | Verify the search results when no tutors match the selected filters. | Negative |
| TC-06 | FR-1 | Verify the search results when several filters are selected together. | Boundary/Combination |
| TC-07 | FR-2 | Verify that a student can book an available one-hour session and pay by card. | Positive |
| TC-08 | FR-2 | Verify that a student can book an available one-hour session and pay using eZ Cash. | Positive |
| TC-09 | FR-2 | Verify that a successful payment changes the booking status to Confirmed. | Positive |
| TC-10 | FR-2 | Verify that a successfully booked slot is no longer available to other students. | Positive |
| TC-11 | FR-2 | Verify the system response when card or eZ Cash payment fails. | Negative |
| TC-12 | FR-2 | Verify that two students cannot successfully book the same slot at the same time. | Negative/Concurrency |
| TC-13 | FR-3 | Verify that a tutor can publish and update their availability. | Positive |
| TC-14 | FR-3 | Verify that a tutor can accept a booking. | Positive |
| TC-15 | FR-3 | Verify that a tutor can decline a booking. | Positive |
| TC-16 | FR-3 | Verify that a tutor can cancel a confirmed booking when more than 12 hours remain. | Boundary |
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
| TC-37 | NFR-4 | Verify that personal data is handled according to the applicable Sri Lankan PDPA requirements. | Privacy/Compliance |
| TC-38 | NFR-5 | Verify that payment card data is processed through the payment gateway and is not stored on LearnLanka servers. | Security/Compliance |
| TC-39 | NFR-5 | Verify that payment processing uses the configured PCI-DSS-compliant gateway. | Security/Compliance |

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

## 3. Negative and Boundary Conditions

The following conditions specifically examine invalid inputs, failures, limits, or competing actions:

- **TC-05:** No tutors match the selected search filters.
- **TC-11:** Payment fails.
- **TC-12:** Two students attempt to book the same slot simultaneously.
- **TC-17:** A tutor attempts to cancel a booking less than 12 hours before the session.
- **TC-18:** A tutor attempts to cancel exactly 12 hours before the session.
- **TC-22:** A session is cancelled or not completed, and the payout calculation must be checked against an agreed business rule.
- **TC-26:** A rating is attempted before the session is completed.
- **TC-28:** A comment is empty or exceeds the allowed length.
- **TC-34:** More than 200 concurrent video sessions are attempted.
- **TC-44:** The video provider is unavailable or the connection fails.

## 4. Requirement Coverage Summary

| Requirement Group | Requirements Covered | Coverage Status |
|---|---|---|
| Functional | FR-1 to FR-5 | Covered in this draft |
| Non-functional | NFR-1 to NFR-5 | Covered in this draft |
| Constraints | CON-1 to CON-5 | Covered in this draft |
| Total | 15 requirements and constraints | 15/15 referenced |

**Important:** This is a manual coverage summary. The result from the course-provided coverage-checking script must be added after running the script.

## 5. Clarifications Needed

Some requirements need additional detail before definitive pass/fail criteria can be established:

1. **FR-3 — Cancellation:** Does the 12-hour cancellation rule include exactly 12 hours before the session?
2. **FR-4 — Commission:** Is the 15% commission calculated on the full session price before or after any discounts, fees, or taxes?
3. **FR-4 — Payouts:** How are cancelled, refunded, disputed, or incomplete sessions handled in weekly payouts?
4. **FR-5 — Ratings:** What comment-length limit applies, and how should inappropriate comments be identified or handled?
5. **NFR-1 — Performance:** What test environment, search dataset size, and load profile should be used?
6. **NFR-2 — Uptime:** How is monthly uptime measured, and what exclusions, if any, apply?
7. **NFR-3 — Capacity:** What acceptable video quality and error rate are required at 200 simultaneous sessions?
8. **NFR-4 — Privacy:** What consent records must be stored, and what are the expected deletion-request timelines and exceptions?
9. **NFR-5 — Payments:** Which payment data, if any, may be retained as tokens or transaction references?
10. **CON-2 — Azure:** Is Azure a mandatory deployment requirement or only the preferred hosting platform?
11. **CON-3 — Video provider:** Will the product use Daily.co or 100ms at launch?
12. **CON-5 — Localization:** Must every page, error message, notification, and validation message be translated into all three languages?

## 6. Reflection

Writing these test conditions helped me distinguish between a requirement and something that can be tested. I included positive conditions to verify expected behaviour and negative or boundary conditions to examine failures and limits.

I also identified areas where the requirements do not provide enough detail to decide a clear pass or fail. These need clarification before detailed test cases can be finalised.

The next step is to compare this list with the LearnLanka requirements and run the course-provided coverage-checking script. Any corrections required by the script or the course instructions should be made before submission.
