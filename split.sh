#!/usr/bin/env bash
set -euo pipefail
export LC_ALL=C

OUT="${1:-dist}"
LIMIT=100000
MIN_TOTAL=1000

BASE="https://raw.githubusercontent.com/hagezi/dns-blocklists/main/wildcard"
NRD="https://raw.githubusercontent.com/hagezi/nrd/main/domains"

LISTS=(
  "hgz-pro|$BASE/pro-onlydomains.txt|3"
  "hgz-tif-mini|$BASE/tif.mini-onlydomains.txt|3"
  "hgz-entropy-nrd-7d|$NRD/dga7.txt|7"
)

rm -rf "$OUT"
mkdir -p "$OUT"
work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

status="$OUT/status.txt"
echo "built $(date -u +%Y-%m-%dT%H:%M:%SZ)" > "$status"

for entry in "${LISTS[@]}"; do
  IFS='|' read -r name url chunks <<< "$entry"

  curl -fsSL --retry 3 --retry-delay 5 "$url" \
    | grep -v '^[[:space:]]*#' \
    | grep -v '^[[:space:]]*$' \
    | sort -u > "$work/$name.txt"

  total="$(wc -l < "$work/$name.txt")"
  if [ "$total" -lt "$MIN_TOTAL" ]; then
    echo "ERROR: $name has only $total lines, refusing to publish" >&2
    exit 1
  fi

  split -n "l/$chunks" --numeric-suffixes=1 -a 1 --additional-suffix=.txt \
    "$work/$name.txt" "$OUT/$name-"

  for f in "$OUT/$name"-*.txt; do
    lines="$(wc -l < "$f")"
    if [ "$lines" -ge "$LIMIT" ]; then
      echo "ERROR: $f has $lines lines, raise the chunk count for $name" >&2
      exit 1
    fi
    echo "$(basename "$f") $lines" >> "$status"
  done
  echo "$name total $total" >> "$status"
done

cat "$status"
