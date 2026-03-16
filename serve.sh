#!/usr/bin/env bash
set -e

bash build.sh

echo ""
echo "=== Starting dev server ==="
echo "Open http://localhost:8080"
python3 -m http.server 8080
