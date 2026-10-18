#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
date="$(date +%Y-%m-%d)"
file="devlog/${date}.md"
if [ ! -f "$file" ]; then
  sed "s/{{DATE}}/${date}/g" devlog/_template.md > "$file"
fi
echo "$file"
