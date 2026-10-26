
#!/usr/bin/env python3
"""Score and validate the LearnLanka risk register."""

import csv
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
CSV_PATH = ROOT / "data" / "risk-register.csv"
TC_PATHS = list(ROOT.glob("*-session2-test-conditions.md"))

if not CSV_PATH.exists():
    sys.exit(f"Risk register not found: {CSV_PATH}")

if not TC_PATHS:
    sys.exit("Test conditions Markdown file not found.")

tc_text = TC_PATHS[0].read_text(encoding="utf-8")
valid_tcs = set()
for part in tc_text.split("|"):
    part = part.strip()
    if part.startswith("TC-") and part[3:].isdigit():
        valid_tcs.add(part)

with CSV_PATH.open(encoding="utf-8-sig", newline="") as f:
    risks = list(csv.DictReader(f))

if not risks:
    sys.exit("Risk register is empty.")

required = {
    "id", "area", "what_could_go_wrong",
    "likelihood", "impact", "linked_tc", "decision"
}
if not required.issubset(risks[0].keys()):
    sys.exit("CSV headers do not match the required format.")

errors = []
scores = []

for risk in risks:
    rid = risk["id"].strip()
    try:
        likelihood = int(risk["likelihood"])
        impact = int(risk["impact"])
    except ValueError:
        errors.append(f"{rid}: likelihood and impact must be numbers.")
        continue

    if not (1 <= likelihood <= 3 and 1 <= impact <= 3):
        errors.append(f"{rid}: likelihood and impact must be 1, 2, or 3.")
        continue

    score = likelihood * impact
    scores.append(score)
    linked = [tc.strip() for tc in risk["linked_tc"].split(";") if tc.strip()]

    if not linked:
        errors.append(f"{rid}: no linked test conditions.")
    for tc in linked:
        if tc not in valid_tcs:
            errors.append(f"{rid}: {tc} is not an existing test condition.")

print("| Rank | ID | Risk | Likelihood | Impact | Score | Linked TCs |")
print("|---:|---|---|---:|---:|---:|---|")

ranked = sorted(
    zip(risks, scores),
    key=lambda item: item[1],
    reverse=True,
)

for rank, (risk, score) in enumerate(ranked, start=1):
    print(
        f"| {rank} | {risk['id']} | {risk['what_could_go_wrong']} "
        f"| {risk['likelihood']} | {risk['impact']} | {score} "
        f"| {risk['linked_tc']} |"
    )

high_risks = sum(score in (6, 9) for score in scores)
distinct_scores = set(scores)

print("\n## Results Summary")
print(f"Total risks: {len(risks)} (target 10+)")
print(f"Risks scoring 6 or 9: {high_risks} (target 3+)")
print(f"Distinct risk scores: {len(distinct_scores)} (target 3+)")
print(f"Risks with invalid TC links: {sum('not an existing' in e for e in errors)}")

if len(risks) < 10:
    errors.append("At least 10 risks are required.")
if high_risks < 3:
    errors.append("At least 3 risks must score 6 or 9.")
if len(distinct_scores) < 3:
    errors.append("At least 3 distinct risk scores are required.")

if errors:
    print("\nVALIDATION FAILED:")
    for error in errors:
        print(f"- {error}")
    sys.exit(1)

print("\nVALIDATION PASSED")
