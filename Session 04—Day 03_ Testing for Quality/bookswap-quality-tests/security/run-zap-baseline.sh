#!/usr/bin/env bash
set -euo pipefail
if [[ "${CONFIRM_PRACTICE_BUILD:-}" != "YES" ]]; then
  echo "Set CONFIRM_PRACTICE_BUILD=YES only after confirming the authorised local practice build." >&2
  exit 2
fi
TARGET="${ZAP_TARGET:-http://host.docker.internal:3000}"
case "$TARGET" in
  http://host.docker.internal:3000|http://localhost:3000|http://127.0.0.1:3000) ;;
  *) echo "Refusing non-local target: $TARGET" >&2; exit 2 ;;
esac
OUT="$PWD/security/evidence"
mkdir -p "$OUT"
docker run --rm -t -v "$OUT:/zap/wrk:rw" \
  ghcr.io/zaproxy/zaproxy:2.16.1 \
  zap-baseline.py -t "$TARGET" -r zap-baseline-report.html
