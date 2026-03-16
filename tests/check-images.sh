#!/usr/bin/env bash
set -e

echo "=== Checking image references ==="

errors=0

# Find all img src references in HTML files
for html_file in *.html writing/*.html 2>/dev/null; do
  [ -f "$html_file" ] || continue

  # Extract src attributes from img tags
  grep -oP 'src="(/assets/[^"]+)"' "$html_file" 2>/dev/null | while read -r match; do
    src=$(echo "$match" | grep -oP '/assets/[^"]+')
    local_path=".${src}"

    if [ ! -f "$local_path" ]; then
      echo "ERROR: $html_file references $src but file not found"
      errors=$((errors + 1))
    else
      size=$(wc -c < "$local_path" | tr -d ' ')
      echo "OK: $html_file -> $src (${size} bytes)"
    fi
  done
done

if [ $errors -gt 0 ]; then
  echo "FAILED: $errors broken image references"
  exit 1
fi

echo "=== All image references valid ==="
