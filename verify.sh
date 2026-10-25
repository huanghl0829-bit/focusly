#!/bin/bash
# Focusly verification harness.
# Checks the app without opening a browser:
#   1. styles.css brace balance
#   2. index.html references the app files
#   3. app.js loads and boots in JavaScriptCore (with minimal browser stubs)
#   4. pure logic functions behave as expected
# Usage: ./verify.sh   (exit code 0 = everything passed)

set -uo pipefail
cd "$(dirname "$0")"

fail() { echo "✗ $1" >&2; exit 1; }

# --- 1. styles.css: balanced braces -----------------------------------------
open_braces=$(grep -o '{' styles.css | wc -l | tr -d ' ')
close_braces=$(grep -o '}' styles.css | wc -l | tr -d ' ')
[ "$open_braces" = "$close_braces" ] || fail "styles.css has unbalanced braces: $open_braces '{' vs $close_braces '}'"
echo "✓ styles.css braces balanced ($open_braces pairs)"

# --- 2. index.html: loads the app files --------------------------------------
grep -q 'src="app.js' index.html || fail 'index.html does not load app.js'
grep -q 'href="styles.css' index.html || fail 'index.html does not load styles.css'
echo "✓ index.html references app.js and styles.css"

# --- 3 + 4. JavaScriptCore: boot the app headless, then run logic tests ------
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

cat > "$TMP/stubs.js" <<'EOF'
/* Minimal browser stubs so app.js can boot headlessly in JavaScriptCore. */
function makeStubElement() {
  return {
    dataset: {},
    style: {},
    value: '',
    checked: false,
    textContent: '',
    innerHTML: '',
    options: [],
    classList: { add() {}, remove() {}, toggle() {}, contains() { return false; } },
    addEventListener() {}, removeEventListener() {},
    append() {}, remove() {}, focus() {}, click() {}, reset() {},
    showModal() {}, close() {},
    setAttribute() {}, getAttribute() { return null; },
    querySelector() { return makeStubElement(); },
    querySelectorAll() { return []; },
    closest() { return null; },
    setSelectionRange() {},
  };
}
var document = {
  addEventListener() {}, removeEventListener() {},
  querySelector() { return makeStubElement(); },
  querySelectorAll() { return []; },
  createElement() { return makeStubElement(); },
  body: makeStubElement(),
  documentElement: makeStubElement(),
  title: '',
  hidden: false,
  activeElement: null,
};
var window = {
  addEventListener() {}, removeEventListener() {},
  matchMedia() { return { matches: false, addEventListener() {}, addListener() {} }; },
  scrollTo() {},
  prompt() { return null; },
};
var navigator = { clipboard: null };
var localStorage = {
  _data: {},
  getItem(key) { return Object.prototype.hasOwnProperty.call(this._data, key) ? this._data[key] : null; },
  setItem(key, value) { this._data[key] = String(value); },
  removeItem(key) { delete this._data[key]; },
};
var setInterval = function () { return 1; };
var clearInterval = function () {};
var setTimeout = function () { return 1; };
var clearTimeout = function () {};
var crypto = {
  getRandomValues(arr) { for (var i = 0; i < arr.length; i += 1) arr[i] = Math.floor(Math.random() * 256); return arr; },
};
EOF

