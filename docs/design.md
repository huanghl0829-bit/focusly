# Focusly — Design Specification

## Architecture

A single native `WKWebView` wraps a client-side SPA. Native is a thin shell; all app behavior lives in `app.js`. A one-way native→JS bridge delivers lifecycle events.

## Screens (`.page` sections)

`home`, `plan`, `focus`, `flashcards`, `progress`, `notes`, `materials`, `settings` (see `pageTitles` in `app.js`). Plus the access gates `#auth-gate` and `#onboarding`, `<dialog>` modals (plan, deck, import, profile, history, timer-settings), and `#tutorial`.

## Data model (per-account state, `app.js`)

- `subjects[]` — `{ id, name, color, archived, … }`
- `resources[]` — `{ id, name, subject, type, size, text, extractionStatus, … }`
- `notes[]` — `{ id, subject, subjectId, title, content, source, generated, format? }`; `format: 'html'` marks an AI-imported HTML note.
- `decks[]` / `cards[]` — flashcards with spaced-repetition `review` state.
- `plans[]`, `sessions[]`, `goals[]`, `progress`, `preferences`, `profile`, `tutorial`.

## Rendering & state

- `renderApp()` re-renders all dashboards; `updateState(mutator)` mutates, persists (`persistState()`), and re-renders.
- Notes render via `noteMarkup()`: text notes as an editable `<textarea>`; HTML notes as a sandboxed `<iframe srcdoc>` with an Edit-HTML / Preview toggle.

## Styling

- CSS custom properties on `:root` (`--bg`, `--card`, `--ink`, `--blue`, …); theme via `data-theme` (`light` / `dark` / `system`).
- Reuse existing component classes (`.card`, `.button`, `.outlined-button`, `.editable-item`, `.row-actions`, `.button-row`).

## Security rules

- Always `escapeHtml()` user content before injecting into HTML.
- Render untrusted HTML only inside `<iframe sandbox="">`.
- No external scripts or resources.
