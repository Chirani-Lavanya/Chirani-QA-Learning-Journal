## LearnLanka — Testability Feedback on User Story Set v0.1

Story set reviewed: Reference set provided in the Session 2, Day 1 challenge

## Project: LearnLanka Tutoring Marketplace

Reviewer: QA Intern

## 1. Story-by-story review

| Story | AC | Checklist item failed | Quote | Why it is untestable or weak as written | Suggested rewrite
|---|---|---|---|---|---|
| S1 — Filter tutors by subject | AC-1 | Expected result and test data | "Only tutors who teach Combined Maths are listed." | The expected filtering behaviour is clear, but the criterion does not define what happens when no tutors match or when a tutor teaches multiple subjects. | Given a logged-in Student is on the search screen and selects Combined Maths, When the Student searches, Then every returned tutor must teach Combined Maths, and no tutor who does not teach it may appear.| 
| S1 — Filter tutors by subject | AC-2 | Expected result and measurable ordering | "Results are sorted by relevance." | Relevance is not defined. Different implementations could produce different orders and still claim to be correct.| Given multiple tutors match the selected search criteria, When the results are displayed, Then tutors must be ordered according to the relevance rules agreed and documented by the product owner. The product owner must define the ranking factors and tie-breaking rule before this criterion is considered test-ready.|
| S2 — Book and pay | AC-1 | Preconditions and observable outcome | "Given an open 1-hour slot ... when the Student pays successfully by card, then the booking status is 'Confirmed' and the slot is no longer shown to other students." | The successful card-payment outcome is observable, but concurrent booking attempts and the exact meaning of a successful payment need to be considered. The criterion also does not explicitly define the result if another student attempts to book the same slot simultaneously.| Given an available one-hour slot and a Student who completes a successful card payment, When the payment gateway confirms success and the booking is saved, Then the booking status is Confirmed and the slot is unavailable for another booking. A concurrent attempt to book the same slot must not create a second confirmed booking. |
| S2 — Book and pay | AC-2 | Observable outcome and failure behaviour | "If payment fails, the user is informed appropriately." | "Appropriately" does not specify the message, booking state, retry behaviour or whether the student can be charged despite the failure. | Given a Student attempts to pay for a booking, When the payment gateway returns a failed-payment result, Then the Student sees an agreed failure message, the booking is not marked Confirmed, and the system follows the product owner's agreed retry and recovery policy. The policy must specify how uncertain payment outcomes are handled. | 
| S3 — Cancel a booking | AC-1 | Conflicting requirements and boundary definition | "Given a confirmed booking more than 12 hours away, when the Tutor cancels, then the cancellation is accepted and the student is refunded." | The founders gave conflicting instructions about cancellation rights and refunds. The criterion does not establish one authoritative policy or specify the refund amount and timing. |Given a confirmed booking that is more than 12 hours from its scheduled start, When the Tutor cancels it, Then the system applies the single cancellation and refund policy approved by the product owner, updates the booking status, and displays the applicable refund outcome. The final expected refund outcome must be specified after the conflicting policies are resolved.|
| S3 — Cancel a booking | AC-2 | Boundary condition and business-rule consistency | "Given a confirmed booking less than 12 hours away, when the Tutor opens it, then the Cancel button is disabled and the message 'Cancellations need 12 hours notice' is shown." | The behaviour for less than 12 hours is defined, but the criterion does not cover exactly 12 hours. It may also conflict with the founder's statement that tutors should be able to cancel at any time. | Given a confirmed booking whose scheduled start is less than 12 hours away, When the Tutor opens the booking, Then the Cancel button is disabled and the agreed cancellation message is displayed, provided the product owner confirms that this restriction is the authoritative policy. A separate boundary criterion must define behaviour at exactly 12 hours.| 
| S4 — Search in own language | AC-1 | Scope and completeness | "Given the app language set to Tamil, when the Student opens the search screen, then every label and filter name is shown in Tamil." | "Every label and filter name" could be interpreted differently across the screen, and it does not explicitly address untranslated text or clipped Tamil strings. | Given the app language is set to Tamil, When the Student opens the search screen, Then every visible label, filter name, button and message on that screen is displayed in Tamil, with no missing translations or clipped text. |
| S4 — Search in own language | AC-2 | Measurable performance threshold | "The search is fast." | There is no measurable threshold, measurement method or test condition. The criterion cannot produce a consistent pass or fail result. | Given search requests are measured from a Sri Lankan ISP under an agreed test workload, When the first page of tutor search results is requested across a representative sample of searches, Then the 95th-percentile response time is under 800 ms. The measurement tool, sample size and workload must be agreed and recorded.|
| S5 — Rate my tutor | AC-1 | Validation rules and observable outcome | Given a session marked Completed, when the Student submits 1–5 stars and a comment of up to 100 characters, then the rating appears on the tutor's profile. | The allowed rating range and comment length are specified, but the criterion does not define whether a rating can be submitted more than once or how the system validates missing or overlong comments. | Given a completed session for which the Student is eligible to rate the Tutor, Whenthe Student submits a rating from 1 to 5 stars and a comment within the agreed one-line, 100-character limit, Then the rating is saved against the correct session and displayed on the correct tutor's profile. Invalid ratings must be rejected. |
| S5 — Rate my tutor | AC-2 | Undefined validation and acceptance criteria | Inappropriate comments are not allowed. | "Inappropriate" is subjective without a documented moderation policy. Different reviewers may classify the same comment differently. | Given a Student submits a rating comment, When the comment is evaluated against the content moderation rules approved by the product owner, Then comments that violate those rules are rejected or handled according to the documented moderation outcome, and the Student receives an explanatory message. The prohibited-content categories and handling rules must be defined first. |
| S6 — Tutor payouts | AC-1 | Missing financial rules and measurable timing | Tutors are paid weekly minus commission. | The 15% commission is defined in FR-4, but the criterion does not specify the calculation basis, payout schedule, treatment of cancelled or disputed sessions, or handling of failed transfers. | Given a completed session that is eligible for payout, When the weekly payout is calculated, Then the system applies the approved 15% commission calculation, includes the session according to the agreed payout cut-off, and records the resulting tutor amount. The calculation basis, cut-off and treatment of refunds or failed transfers must be confirmed by the product owner. |
| S6 — Tutor payouts | AC-2 | Observable outcome and usability criteria | The tutor can see a payout summary that is easy to understand. | "Easy to understand" is subjective. It does not specify the information that must be displayed or how correctness will be assessed. | Given a Tutor has completed sessions and payout records, When the Tutor opens the payout summary, Then the summary displays the relevant payout period, completed-session amounts, commission deductions, net payout amount and payout status, using clearly labelled values that can be reconciled with the underlying records. |


