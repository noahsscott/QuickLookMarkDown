# Architecture & Design Decisions

## Core Architecture
- **Type:** macOS App Extension (Quick Look Preview).
- **Hosting:** Run within a sandboxed `WKWebView` instance.
- **Security:** Offline-only. The `com.apple.security.network.client` entitlement is required by WKWebView (Apple limitation, FB6993802) but no network requests are made. HTML output is sanitised via DOMPurify.
- **Dependencies:**
  - `marked.js`: Markdown parsing with full GFM support (client-side JavaScript).
  - `highlight.js`: Syntax highlighting (embedded).
  - `DOMPurify`: HTML sanitisation of rendered markdown output (embedded).
  - `Mermaid.js`: Diagram rendering (embedded, conditionally loaded).
  - `Tocbot`: Table of Contents (embedded).
  - `Temml`: Math/LaTeX rendering via MathML (embedded).

## Implementation Decisions

### 1. WKWebView Instance Reuse (v0.5.1)
**Problem:** Memory leak causing linear growth O(N) relative to files previewed.

**Root Cause:** The QuickLook daemon reuses `QLPreviewingController` instances for performance. Each call to `preparePreviewOfFile` was creating a new `WKWebView` and adding it to the view hierarchy without removing the previous one.

**Solution:** Check if a `WKWebView` already exists before creating one:
- If exists: Load the new HTML content into the existing instance
- If nil: Create, configure, and add to view hierarchy

