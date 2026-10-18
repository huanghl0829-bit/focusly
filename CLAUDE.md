# Focusly — Project Guide

Focusly is a local-first study workspace for macOS: a SwiftUI + WKWebView shell that loads a vanilla-JS single-page app (no framework, no build step). All study data is stored locally in `localStorage`, isolated per account.

## Authoritative files

Edit only these root files — they are what ships:

- `app.js` — all application logic
- `index.html` — markup and dialogs
- `styles.css` — all styling

The copies under `Focusly/Focusly/` are stale and unused. The Xcode project (`Focusly/Focusly.xcodeproj/project.pbxproj`) references the root files via `../../index.html`, `../../styles.css`, `../../app.js`.

## Build & verify

```sh
xcodebuild -project Focusly/Focusly.xcodeproj -scheme Focusly -configuration Debug build
```

There is no Node/npm in this project. JavaScript is checked with a JavaScriptCore harness (`osascript -l JavaScript`); the plan is to add a `verify.sh` wrapper for this (see `docs/execution-plan.md`).

## Standard documents

- Requirements: `docs/requirements.md`
- Tech stack: `docs/tech-stack.md`
- Design spec: `docs/design.md`
- Execution plan / roadmap: `docs/execution-plan.md`
- Document index: `docs/README.md`
- Dev logs: `devlog/`

## Work instructions

1. Before starting any task, read `docs/execution-plan.md` and pick the next small step.
2. Take on ONE small, verifiable step at a time — do not batch large changes.
3. Maintain the daily dev log: run `./devlog.sh` to create today's `devlog/YYYY-MM-DD.md`, then keep its **Completed / In progress / Blockers / Next steps** sections current as you work.
4. Verify after each change: run the JavaScriptCore syntax/logic harness and `xcodebuild`.
5. Conventions:
   - Vanilla JS only; no new frameworks or libraries without discussion.
   - Escape user content with `escapeHtml()` before inserting into `innerHTML`.
   - Render untrusted HTML (e.g. AI notes) in a sandboxed `<iframe sandbox="">`.
   - Mutate state through `updateState(mutator)` and `renderApp()`; persist via `persistState()`.
6. When a feature completes, record it in that day's dev log under **Completed**.
