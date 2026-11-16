#!/usr/bin/env bash
# Eight tester-level checks for the authorised local Day 03 BookSwap practice build.
# Synthetic data only. This intentionally does not target the Day 02 Prism mock.
set -u
API_BASE="${API_BASE:-http://localhost:3000/api}"
OUT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/evidence"
mkdir -p "$OUT_DIR"

if [[ "${CONFIRM_PRACTICE_BUILD:-}" != "YES" ]]; then
  echo "Set CONFIRM_PRACTICE_BUILD=YES only after confirming this is the authorised local practice build." >&2
  exit 2
fi
case "$API_BASE" in
  http://localhost:3000/api|http://127.0.0.1:3000/api) ;;
  *) echo "Refusing target '$API_BASE'. This script permits only the local practice API." >&2; exit 2 ;;
esac
command -v curl >/dev/null 2>&1 || { echo "curl is required" >&2; exit 2; }
: > "$OUT_DIR/check-results.txt"
log() { printf '%s\n' "$*" | tee -a "$OUT_DIR/check-results.txt"; }
request() {
  local name="$1"; shift
  local code
  code=$(curl -sS --max-time 15 -D "$OUT_DIR/${name}.headers.txt" \
    -o "$OUT_DIR/${name}.body.txt" -w '%{http_code}' "$@" 2>"$OUT_DIR/${name}.curl-error.txt") || code="CURL_ERROR"
  log "$name -> HTTP $code (inspect saved redacted evidence; compare with expected status)"
}

log "Run time: $(date -Is)"
log "Target: $API_BASE"
log "Tokens and passwords are not printed. Redact evidence before sharing."

# 1. Missing token; expected 401.
request 01_missing_token "$API_BASE/books"

# 2. Garbage token; expected 401. An expired token can be tested separately if supplied.
request 02_garbage_token -H 'Authorization: Bearer abc' "$API_BASE/books"
if [[ -n "${EXPIRED_TOKEN:-}" ]]; then
  request 02_expired_token -H "Authorization: Bearer ${EXPIRED_TOKEN}" "$API_BASE/books"
else
  log "02_expired_token -> SKIPPED (set EXPIRED_TOKEN from a synthetic test account)"
fi

# 3–4. BOLA checks require two synthetic members and a disposable loan owned by A.
if [[ -n "${TOKEN_A:-}" && -n "${TOKEN_B:-}" && -n "${LOAN_A_ID:-}" ]]; then
  request 03_A_own_loan_baseline -H "Authorization: Bearer ${TOKEN_A}" "$API_BASE/loans/${LOAN_A_ID}"
  request 03_B_reads_A_loan -H "Authorization: Bearer ${TOKEN_B}" "$API_BASE/loans/${LOAN_A_ID}"
  if [[ "${RUN_BOLA_PATCH:-NO}" == "YES" ]]; then
    log "WARNING: PATCH changes the loan. Use only a disposable synthetic loan."
    request 04_B_PATCH_A_loan -X PATCH -H "Authorization: Bearer ${TOKEN_B}" \
      -H 'Content-Type: application/json' --data '{"status":"returned"}' "$API_BASE/loans/${LOAN_A_ID}"
  else
    log "04_B_PATCH_A_loan -> SKIPPED (set RUN_BOLA_PATCH=YES only for a disposable synthetic loan)"
  fi
else
  log "03_BOLA_baseline_and_read -> SKIPPED (set TOKEN_A, TOKEN_B and LOAN_A_ID)"
  log "04_BOLA_PATCH -> SKIPPED (set two synthetic tokens, LOAN_A_ID and RUN_BOLA_PATCH=YES)"
fi

# 5–6. Input checks require a synthetic Member A token.
if [[ -n "${TOKEN_A:-}" ]]; then
  request 05_sql_injection_search --get --data-urlencode "search=' OR 1=1 --" \
    -H "Authorization: Bearer ${TOKEN_A}" "$API_BASE/books"
  request 05_script_injection_search --get --data-urlencode 'search=<script>alert(1)</script>' \
    -H "Authorization: Bearer ${TOKEN_A}" "$API_BASE/books"
  long_title=$(python3 -c "print('A' * 5000)")
  body=$(python3 -c 'import json,sys; print(json.dumps({"title":sys.argv[1],"author":"QA Synthetic Author","isbn":"9789550000002","condition":"good"}))' "$long_title")
  request 06_oversized_title -X POST -H "Authorization: Bearer ${TOKEN_A}" \
    -H 'Content-Type: application/json' --data "$body" "$API_BASE/books"

  # 7. Privacy: this checks catalogue field names only. Repeat across every list endpoint.
  privacy_code=$(curl -sS --max-time 15 -H "Authorization: Bearer ${TOKEN_A}" \
    "$API_BASE/books?page=1&pageSize=50" -o "$OUT_DIR/07_privacy_catalogue.json" \
    -w '%{http_code}' 2>"$OUT_DIR/07_privacy_catalogue.curl-error.txt") || privacy_code="CURL_ERROR"
  if grep -Eiq '"(phone|phoneNumber|address|postalAddress)"[[:space:]]*:' "$OUT_DIR/07_privacy_catalogue.json" 2>/dev/null; then
    privacy="POSSIBLE_PII_FIELDS_FOUND"
  else
    privacy="NO_PHONE_ADDRESS_FIELD_NAMES_FOUND_IN_THIS_RESPONSE"
  fi
  log "07_privacy_catalogue -> HTTP $privacy_code; $privacy (inspect nested data and repeat for all list endpoints)"
else
  log "05_injection_and_06_oversized -> SKIPPED (set TOKEN_A)"
  log "07_privacy_catalogue -> SKIPPED (set TOKEN_A)"
fi

# 8. Login flood is opt-in because it can trigger account lockout. Synthetic account only.
if [[ "${RUN_RATE_LIMIT:-NO}" == "YES" && -n "${LOGIN_EMAIL:-}" && -n "${WRONG_PASSWORD:-}" ]]; then
  : > "$OUT_DIR/08_rate_limit_codes.txt"
  start=$(date +%s)
  for n in $(seq 1 20); do
    (curl -sS --max-time 10 -o /dev/null -w '%{http_code}\n' -X POST "$API_BASE/auth/login" \
      -H 'Content-Type: application/json' \
      --data "{\"email\":\"${LOGIN_EMAIL}\",\"password\":\"${WRONG_PASSWORD}\"}" >> "$OUT_DIR/08_rate_limit_codes.txt") &
  done
  wait
  elapsed=$(( $(date +%s) - start ))
  log "08_rate_limit -> 20 requests sent in ${elapsed}s; HTTP codes: $(tr '\n' ' ' < "$OUT_DIR/08_rate_limit_codes.txt")"
else
  log "08_rate_limit -> SKIPPED (set RUN_RATE_LIMIT=YES, LOGIN_EMAIL and WRONG_PASSWORD for a synthetic disposable account)"
fi

log "Completed. Inspect response bodies, compare to expected codes, add request IDs and update security-checklist.md."