**Reference:** [Apple Developer Documentation: QLPreviewingController](https://developer.apple.com/documentation/quicklook/qlpreviewingcontroller)

### 2. Emoji Replacement Algorithm (v0.5.1 → v0.7.0)
**Original Problem (v0.5.1):** O(N×M) time complexity where N = text length, M = number of shortcodes.

**Original Solution (Swift):** Regex-based single-pass replacement iterating in reverse to preserve string indices.

**Current Implementation (v0.7.0+):** Moved to client-side JavaScript as part of marked.js migration:
1. Regex pattern `/:[a-zA-Z0-9_+-]+:/g` matches all shortcodes in one pass
2. Replace callback looks up each match in dictionary object
3. O(N) time complexity with hash table lookups

**Benefit:** Unified processing pipeline - emoji replacement happens before markdown parsing, both in JavaScript.

### 3. External Resource Loading (v0.6.0)
**Problem:** CSS and JavaScript stored as multi-thousand-line string literals in Swift, preventing proper syntax highlighting, linting, and maintainability.

**Solution:** Extract to external files in `MarkdownPreview/Resources/`:
- `style.css` - All styling including light/dark mode
- `marked.min.js` - Markdown parsing (GFM)
- `highlight.min.js` - Syntax highlighting library
- `purify.min.js` - DOMPurify HTML sanitisation
- `mermaid.min.js` - Diagram rendering (conditionally loaded)
- `tocbot.min.js` - Table of Contents generation
- `temml.min.js`, `Temml-Local.css`, `Temml.woff2` - Math/LaTeX rendering

**Loading Pattern:**
- Read resource files from bundle at runtime using `Bundle.url(forResource:withExtension:)`
- Resources cached in memory after first load (`CachedResources` struct) — eliminates redundant disk reads when QuickLook reuses the controller instance
- Embed CSS and JavaScript directly in HTML template via `<style>` and `<script>` tags
- Self-contained HTML string loaded into WKWebView (no external file references)

### 4. Security Hardening (Pre-Publication Audit)
**Context:** Pre-publication review identified several XSS vectors and configuration issues.

**Changes Made:**
1. **Front matter rendering** — Replaced HTML string concatenation with DOM API (`textContent`). User-controlled YAML values are never interpreted as HTML.
2. **Error fallback pages** — Added `String.escapedForHTML` extension in Swift. Raw markdown content is HTML-escaped before embedding in error pages.
3. **marked.js output sanitisation** — `marked.parse()` output wrapped with `DOMPurify.sanitize()`. marked.js intentionally does not sanitise (by design); DOMPurify provides defense-in-depth.
4. **Mermaid securityLevel** — Changed from `'loose'` to `'strict'` (default since Mermaid v8.2). Only disables click callbacks, which are not used in documentation markdown.
5. **UTI scope** — Removed `public.plain-text` from `QLSupportedContentTypes`. Extension now only claims markdown-specific UTIs to avoid hijacking previews for all text files.

**Rationale:** Even though the WKWebView runs in a sandbox, the required `com.apple.security.network.client` entitlement means malicious JavaScript could exfiltrate previewed file contents. Defense-in-depth is the standard approach (OWASP).

**Network Entitlement Note:** `com.apple.security.network.client` cannot be removed — WKWebView requires it even for `loadHTMLString` with self-contained HTML due to its out-of-process architecture (Apple bug FB6993802).

## Technical Limitations & Research

### 1. Table of Contents Display Threshold
**Logic:** TOC only appears on longer documents to avoid clutter on short files.

**Conditions (either triggers TOC):**
- 1000+ words AND 3+ headings (h1-h3)
- 3000+ words (regardless of heading count)

**Implementation:** `MarkdownService.swift` calculates word count and heading count after rendering, then conditionally shows TOC elements.

### 2. Table of Contents Animation Delay
**Issue:** A ~300ms delay exists between clicking the TOC toggle button and the animation starting.
**Root Cause:** Inherent architectural limitation of `WKWebView` running in a Quick Look sandbox.
- **Details:** The delay is caused by Inter-Process Communication (IPC) overhead between the host process and the `WKWebView` process, compounded by "First Responder" restrictions in Quick Look.
- **Investigation:** Extensive testing (transform-based animations, GPU acceleration, JS optimization) confirmed this is not a code performance issue but a platform constraint.
- **Resolution:** Accepted as unavoidable. Implemented a 300ms `cubic-bezier` transition to mask the latency with a smooth animation.

### 3. Parked Feature: "Copy Code" Button
**Status:** Not Feasible / Parked.
**Reason:** 
- **No API Support:** Quick Look extensions are designed as read-only.
- **Clipboard Access:** While `NSPasteboard` works, bridging the click event from a sandboxed `WKWebView` to the native extension requires complex message handlers.
- **UX:** Not standard behavior for Quick Look previews.

### 4. Parked Feature: Auto-Refresh on File Change
**Status:** Not Feasible.
**Reason:**
- **Statelessness:** Quick Look extensions are "one-shot" generators. `preparePreviewOfFile` is called once.
- **No Refresh API:** There is no mechanism to tell the host Quick Look daemon to reload the view.
- **File Monitoring:** `FSEvents` is restricted in the sandbox.

### 5. Parked Feature: "Open in Editor" Button
**Status:** Not Feasible.
**Reason:**
- **Sandbox:** `NSWorkspace.shared.open()` is blocked. The extension cannot launch other applications.
- **Native Alternative:** macOS provides a native "Open with [Default App]" button in the Quick Look UI.

### 6. Parked Feature: Font Size Controls
**Status:** Parked - keyboard shortcuts not feasible, UI buttons possible but deferred.

**Investigation Findings:**
- **Keyboard Focus:** QuickLook does not give keyboard focus to embedded WKWebView. Even clicking inside the preview does not transfer focus. All keyboard input goes to the QuickLook window frame, resulting in the system "sosumi" error sound.
- **JavaScript Listeners:** Standard `keydown` event listeners in the WebView work correctly when focused, but focus cannot be obtained in the QuickLook context.
- **Responder Chain:** The `QLPreviewingController` is not part of the macOS responder chain. Apple explicitly discourages manually injecting it.

**Future Implementation Options:**
1. **On-screen +/- buttons** - Most reliable approach, same pattern as TOC toggle. Would add small buttons to corner of preview.
2. **Mouse wheel + Cmd gesture** - Cmd+scroll to zoom. Gesture events may work where keyboard events don't.
3. **Host app settings UI** - Set font scale once in host app preferences, persisted via UserDefaults + App Groups. Requires entitlement configuration.

**Technical Notes (for future implementation):**
- CSS already uses custom properties (`--font-size-base`, etc.) - easy to scale via JavaScript
- localStorage works in QuickLook sandbox (confirmed by TOC state persistence)
- Scale range 70%-160% with 10% steps recommended

## Testing Considerations

### Test Folder Status
The `QuickLookMarkDownTests/` and `QuickLookMarkDownUITests/` folders contain Xcode-generated placeholder files with no implemented tests. They exist as scaffolding for future use.

### UI Tests: Not Useful
**Why:** UI tests use `XCUIApplication` to launch and interact with an app's interface. For this project:
- The host app (`QuickLookMarkDown.app`) is an empty shell with no meaningful UI
- The actual extension runs inside the QuickLook daemon, not as a standalone app
- There's no way to programmatically trigger Quick Look previews via XCUITest

**Recommendation:** UI tests provide no value for Quick Look extensions. Keep the placeholder or delete via Xcode if desired.

### Unit Tests: Potentially Useful
**What could be tested:**
- `MarkdownService.renderMarkdownToHTML()` - Verify HTML template generation
- HTML generation output - Validate structure, script/style inclusion
- Edge cases - Empty files, special characters, JSON escaping

**Limitation:** Testing the full rendering pipeline (WKWebView output) is difficult since it requires WebKit, which isn't easily unit-testable.

### Removing Test Targets
If removing test folders, do it through Xcode (right-click target → Delete) to properly update the `.pbxproj` file. Deleting folders without removing targets will cause build errors.
