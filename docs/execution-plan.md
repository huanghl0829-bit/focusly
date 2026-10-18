# Focusly — Execution Plan (Roadmap)

## Guiding principles

- One small, verifiable step at a time; build and verify after each step.
- Keep the app offline and local; do not add dependencies without discussion.
- Prefer stability and safety over breadth.

## Phase 0 — Done

AI-generated HTML notes import + in-app rendering (sandboxed iframe). Added a separate "Import AI notes" flow while keeping the existing local note generator.

## Phase 1 — Foundations (next, small)

1. Add a lightweight verification script (e.g. `verify.sh`) that runs the JavaScriptCore syntax/logic check — the same approach used to validate the notes feature — so every change is checked without a browser.
2. (Recommended, only if desired) `git init` + a `.gitignore` (ignore `.DS_Store`, build/`DerivedData` artifacts), and commit the current state as a restore point.

## Phase 2 — Notes polish

- Multi-file import (import several HTML notes at once).
- Better note titles and delete confirmation.
- Optional opt-in toggle for script-enabled rendering (relaxes the sandbox only when the user trusts the note).

## Phase 3 — Later

- Flashcards import hardening and CSV export.
- PDF text extraction.
- Settings improvements.
- (Last, highest risk) split the large `app.js` into modules.

## Next step

Begin Phase 1, step 1: add `verify.sh`.
