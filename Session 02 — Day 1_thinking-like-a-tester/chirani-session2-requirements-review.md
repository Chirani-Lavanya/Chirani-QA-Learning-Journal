## LearnLanka — Requirements Review Log

Session: Session 2, Day 1 — Thinking Like a Tester

Project: LearnLanka Tutoring Marketplace

## Deliverable: 1 — Requirements Review Log

## 1. Purpose

The purpose of this review is to identify ambiguous, untestable, missing, and conflicting requirements before software development begins. These findings will help the development team clarify expected behaviour and allow QA engineers to create reliable test conditions.

## 2. Challenge Brief

LearnLanka helps O/L and A/L students across Sri Lanka find vetted tutors and book one-to-one online sessions in Sinhala, Tamil or English. Students search, book a **1-hour slot** and pay by card or eZ Cash. Tutors set their own availability, accept or decline bookings, and can cancel with at least 12 hours notice. We keep **15% of every completed session** and pay tutors **weekly**. After each session, both students and tutors can rate each other. The platform must be fast, safe for children, and work on mobile devices.


## 3. Requirements Review Findings

| ID |	Finding type| Requirement or phrase under review |	Why it matters for testing	| Clarification question	| Priority |
|---|---|---|---|---|---|
| F-01 |	Ambiguous|	"Cancel with at least 12 hours notice" |	The time reference is unclear and may cause inconsistent cancellation decisions. | 	Is the 12-hour window measured from the scheduled session start time? | 	High | 
| F-02 |	Missing |	Rules for accepting or declining bookings. | The brief says tutors can accept or decline bookings but does not specify the booking status or what happens after a decline.  | What status should a declined booking have, and how should the student be notified? | 	High |
| F-03 |	Missing	| Cancellation outcome and refund handling | The brief defines a 12-hour cancellation notice for tutors but does not explain the cancellation and refund outcomes. |What happens to the booking and payment when a tutor cancels, and what cancellation rules apply to students? | High |
| F-04 | Untestable	| "Vetted tutors" |	The verification process and completion criteria are undefined | What checks must a tutor pass before being marked as vetted? |	High |
| F-05 |	Ambiguous  | "Fast" and NFR-1's search target of less than 800 ms at p95	| The brief includes a measurable search target, but the scope and measurement conditions need to be clear |	Does the less-than-800-ms p95 target apply to all search operations, and under what test conditions should it be measured?| Medium | 
| F-06 | Untestable	| "Safe for children" |Safety controls and expected behaviour are not specified in the brief provided. | 	What child-safety, privacy, and access-control requirements are mandatory? | High |
| F-07 |	Untestable | "Work on any phone" | Supported devices, operating systems, and browsers are unspecified | Which devices, operating systems, and browsers must be supported?	| Medium |
| F-08 |	Missing	| Payment failure during booking |	The expected behaviour after a failed payment is unclear | Should the booking remain pending, be cancelled, or allow a retry? | High |
| F-09 |	Missing	| Network interruption or payment retry | Retrying could cause duplicate charges | How should the system prevent or reverse duplicate charges? | High |
| F-10 | Missing |	 Calculation of the 15% commission and handling of weekly tutor payouts	|The commission rate and payout frequency are specified, but the calculation basis and handling of payout failures are not defined in the brief. | Is the 15% commission calculated from the full session price, and how are failed or delayed weekly payouts handled? | High |
| F-11 |	Ambiguous |	"Completed session" | Different interpretations could affect payments, refunds, and ratings | What exact event changes the session status to completed? |	High |
| F-12 |	Missing	| Rating submission and session association |	Ineligible users might submit ratings or rate the wrong session | Who can submit a rating, and when is rating enabled? | Medium |
| F-13 | Ambiguous | Tutoring languages and UI languages | Language filters may produce unexpected search results | Are tutoring language filters independent of the interface language? | Medium |
| F-14 | Missing | No tutors match search criteria |	The expected empty-result behaviour is undefined | What message and actions should appear when no tutors match? | Medium |
| F-15 | Missing | Payment succeeds but booking confirmation fails | A user could be charged without receiving a confirmed booking | How should the system recover the booking or refund the payment?	| High |
| F-16 | Conflicting | Founder statements about cancellation and refunds | The statements about when tutors can cancel and when students receive refunds contradict one another. QA cannot determine the correct expected result until the policy is agreed. | Which cancellation and refund policy is the single authoritative rule for both students and tutors, including cancellations within 12 hours of a session? | High |

## 4. Assumptions

|ID| Assumption | Why it is needed |
|---|---|---|
| A-01 | The scheduled session start time is the intended reference for the 12-hour cancellation window. | To establish a consistent boundary for cancellation testing. |
| A-02 | The product owner will provide one authoritative cancellation and refund policy. | To avoid testing contradictory rules as if both were correct. |
| A-03 | Tutor verification must be completed before a tutor is advertised as vetted. | To identify an observable verification status. |
| A-04 | Payment retries must not result in duplicate charges for a single intended payment. | To protect students from incorrect charges. |
| A-05 | A payment failure must produce a defined and recoverable booking state. | To test failure handling consistently. |
| A-06 | Tutor commission and payout calculations will be defined before financial acceptance testing. | To calculate expected financial outcomes accurately. |
| A-07 | A rating must be associated with the correct eligible session. | To prevent incorrect or unauthorised ratings. |
| A-08 | Supported mobile devices and browsers will be agreed before compatibility testing. | To establish a clear compatibility test scope. |

## 5. Top Three Clarification Questions

1. Cancellation and refunds: The founder statements conflict about when tutors can cancel and when students receive refunds. Which policy is authoritative, and is the 12-hour cancellation cutoff measured from the scheduled session start time?
2. Payments: What should happen if a payment is interrupted, retried, declined, or successful while booking confirmation fails?
3. Tutor verification and child safety: What specific verification and safety checks must be completed before a tutor can accept bookings?

## 6. Reflection

This review helped me understand that a requirement can create testing problems even before any code exists. Ambiguous wording can lead developers to implement different interpretations, while missing failure scenarios can leave important user journeys undefined.

I learned to classify findings rather than simply saying that a requirement is unclear. I also learned that clarification questions should be specific and answerable, and that assumptions must be documented instead of silently treated as confirmed requirements.

My next step is to confirm the unresolved rules and use the clarified requirements to develop traceable test conditions.

## 7. AI Review Record

**What AI identified that I missed:**  
AI highlighted the risk of payment succeeding while booking confirmation fails, which could leave a student charged without a confirmed booking.

**What AI got wrong:**  
AI initially overlooked the NFR-1 target of less than 800 ms at p95. I corrected the finding to focus on clarifying the target’s scope and test conditions.

**What AI assumed without evidence:**  
AI suggested possible payment recovery and refund behaviours that were not confirmed in the challenge brief.

**What I accepted or rejected and why:**  
I accepted suggestions about payment failures and duplicate charges because they reveal important scenarios to clarify. I rejected assumptions that were not supported by the brief and recorded them as questions for the product owner.


