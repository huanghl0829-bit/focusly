# Focusly — Development Requirements

## Product

Focusly is a local-first study workspace for macOS. It combines planning, focus timing, flashcards, progress tracking, and notes into one private, offline app. Every user's data stays on their own Mac and is isolated per local account.

## Features

- **Local accounts** — email + password (PBKDF2-verified), with a separate workspace per account.
- **Onboarding** — display name, weekly/daily goals, and sensible defaults.
- **Study plan** — a daily agenda of subjects/tasks with durations and completion state.
- **Focus timer** — pomodoro (focus / short break / long break), session tracking, and idle auto-pause.
- **Flashcards** — manual decks, import (CSV, tab-separated, or `question :: answer`), spaced-repetition ratings, and deck review.
- **Progress** — weekly study time, session count, card reviews, and subject mastery.
- **Notes** — save and edit notes; import AI-generated HTML notes and view them rendered in-app (sandboxed).
- **Materials** — import text/Markdown files and generate notes or flashcards from them.
- **Settings** — theme, sound effects, timer settings, pause-on-leave, reduce motion, tutorial, profile, and local-data reset.
- **Backup** — export everything to a single JSON file and restore it on any device.
- **AI generation (optional)** — paste an OpenAI-compatible API key in Settings to generate notes and flashcards from imported materials; the key stays in the browser and is used only on demand.

## Current state

- Web-first: the website is the product (see the 2026-10-25 dev log); the `Focusly/` macOS shell remains in the repo but is not the target.
- `verify.sh` checks the app headlessly (CSS braces, markup references, JavaScriptCore boot + logic tests) — run it after every change.
- AI-generated HTML note import and on-device AI generation of notes/flashcards are both available; local bullet-note generation is still the fallback without a key.

## Non-goals (for now)

- No built-in AI service and no backend — AI generation is optional and uses each user's own key; everything else is fully offline.
- No PDF text extraction (PDFs are stored but flagged unsupported).
- No cloud sync and no network calls beyond the optional AI request.

## Constraints

- Offline and local-only; no external services.
- Data persisted in `localStorage`, isolated per account.