## 2. Acceptance criteria that can be lifted straight into a test
   
The following criteria are sufficiently specific to derive test conditions. They may still need concrete test data and execution steps during test-case design.
- S1, AC-1 — Subject filtering: The system returns only tutors who teach the selected subject. Mapped test conditions: TC-01 and TC-05. TC-01 covers subject filtering; TC-05 covers the no-match outcome.
- S2, AC-1 — Successful card payment and booking confirmation: A successful card payment results in a Confirmed booking, and the slot is no longer available to other students. Mapped test conditions: TC-07 and TC-09. TC-10 and TC-12 cover duplicate booking and concurrent booking risks.
- S3, AC-2 — Cancellation restriction under 12 hours: The Cancel button is disabled and the stated message is shown for a confirmed booking less than 12 hours away. Mapped test condition: TC-17. This mapping assumes the product owner confirms the stated restriction as the authoritative policy.
- 
## 3. Acceptance criteria that cannot yet be accepted as test-ready

- S1, AC-2: "Results are sorted by relevance." The ranking factors and tie-breaking rules must be defined.
- S2, AC-2: "If payment fails, the user is informed appropriately." The message, booking state, retry rules and recovery behaviour must be agreed.
- S3, AC-1: The refund outcome cannot be finalised while the founders' cancellation and refund statements conflict.
- S4, AC-2: "The search is fast." Replace this with the measurable under-800-ms p95 target, including an agreed workload and measurement method.
- S5, AC-2: "Inappropriate comments are not allowed." Define the moderation categories and expected rejection or moderation behaviour.
- S6, AC-1: "Tutors are paid weekly minus commission." Define the calculation basis, payout cut-off and exceptional financial cases.
- S6, AC-2: "Easy to understand." Define the required fields and labels in the payout summary.
- 
## 4. Three questions for the developer pair

1. Cancellation and refunds: Which single cancellation and refund policy has the product owner approved, and how should the system behave at exactly 12 hours before the scheduled session start?
2. Payment recovery: If the payment gateway times out after processing a payment but before LearnLanka confirms the booking, how will the system determine the payment outcome and prevent duplicate charges?
3. Search and ranking: What ranking factors and tie-breaking rules define tutor relevance, and how should the search screen behave when no tutors match the selected filters?

## 5. Reflection

Reviewing the reference stories helped me understand that a user story can describe a valuable feature while still leaving important behaviour undefined. Phrases such as "fast", "appropriately", "relevance" and "easy to understand" do not always give a tester a reliable pass/fail result. Acceptance criteria need observable outcomes, measurable thresholds, defined preconditions and explicit failure behaviour.

This review also connected directly to my Deliverable 2 test conditions. For example, TC-01 covers subject filtering, TC-05 covers searches with no matching tutors, TC-17 covers cancellation inside the 12-hour boundary, and TC-29 and TC-51 cover search-performance behaviour. These conditions show why a single acceptance criterion may need several test conditions, including negative and boundary cases that the original story does not mention.

I also learned not to silently convert assumptions into requirements. Cancellation and refund rules, payment recovery, comment moderation and payout calculations need decisions from the product owner before the final expected outcomes can be confirmed. My feedback should help the developer pair improve the stories without blaming the authors or inventing business rules.











