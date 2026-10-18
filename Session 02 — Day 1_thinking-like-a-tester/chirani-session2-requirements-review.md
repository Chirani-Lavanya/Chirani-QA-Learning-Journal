# Session 02 — Day 1: Requirements Review Log

**Challenge:** LearnLanka Tutoring Marketplace — Requirements Review and Risk Map

## 1. Challenge Brief

LearnLanka helps O/L and A/L students across Sri Lanka find vetted tutors and book one-to-one online sessions in Sinhala, Tamil or English. Students search, book a 1-hour slot and pay by card or eZ Cash. Tutors set their own availability, accept or decline bookings, and can cancel with at least 12 hours notice. We keep 15% of every completed session and pay tutors weekly. After each session both sides rate each other. It has to be fast, safe for children, and work on any phone.

### Additional Statements from the Founders

- “tutors should be able to cancel any time, they are doing us a favour”
- “students must get a full refund for any cancellation”
- “we only refund if the tutor cancels”

## 2. Requirements Findings

Review the brief and record at least 10 findings. Classify each finding as Ambiguous, Untestable, Missing, or Conflicting.

| # | Requirement or statement | Finding type | Why it is a problem for testing | Clarification question | Priority |
|---|---|---|---|---|---|
| 1 | Tutor cancellation with at least 12 hours notice versus tutors cancelling any time | Conflicting | The cancellation rule is inconsistent. | Can tutors cancel less than 12 hours before a session? | High |
| 2 | Full refund for any cancellation versus refund only when tutor cancels | Conflicting | Expected refund outcomes are unclear. | Which cancellation cases qualify for a refund? | High |
| 3 | “Safe for children” | Untestable | No measurable safety criteria are given. | Which child-safety controls are required? | High |
| 4 | “Vetted tutors” | Ambiguous | Vetting checks are not specified. | What checks must a tutor pass before listing? | High |
| 5 | “Fast” | Untestable | No response-time target is stated in the brief. | What performance target defines fast? | Medium |
| 6 | “Work on any phone” | Untestable | Supported devices and browsers are undefined. | Which devices and browser versions are supported? | Medium |
| 7 | Both sides rate each other | Missing | Rating and comment validation details are incomplete. | What rating scale and comment rules apply? | Medium |
| 8 | Tutors are paid weekly | Ambiguous | Payout day and failed-transfer handling are unspecified. | When are payouts processed and what happens if one fails? | High |
| 9 | 15% commission per completed session | Ambiguous | Rounding and fee calculation rules are unclear. | What amount is used to calculate the commission? | High |
| 10 | Pay by card or eZ Cash | Missing | Payment failure and retry behavior are unspecified. | What happens after a failed or timed-out payment? | High |

## 3. Assumptions and Silent Gaps

Add at least six assumptions that need confirmation.

| # | Assumption or gap | Why it matters | Question to confirm |
|---|---|---|---|
| 1 | A booking is confirmed only after successful payment. | Prevents unpaid bookings blocking slots. | Is successful payment required for confirmation? |
| 2 | A tutor slot cannot be booked by two students. | Prevents double booking. | How are simultaneous booking attempts handled? |
| 3 | Students can cancel bookings. | Affects refunds and availability. | Can students cancel, and what rules apply? |
| 4 | Tutors must pass vetting before appearing in search. | Supports student safety. | What vetting process is required? |
| 5 | Ratings are allowed only after completed sessions. | Prevents ratings for sessions that did not occur. | Which session status permits rating? |
| 6 | Personal-data deletion requests have a defined process. | Makes privacy behavior testable. | What is the required deletion process and completion time? |

## 4. Top Three Questions for the Founders

1. What are the authoritative cancellation and refund rules?
2. What tutor vetting and child-safety controls are mandatory?
3. What are the exact payment failure, commission, and payout rules?

## 5. Reflection

**Most common finding type:** Complete after reviewing and counting your findings.

**What this tells me:** Explain what the findings suggest about the clarity of the LearnLanka requirements.

## 6. AI Check

Complete this section only after finishing and reviewing your own findings.

- What AI found that I missed: Complete after comparison.
- What AI got wrong: Record a verified example, or state that none was found after checking.
- What AI invented or assumed: Record a verified example, or state that none was found after checking.
