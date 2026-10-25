# Focusly — Execution Plan (Roadmap)

## Guiding principles

- One small, verifiable step at a time; run `./verify.sh` after every step.
- Keep the app local-first; no backend, no dependencies without discussion.
- Prefer stability and safety over breadth.

## Product direction (2026-10-25)

The web app is the product. The `Focusly/` macOS shell stays in the repo but is not the target.

## Done

- AI-generated HTML notes import + in-app rendering (sandboxed iframe).
- `verify.sh` — headless JavaScriptCore harness + logic tests.
- Backup: export/import everything as one JSON file (Settings).
- Bug fixes: timer tick no longer re-renders the page or re-persists the whole workspace 4×/second; typing during a session is preserved; blur no longer auto-pauses (opt-in "Pause when I leave" setting); streak no longer resets every morning.
- AI generation (bring-your-own OpenAI-compatible key): AI notes + AI cards from materials, key/model configuration, connection test, sanitization for generated HTML.
- Look & feel: animated aurora background, page transitions, card lift, breathing timer ring, session-complete celebration, Reduce motion setting.

## Next (in order)

1. **SRS due queue** — reviews, deck badges, and the home "Next review" card should use `card.review.dueAt` (the scheduling math exists but is not honored yet). Deck CSV export too.
2. **Publish** — web app manifest + service worker (installable PWA), then deploy to GitHub Pages or Netlify.
3. **Dark-mode polish** — re-tint the remaining hardcoded light accents (goal ring, chips, native select).
4. **Plan ↔ session link** — "Start focus" on plan items so tracked time connects to the plan.
5. **(Later, highest risk)** split `app.js` into ES modules.
