#!/bin/bash
# Focusly launcher — double-click this file to start the app on this Mac.
# It starts a tiny private server for the app folder (if one isn't already
# running) and opens Focusly in your default browser.

PORT=8787
cd "$(dirname "$0")"

if curl -s -o /dev/null "http://127.0.0.1:${PORT}/index.html"; then
  echo "Focusly is already running."
else
  nohup python3 -m http.server "${PORT}" >/dev/null 2>&1 &
  sleep 1
  echo "Focusly started."
fi

open "http://127.0.0.1:${PORT}"