cat > "$TMP/tests.js" <<'EOF'
/* Logic tests for pure functions in app.js. */
var failures = [];
function check(name, actual, expected) {
  var pass = JSON.stringify(actual) === JSON.stringify(expected);
  if (!pass) failures.push(name + ': expected ' + JSON.stringify(expected) + ', got ' + JSON.stringify(actual));
}
check('escapeHtml escapes tags and quotes', escapeHtml('<b "x">'), '&lt;b &quot;x&quot;&gt;');
check('formatMinutes hours', formatMinutes(125), '2h 05m');
check('formatMinutes minutes only', formatMinutes(45), '45m');
check('todayKey formats a date', todayKey(new Date(2026, 9, 25)), '2026-10-25');
check('getWeekStart returns a Monday', new Date(getWeekStart(new Date(2026, 9, 21))).getDay(), 1);
check('parseImportedCards tab-separated', parseImportedCards('Q1\tA1\nQ2\tA2').length, 2);
check('parseImportedCards :: separated', parseImportedCards('What is ATP? :: energy currency')[0].answer, 'energy currency');
check('parseImportedCards comma-separated', parseImportedCards('front,back')[0].question, 'front');
check('formatFileSize kilobytes', formatFileSize(5000), '5 KB');
check('formatFileSize megabytes', formatFileSize(2.5 * 1024 * 1024), '2.5 MB');
var deck = normalizeDecks([{ id: 'd1', title: 'T', cards: [{ id: 'c1', question: 'q', answer: 'a' }] }])[0];
check('normalizeDecks fills review state', deck.cards[0].review.state, 'new');
check('normalizeDecks fills ease factor', deck.cards[0].review.easeFactor, 2.5);
check('getStreak empty workspace', getStreak(), 0);
check('sanitizeAiHtml strips shell tags', sanitizeAiHtml('<html><body><p>hi</p></body></html>'), '<p>hi</p>');
check('sanitizeAiHtml keeps useful markup', sanitizeAiHtml('<h3>T</h3><ul><li>x</li></ul>'), '<h3>T</h3><ul><li>x</li></ul>');
check('parseAiCards reads fenced JSON', parseAiCards('```json\n[{"question":"Q","answer":"A"}]\n```').length, 1);
check('parseAiCards reads plain array', parseAiCards('[{"question":"Q2","answer":"A2"}]')[0].answer, 'A2');
check('parseAiCards rejects junk', parseAiCards('no json here').length, 0);
check('sanitizeAiHtml removes script content', sanitizeAiHtml('<p>a</p><script>alert(1)</script>'), '<p>a</p>');
check('sanitizeAiHtml removes style content', sanitizeAiHtml('<style>.x{}</style><p>b</p>'), '<p>b</p>');
var srsDeck = normalizeDecks([{ id:'d', title:'T', cards:[
  { id:'c1', question:'a', answer:'b' },
  { id:'c2', question:'c', answer:'d', review:{ dueAt:new Date(Date.now() - 86400000).toISOString(), intervalDays:2, easeFactor:2.5, state:'review', reviewCount:1 } },
  { id:'c3', question:'e', answer:'f', review:{ dueAt:new Date(Date.now() + 9 * 86400000).toISOString(), intervalDays:9, easeFactor:2.5, state:'review', reviewCount:1 } }] }])[0];
check('dueCardsFor counts new + overdue only', dueCardsFor(srsDeck).length, 2);
check('dueCardsFor orders overdue before new', dueCardsFor(srsDeck)[0].id, 'c2');
check('previewInterval again', previewInterval(srsDeck.cards[0], 'again'), '10m');
check('previewInterval good for new card', previewInterval(srsDeck.cards[0], 'good'), '1d');
check('previewInterval easy for new card', previewInterval(srsDeck.cards[0], 'easy'), '4d');
check('previewInterval good grows interval', previewInterval(srsDeck.cards[1], 'good'), '5d');
if (failures.length) throw new Error('FAILED — ' + failures.join(' | '));
return 'VERIFY OK';
EOF

# Wrap everything in a function scope: osascript's JavaScriptCore predefines
# globals like `$` (the ObjC bridge), and top-level const/let in app.js may not
# shadow globals — inside a function they can.
{
  echo '(function(){'
  cat "$TMP/stubs.js" app.js "$TMP/tests.js"
  echo '})();'
} | osascript -l JavaScript > "$TMP/out.txt" 2>&1
result=$(cat "$TMP/out.txt")
status=$?
[ $status -eq 0 ] || fail "app.js did not load and boot cleanly in JavaScriptCore: $result"
echo "$result" | grep -q 'VERIFY OK' || fail "logic tests did not pass: $result"
echo "✓ app.js boots headless and all logic tests pass"

echo "All checks passed."
