#!/usr/bin/env python3
"""Coverage check for the LearnLanka test-conditions table (Session 2, Deliverable 2)."""

import re
import sys
from collections import defaultdict
from pathlib import Path

TC_ROW = re.compile(r"^\|\s*TC-\d+\s*\|")  # data rows only, not the header
ROOT = Path(__file__).resolve().parent.parent
REQUIRED = [f"FR-{n}" for n in range(1, 6)] + [
    f"NFR-{n}" for n in range(1, 6)
] + [f"CON-{n}" for n in range(1, 6)]

files = sorted(ROOT.glob("*-session2-test-conditions.md"))
if not files:
    sys.exit("No *-session2-test-conditions.md file found next to tools/")

rows = []
for line in files[0].read_text(encoding="utf-8").splitlines():
    if TC_ROW.match(line):
        cells = [c.strip() for c in line.strip().strip("|").split("|")]
        rows.append({
            "id": cells[0],
            "refs": [r.strip() for r in cells[1].split(",")],
            "polarity": cells[3].lower()
        })

per_req = defaultdict(lambda: {"count": 0, "negative": False})
for r in rows:
    for ref in r["refs"]:
        per_req[ref]["count"] += 1
        if r["polarity"] in ("negative", "boundary"):
            per_req[ref]["negative"] = True

print("| Requirement | # of conditions | At least one negative? |")
print("|---|---|---|")
for req in REQUIRED:
    c = per_req[req]
    print(f"| {req} | {c['count']} | {'Yes' if c['negative'] else 'No'} |")

neg = sum(
    1 for r in rows
    if r["polarity"] in ("negative", "boundary")
)
uncovered = [req for req in REQUIRED if per_req[req]["count"] == 0]

print(
    f"\nConditions: {len(rows)} (target 25+) | "
    f"Negative/boundary: {neg} (target 8+)"
)

if uncovered:
    print("Uncovered: " + ", ".join(uncovered))

sys.exit(
    0 if len(rows) >= 25 and neg >= 8 and not uncovered else 1
)
