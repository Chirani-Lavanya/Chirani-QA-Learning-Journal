# BookSwap — Accessibility Quick Check

**Target:** authorised Day 03 practice UI at `http://localhost:3000`. The supplied Day 02 ZIP has no frontend, so these checks are **not run** yet.

## Three core journeys

| Journey | Keyboard-only | Screen-reader names | axe critical/serious + rule IDs | Lighthouse score | Contrast ≥ 4.5:1 | Zoom 200% | 360×800 | Result |
|---|---|---|---|---|---|---|---|---|
| Search catalogue | NOT RUN — no UI supplied | NOT RUN | NOT RUN | NOT RUN | NOT RUN | NOT RUN | NOT RUN | BLOCKED |
| List a book | NOT RUN — no UI supplied | NOT RUN | NOT RUN | NOT RUN | NOT RUN | NOT RUN | NOT RUN | BLOCKED |
| Request a borrow | NOT RUN — no UI supplied | NOT RUN | NOT RUN | NOT RUN | NOT RUN | NOT RUN | NOT RUN | BLOCKED |

## 1. Keyboard-only test

1. Reload the page and avoid using the mouse.
2. Use `Tab` and `Shift+Tab` to reach every control.
3. Use `Enter` and `Space` to activate buttons and controls where appropriate.
4. Confirm every focused control has a visible focus indicator.
5. Confirm focus order is logical and there is no keyboard trap.
6. Record the exact journey, control, expected behaviour and actual behaviour for each finding.

## 2. Screen-reader test

Use NVDA on Windows (or VoiceOver on macOS). Test all form fields and buttons in all three journeys. Record the announced role and accessible name. “Button” without a meaningful name is a defect candidate. Confirm validation errors are announced and associated with the corresponding fields.

## 3. axe and Lighthouse

Run from the repository root when the practice UI and Chrome are available:

```bash
mkdir -p accessibility/evidence
npx @axe-core/cli@4.10.1 http://localhost:3000/search \
  --tags wcag2a,wcag2aa,wcag22aa \
  --save accessibility/evidence/axe-search.json --exit

npx lighthouse@12.2.1 http://localhost:3000/search \
  --only-categories=accessibility --form-factor=mobile \
  --output=html --output-path=accessibility/evidence/lighthouse-search.html \
  --chrome-flags="--headless=new"
```

Repeat for the real list-book and request-borrow page routes. Confirm the routes from the actual app; do not guess. Record every critical/serious violation and its actual axe rule ID. A high Lighthouse score alone does not prove a journey is accessible; manual keyboard and screen-reader checks remain required.

## 4. Contrast, zoom and compatibility

- Verify body text and buttons meet the challenge threshold of at least **4.5:1** contrast.
- Zoom the browser to **200%** and confirm content remains visible without overlap or loss of functionality.
- Use Chrome DevTools device mode at **360×800** and complete all three journeys.

## Finding log

| Finding ID | Journey | Actual control / behaviour | axe rule ID or measured contrast | Severity | Evidence filename |
|---|---|---|---|---|---|
| A11Y-01 | NOT RUN | No UI in supplied Day 02 ZIP | NOT RUN | TBD | TBD |

Do not reuse the example findings shown in the training video as if they were observed on your local application.
