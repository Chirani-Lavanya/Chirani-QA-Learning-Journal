LearnLanka — Requirements Review Log

Session: Session 2, Day 1 — Thinking Like a Tester
Project: LearnLanka Tutoring Marketplace
Deliverable: 1 — Requirements Review Log

## 1. Purpose

The purpose of this review is to identify ambiguous, untestable, missing, and conflicting requirements before software development begins. These findings will help the development team clarify expected behaviour and allow QA engineers to create reliable test conditions.

## 2. Challenge Brief

LearnLanka helps O/L and A/L students across Sri Lanka find vetted tutors and book one-to-one online sessions in Sinhala, Tamil or English. Students search, book a 1-hour slot and pay by card or eZ Cash. Tutors set their own availability, accept or decline bookings, and can cancel with at least 12 hours notice. We keep 15% of every completed session and pay tutors weekly. After each session both sides rate each other. It has to be fast, safe for children, and work on any phone.

## 2. Requirements Review Findings

+-----+-------+--------------+----------------------------------+----------------------------------+----------------------------------+----------+
| #   | ID    | Finding Type | Requirement / Phrase              | Why It Matters for Testing       | Clarification Question           | Priority |
+-----+-------+--------------+----------------------------------+----------------------------------+----------------------------------+----------+
| 1   | F-01  | Ambiguous    | Cancel with at least 12 hours    | The time reference is unclear.   | Is the 12-hour window measured    | High     |
|     |       |              | notice                           | Different interpretations could  | from the scheduled session start |          |
|     |       |              |                                  | cause inconsistent decisions.   | time, and which timestamp        |          |
|     |       |              |                                  |                                  | determines eligibility?          |          |
+-----+-------+--------------+----------------------------------+----------------------------------+----------------------------------+----------+
| 2   | F-02  | Conflicting  | 12-hour cancellation rule versus | Both rules cannot be applied     | Which cancellation rule is       | High     |
|     |       |              | the founder's statement that     | consistently without an agreed  | authoritative, and are there     |          |
|     |       |              | bookings can be cancelled        | precedence rule.                 | separate rules for students     |          |
|     |       |              | at any time                      |                                  | and tutors?                      |          |
+-----+-------+--------------+----------------------------------+----------------------------------+----------------------------------+----------+
| 3   | F-03  | Conflicting  | Full refund for any cancellation | These statements produce        | Which cancellation reasons      | High     |
|     |       |              | versus refund only if tutor      | different refund outcomes.      | qualify for full, partial,      |          |
|     |       |              | cancels                          |                                  | or no refunds?                  |          |
+-----+-------+--------------+----------------------------------+----------------------------------+----------------------------------+----------+
| 4   | F-04  | Untestable   | Vetted tutors                    | The verification process and    | What checks must a tutor pass   | High     |
|     |       |              |                                  | completion status are undefined.| before being marked as vetted?  |          |
+-----+-------+--------------+----------------------------------+----------------------------------+----------------------------------+----------+
| 5   | F-05  | Untestable   | Fast                             | This phrase alone does not      | What response-time threshold    | Medium   |
|     |       |              |                                  | define a measurable target.     | and percentile should apply?    |          |
+-----+-------+--------------+----------------------------------+----------------------------------+----------------------------------+----------+
| 6   | F-06  | Untestable   | Safe for children                | Safety controls and expected    | What child-safety, privacy,     | High     |
|     |       |              |                                  | behaviour are not specified.    | reporting, and access controls  |          |
|     |       |              |                                  |                                  | are required?                   |          |
+-----+-------+--------------+----------------------------------+----------------------------------+----------------------------------+----------+
| 7   | F-07  | Untestable   | Work on any phone                | Supported devices, operating    | Which devices, operating        | Medium   |
|     |       |              |                                  | systems, and browsers are       | systems, browsers, and screen   |          |
|     |       |              |                                  | unspecified.                    | sizes must be supported?        |          |
+-----+-------+--------------+----------------------------------+----------------------------------+----------------------------------+----------+
| 8   | F-08  | Missing      | Payment failure during booking  | Expected behaviour after a      | Should the booking remain       | High     |
|     |       |              |                                  | failed payment is unclear.      | pending, be cancelled, or allow |          |
|     |       |              |                                  |                                  | a retry?                        |          |
+-----+-------+--------------+----------------------------------+----------------------------------+----------------------------------+----------+
| 9   | F-09  | Missing      | Network interruption or payment | Retrying a payment could cause  | How should repeated payment     | High     |
|     |       |              | retry                            | duplicate charges.              | requests be handled to prevent |          |
|     |       |              |                                  |                                  | duplicate charges?              |          |
+-----+-------+--------------+----------------------------------+----------------------------------+----------------------------------+----------+
| 10  | F-10  | Untestable   | Tutor payout and commission     | Payout amounts cannot be        | What commission rate applies,   | High     |
|     |       |              | rules                            | verified without calculation   | how is it calculated, and when |          |
|     |       |              |                                  | rules and timing.               | is payout processed?            |          |
+-----+-------+--------------+----------------------------------+----------------------------------+----------------------------------+----------+
| 11  | F-11  | Ambiguous    | Completed session                | Different interpretations      | What exact event changes the   | High     |
|     |       |              |                                  | could affect payments, refunds, | session status to completed?   |          |
|     |       |              |                                  | and ratings.                    |                                  |          |
+-----+-------+--------------+----------------------------------+----------------------------------+----------------------------------+----------+
| 12  | F-12  | Missing      | Rating submission and session   | Ineligible users might submit   | Who can submit a rating, when  | Medium   |
|     |       |              | association                      | ratings or rate the wrong       | is it enabled, and how is it   |          |
|     |       |              |                                  | session.                        | linked to the correct session? |          |
+-----+-------+--------------+----------------------------------+----------------------------------+----------------------------------+----------+
| 13  | F-13  | Ambiguous    | Tutoring languages and UI       | Language filters and interface  | Are tutoring language filters  | Medium   |
|     |       |              | languages                        | language may be confused.      | independent of UI language?    |          |
+-----+-------+--------------+----------------------------------+----------------------------------+----------------------------------+----------+
| 14  | F-14  | Missing      | No tutors match search criteria| The empty-result behaviour and  | What message and actions       | Medium   |
|     |       |              |                                  | next actions are undefined.     | should appear when no tutors   |          |
|     |       |              |                                  |                                  | match the search?              |          |
+-----+-------+--------------+----------------------------------+----------------------------------+----------------------------------+----------+
| 15  | F-15  | Missing      | Payment succeeds but booking    | A user could be charged without| How should the system recover  | High     |
|     |       |              | confirmation fails              | receiving a confirmed booking.  | the booking or refund payment? |          |
+-----+-------+--------------+----------------------------------+----------------------------------+----------------------------------+----------+

