# Focusly — Technology Stack

## Native shell

- **Swift / SwiftUI + AppKit** (`Focusly/Focusly/FocuslyApp.swift`), targeting macOS 13+.
- A `WKWebView` loads the bundled `index.html` via `loadFileURL(_:allowingReadAccessTo:)`.
- A `focusly` `WKScriptMessageHandler` bridge (currently lifecycle-only); native pushes `appActive` / `appInactive` into JS via `window.focuslyNativeLifecycle(...)`.

## UI layer

- **Vanilla HTML / CSS / JavaScript** — `index.html`, `styles.css`, `app.js`. No framework, no bundler, no build step, no `package.json`.
- A client-side SPA: `showPage()` toggles `.page` sections; markup is built as JS template strings assigned to `innerHTML`.

## Storage

- `localStorage`, keys prefixed `focusly.*` (accounts, session, per-account state v3, legacy v2).
- Per-account isolation: state is keyed by account id.

## Build / tooling

- Xcode project: `Focusly/Focusly.xcodeproj`. Build with `xcodebuild -project Focusly/Focusly.xcodeproj -scheme Focusly -configuration Debug build`.
- The Xcode project references the root web assets via `../../…`, so the root files ship; the copies under `Focusly/Focusly/` are stale and unused.
- No Node/npm. JavaScript is verified with a JavaScriptCore harness (`osascript -l JavaScript`).

## Security

- Account passwords are never stored; a PBKDF2 (100,000 iterations, SHA-256) verifier plus a random salt is stored instead.
- User content is escaped with `escapeHtml()` before insertion into `innerHTML`.
- AI/HTML notes are rendered in `<iframe sandbox="">` (no scripts, no same-origin).
