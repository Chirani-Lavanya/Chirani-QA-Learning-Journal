\# BookSwap – SQL Verification Evidence



\## Environment

\- Database: PostgreSQL 16

\- Database: `bookswap`

\- Evidence source: Session 3 seeded database

\- Verification method: PostgreSQL CLI (`psql`)



\## Verified Findings



\### SQL-01 – Duplicate Pending Borrow Requests

\- Book ID: 11

\- Borrower ID: 9

\- Request IDs: 29 and 30

\- Both records have `pending` status.

\- Result: Two pending requests exist for the same book and borrower.



\### SQL-02 – Invalid Loan Date Sequence

\- Loan ID: 29

\- Borrowed date: 2026-11-06

\- Returned date: 2026-11-01

\- Result: The return date is earlier than the borrowed date.



\### SQL-03 – Missing Return Date

\- Loan ID: 30

\- Status: `returned`

\- Returned date: NULL

\- Result: The loan is marked as returned without a recorded return date.



\### SQL-04 – Invalid ISBN Length

\- Book ID: 57

\- Title: Funny Boy

\- ISBN: `955123456`

\- ISBN length: 9

\- Result: The ISBN does not meet the assumed 10- or 13-character length rule. Confirm the requirement before classifying this as a defect.



\### SQL-05 – Missing Member Phone Numbers

\- Member IDs: 17 and 19

\- Result: Both records have empty phone values.

\- Classification: Data-completeness finding. This does not demonstrate exposure of private information through an API.



\## Conclusion



Five database inconsistencies were verified directly using PostgreSQL queries. These findings provide evidence of seeded-data quality issues. Further API or application-level testing is required before classifying them as confirmed application defects.