### Additional formal requirements to review

Review the complete FR-1 to FR-5, NFR-1 to NFR-5, and CON-1 to CON-5 lists from the challenge. Add further findings if you identify other issues. Do not assume the introductory brief covers every formal requirement.

## 3. Assumptions and Silent Gaps

These are assumptions to confirm, not approved requirements.

| # | Assumption or gap | Why it matters | Question to confirm |
|---|---|---|---|
| 1 | A booking is confirmed only after successful payment. | Prevents unpaid bookings from being treated as confirmed. | Is successful payment required before confirmation? |
| 2 | A tutor slot cannot be confirmed for two students. | Prevents double booking. | How are simultaneous booking attempts handled? |
| 3 | Students may cancel their bookings. | Affects refunds, booking status, and slot availability. | Can students cancel, and what deadlines and refund rules apply? |
| 4 | Tutors must pass the required vetting before appearing in search. | Supports the stated child-safety goal. | What checks and approval status are mandatory? |
| 5 | Only eligible completed sessions can be rated. | Prevents ratings for sessions that did not occur. | Which session statuses permit a rating? |
| 6 | Personal-data deletion requests have a defined workflow. | Supports testing of the privacy requirement. | What is the required workflow and completion target for deletion requests? |
| 7 | Payment card data is handled by the payment gateway rather than stored on LearnLanka servers. | Supports the payment-data constraint. | Which payment data may LearnLanka retain, and how will this be verified? |
| 8 | Language selection applies consistently across all required user-interface strings. | Helps ensure all launch languages are supported. | Which screens, messages, validation errors, and other strings must be translated at launch? |

## 4. Top Three Questions for the Founders

1. **Cancellation and refunds:** Which cancellation and refund rules are authoritative for students and tutors, including cancellations less than or exactly 12 hours before a session?
2. **Child safety and tutor vetting:** Which vetting checks and child-safety controls are mandatory before launch, and what evidence will demonstrate that they work?
3. **Payments and payouts:** What are the exact payment-failure, commission-calculation, refund-processing, and weekly-payout rules?

## 5. Reflection

**Most common finding type:** Conflicting requirements and missing details are both prominent in my initial review. I will confirm the final most common type by counting all findings after reviewing the formal requirements.

**What this tells me:** The LearnLanka brief communicates the general product idea, but several rules are not sufficiently precise for consistent testing. Conflicting cancellation and refund statements could lead to different expected outcomes, while vague terms such as “safe” and “fast” need measurable criteria. Clarifying these points before test execution would help the team agree on expected behavior.

## 6. AI Check

- **What AI found that I missed:**  — record a specific finding you verified against the brief.
- **What AI got wrong:** — record a verified error, or state that none was found after checking.
- **What AI invented or assumed:**  — identify an unsupported claim, or state that none was found after checking.

