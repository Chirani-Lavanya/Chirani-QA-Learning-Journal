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

# Functional Test Conditions

| Test Condition ID | Requirement Reference | Test Condition | Type | Polarity 
|---|---|---|---|---|
| TC-01 | FR-1 | Search tutors by subject. | Functional | Positive | 
| TC-02 | FR-1 | Filter tutors by grade level. | Functional | Positive | 
| TC-03 | FR-1 | Filter tutors by Sinhala, Tamil, or English. | Functional | Positive | 
| TC-04 | FR-1 | Filter tutors by price band. | Functional | Positive | 
| TC-05 | FR-1 | Display appropriate results when no tutors match filters. | Functional | Negative | 
| TC-06 | FR-1 | Combine subject, grade, language, and price filters. | Functional | Boundary | 
| TC-07 | FR-2 | Book an available one-hour session and pay by card. | Functional | Positive | 
| TC-08 | FR-2 | Book an available one-hour session and pay by eZ Cash. | Functional | Positive |
| TC-09 | FR-2 | Confirm booking after successful payment. | Functional | Positive | 
| TC-10 | FR-2 | Prevent a booked time slot from being booked again. | Functional | Negative | 
| TC-11 | FR-2 | Handle failed card or eZ Cash payments. | Functional | Negative | 
| TC-12 | FR-2 | Prevent two students booking the same slot simultaneously. | Functional | Negative | 
| TC-13 | FR-3 | Allow tutors to publish and update availability. | Functional | Positive | 
| TC-14 | FR-3 | Allow tutors to accept bookings. | Functional | Positive | 
| TC-15 | FR-3 | Allow tutors to decline bookings. | Functional | Positive | 
| TC-16 | FR-3 | Test tutor cancellation with more than 12 hours remaining. | Functional | Boundary | 
| TC-17 | FR-3 | Test tutor cancellation with fewer than 12 hours remaining. | Functional | Negative | 
| TC-18 | FR-3 | Test cancellation exactly 12 hours before a session. | Functional | Boundary | 
| TC-19 | FR-4 | Calculate 15% commission on completed sessions. | Functional | Positive | 
| TC-20 | FR-4 | Calculate the tutor's amount after commission. | Functional | Positive | 
| TC-21 | FR-4 | Process weekly tutor payouts by bank transfer. | Functional | Positive | 
| TC-22 | FR-4 | Check payout treatment for cancelled or incomplete sessions. | Functional | Boundary | 
| TC-23 | FR-5 | Allow students to rate tutors from 1–5 stars after a completed session. | Functional | Positive | 
| TC-24 | FR-5 | Allow tutors to rate students from 1–5 stars after a completed session. | Functional | Positive | 
| TC-25 | FR-5 | Validate rating comments against the permitted length. | Functional | Boundary | 
| TC-26 | FR-5 | Prevent ratings before a session is completed. | Functional | Negative | 
| TC-27 | FR-5 | Display ratings and comments on the correct profiles. | Functional | Positive | 
| TC-28 | FR-5 | Validate empty or overlong rating comments. | Functional | Negative | 
| TC-59 | FR-2, CON-4 | Ensure a payment retry after a network timeout does not charge twice. | Functional | Negative | 
| TC-60 | FR-2 | Handle payment success when booking confirmation fails. | Functional | Negative | 
| TC-61 | FR-3 | Prevent tutors who fail the agreed vetting process from being presented as vetted. | Functional | Negative | 
| TC-63 | FR-4 | Check commission and payout calculations for cancelled or refunded sessions. | Functional | Boundary |

# Non-Functional Test Conditions

