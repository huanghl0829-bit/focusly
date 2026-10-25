#!/bin/bash
# Focusly launcher — double-click this file to start the app on this Mac.
# It starts a tiny private server for the app folder (if one isn't already
# running) and opens Focusly in your default browser. The server tells the
# browser not to cache, so every launch shows the latest saved version.

PORT=8787
cd "$(dirname "$0")"

if curl -s -o /dev/null "http://127.0.0.1:${PORT}/index.html"; then
  echo "Focusly is already running."
else
  HANDLER=$(mktemp /tmp/focusly-serve-XXXX.py)
  cat > "$HANDLER" <<'EOF'
import http.server, functools, sys
class NoStore(http.server.SimpleHTTPRequestHandler):
    def end_headers(self):
        self.send_header('Cache-Control', 'no-store')
        super().end_headers()
    def log_message(self, *args): pass
http.server.ThreadingHTTPServer.allow_reuse_address = True
server = http.server.ThreadingHTTPServer(('127.0.0.1', int(sys.argv[1])), functools.partial(NoStore, directory=sys.argv[2]))
server.serve_forever()
EOF
  nohup python3 "$HANDLER" "$PORT" "$PWD" >/dev/null 2>&1 &
  sleep 1
  echo "Focusly started."
fi

open "http://127.0.0.1:${PORT}"
