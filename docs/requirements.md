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
- **Settings** — theme, sound effects, timer settings, tutorial, profile, and local-data reset.

## Current state

- AI-generated HTML note import was recently added (see [design.md](design.md) and the dev log). The "Notes" button on materials still produces simple local bullet notes from imported text.

## Non-goals (for now)

- No live AI connection (Settings shows "Coming soon").
- No PDF text extraction (PDFs are stored but flagged unsupported).
- No cloud sync and no network calls — the app is fully offline.

## Constraints

- Offline and local-only; no external services.
- Data persisted in `localStorage`, isolated per account.