| Test Condition ID | Requirement Reference | Test Condition | Type | Polarity |
|---|---|---|---|---|
| TC-29 | NFR-1 | Verify search response time is under 800 ms at p95 from a Sri Lankan ISP. | Non-functional | Positive | 
| TC-30 | NFR-1 | Measure search response time under normal and increased loads. | Non-functional | Boundary | 
| TC-31 | NFR-2 | Verify 99.5% monthly uptime at the booking endpoint. | Non-functional | Positive | 
| TC-32 | NFR-2 | Check booking requests during service interruptions and recovery. | Non-functional | Negative | 
| TC-33 | NFR-3 | Verify support for 200 simultaneous video sessions. | Non-functional | Positive | 
| TC-34 | NFR-3 | Check behaviour when concurrent video sessions exceed 200. | Non-functional | Boundary | 
| TC-35 | NFR-4 | Verify required consent is captured for personal-data processing. | Non-functional | Positive | 
| TC-36 | NFR-4 | Verify users can submit personal-data deletion requests. | Non-functional | Positive | 
| TC-37 | NFR-4 | Check personal-data handling against applicable Sri Lankan PDPA requirements. | Non-functional | Positive | 
| TC-38 | NFR-5 | Verify payment-card data is not stored on LearnLanka servers. | Non-functional | Negative | 
| TC-39 | NFR-5 | Verify use of the configured PCI-DSS-compliant payment gateway. | Non-functional | Positive | 
| TC-51 | NFR-1 | Check search performance when p95 response time reaches or exceeds 800 ms. | Non-functional | Boundary | 
| TC-52 | NFR-2 | Check how booking endpoint downtime affects monthly uptime. | Non-functional | Negative | 
| TC-53 | NFR-4 | Handle deletion requests with incomplete identity verification. | Non-functional | Negative | 
| TC-54 | NFR-5 | Verify card data is not stored after a failed payment. | Non-functional | Negative | 
| TC-62 | NFR-4 | Prevent unauthorised users from accessing personal information. | Non-functional | Negative | 

# Test Conditions – Constraints

| Test Condition ID | Requirement Reference | Test Condition | Type | Polarity |
|---|---|---|---|---|
| TC-40 | CON-1 | Test main user journeys on mobile devices, especially Android. | Constraint | Positive | 
| TC-41 | CON-1 | Check usability across supported mobile screen sizes. | Constraint | Positive | 
| TC-42 | CON-2 | Verify compatibility with the confirmed hosting platform. | Constraint | Positive | Azure is preferred, not confirmed mandatory. |
| TC-43 | CON-3 | Verify users can join and conduct a session using the selected video provider. | Constraint | Positive | Daily.co or 100ms. |
| TC-44 | CON-3 | Check video sessions when the provider or connection fails. | Constraint | Negative | 
| TC-45 | CON-4 | Verify card payment integration with PayHere. | Constraint | Positive | 
| TC-46 | CON-4 | Verify tutor payouts using the Sampath Vishwa process. | Constraint | Positive | 
| TC-47 | CON-5 | Verify search-screen strings display in Sinhala. | Constraint | Positive | 
| TC-48 | CON-5 | Verify search-screen strings display in Tamil. | Constraint | Positive | 
| TC-49 | CON-5 | Verify search-screen strings display in English. | Constraint | Positive | 
| TC-50 | CON-5 | Check Sinhala and Tamil text for missing characters or layout issues. | Constraint | Negative | 
| TC-55 | CON-1 | Check essential controls on a small supported Android screen. | Constraint | Boundary | 
| TC-56 | CON-2 | Verify deployment against the client's decision if Azure is not selected. | Constraint | Boundary | 
| TC-57 | CON-4 | Check system behaviour when PayHere is unavailable. | Constraint | Negative | 
| TC-58 | CON-5 | Detect missing Sinhala, Tamil, or English translations. | Constraint | Negative | 

## 5. Clarifications Required

1. What is the final cancellation and refund policy? The founder statements conflict.
2. Does exactly 12 hours satisfy the tutor-cancellation rule?
3. How are cancelled, refunded, or incomplete sessions handled in payouts?
4. What checks are required to verify tutors?
5. How should eZ Cash work alongside the specified PayHere gateway?
6. What is the permitted rating-comment length?
7. Is Azure mandatory or only preferred, and which video provider will be selected?
8. What are the data-deletion timelines and access permissions?

## 6. Coverage Summary

Test conditions: 63 unique IDs.

Functional requirements: FR-1 to FR-5.

Non-functional requirements: NFR-1 to NFR-5.

Constraints: CON-1 to CON-5.

Negative and boundary conditions: Included across the requirements.

The actual coverage totals and risk links must be confirmed by running the challenge-provided scripts.

## 7. Reflection

This exercise helped me distinguish requirements from testable conditions. Positive conditions verify expected behaviour, while negative and boundary conditions cover failures, limits, and competing actions. Unclear requirements have been recorded for clarification before detailed test cases are created.

## 8. Validation

Run these commands from the challenge project folder:

python3 tools/check_coverage.py
python3 tools/score_risks.py

