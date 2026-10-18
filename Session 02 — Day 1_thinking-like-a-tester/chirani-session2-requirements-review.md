# Session 02 — Day 1: Requirements Review Log

**Challenge:** LearnLanka Tutoring Marketplace — Requirements Review and Risk Map

## 1. Challenge Brief

LearnLanka helps O/L and A/L students across Sri Lanka find **vetted tutors** and book one-to-one online sessions in Sinhala, Tamil or English. Students search, book a **1-hour slot** and pay by card or eZ Cash. Tutors set their own availability, accept or decline bookings, and **can cancel with at least 12 hours notice**. We keep **15% of every completed session** and **pay tutors weekly**. After each session both sides rate each other. It has to be **fast**, **safe for children**, and **work on any phone**.

### Additional Statements from the Founders

- “**tutors should be able to cancel any time**, they are doing us a favour”
- “**students must get a full refund for any cancellation**”
- “**we only refund if the tutor cancels**”

## 2. Requirements Findings

| # | Exact quote / requirement | Finding type | Why it is a problem for testing | Clarification question | Priority |
|---|---|---|---|---|---|
| 1 | “can cancel with at least 12 hours notice” versus “tutors should be able to cancel any time” | Conflicting | Different rules produce different expected results for cancellations close to the session. | Are tutors allowed to cancel less than 12 hours before a session? | High |
| 2 | “students must get a full refund for any cancellation” versus “we only refund if the tutor cancels” | Conflicting | The refund outcome for student cancellations is contradictory. | Which cancellation scenarios qualify for a full refund? | High |
| 3 | “safe for children” | Untestable | No measurable child-safety acceptance criteria are given. | Which child-safety controls must be implemented and verified before launch? | High |
| 4 | “vetted tutors” | Ambiguous | The vetting process and approval criteria are not defined. | What checks must a tutor pass before becoming searchable? | High |
| 5 | “fast” | Untestable | The introductory brief does not define a measurable speed target, although NFR-1 specifies a search target. | Which response-time target and measurement conditions define acceptable performance for each key journey? | Medium |
| 6 | “work on any phone” | Untestable | Supported devices, operating systems, browsers, and minimum versions are not defined. | Which phone models or capability levels, operating systems, and browsers are in scope? | Medium |
| 7 | “After each session both sides rate each other” | Missing | The brief does not fully define rating eligibility, comment validation, or handling of inappropriate comments. | Can users rate only completed sessions, and what comment validation and moderation rules apply? | Medium |
| 8 | “pay tutors weekly” | Ambiguous | The payout day, cutoff, failed-transfer behavior, and holiday handling are not specified. | What is the payout schedule, and how are failed transfers and bank holidays handled? | High |
| 9 | “15% of every completed session” | Ambiguous | The fee basis, rounding method, and treatment of discounts or refunds are unspecified. | How should commission be calculated and rounded, and how are discounts and refunds handled? | High |
| 10 | “pay by card or eZ Cash” | Missing | Payment failure, timeout, retry, and duplicate-submission behavior are not defined. | What should happen to the booking and payment after a failed, timed-out, or repeated payment attempt? | High |
| 11 | “book a 1-hour slot” | Missing | The brief does not specify how overlapping bookings or simultaneous attempts for the same slot are handled. | How should the system prevent two students from confirming the same tutor slot? | High |
| 12 | “find vetted tutors and book one-to-one online sessions” | Missing | The brief does not define what happens when no tutors match the search or a tutor becomes unavailable during booking. | What should students see when no tutors match, or when a selected slot becomes unavailable? | Medium |

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

Complete this section only after finishing your own review and comparing it with an AI review.

- **What AI found that I missed:** TODO — record a specific finding you verified against the brief.
- **What AI got wrong:** TODO — record a verified error, or state that none was found after checking.
- **What AI invented or assumed:** TODO — identify an unsupported claim, or state that none was found after checking.

