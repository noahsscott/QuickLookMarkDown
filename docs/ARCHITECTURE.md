# Architecture & Design Decisions

## Core Architecture
- **Type:** macOS App Extension (Quick Look Preview).
- **Hosting:** Run within a sandboxed `WKWebView` instance.
- **Security:** Offline-only. Network access blocked by default (though entitlements allow it, we don't use it).
- **Dependencies:**
  - `Down-gfm`: Markdown parsing (cmark-gfm based, but GFM extensions not enabled - see note below).
  - `highlight.js`: Syntax highlighting (embedded).
  - `Mermaid.js`: Diagram rendering (embedded).
  - `Tocbot`: Table of Contents (embedded).
  - `Temml`: Math/LaTeX rendering via MathML (embedded).

> **Note on Table Support:** Down-gfm was adopted to enable GFM tables, but the library's Swift wrapper uses `cmark_parse_document()` which bypasses cmark-gfm's extension system. Tables still render as plain text. A migration to marked.js is planned to resolve this.

## Implementation Decisions

### 1. WKWebView Instance Reuse (v0.5.1)
**Problem:** Memory leak causing linear growth O(N) relative to files previewed.

**Root Cause:** The QuickLook daemon reuses `QLPreviewingController` instances for performance. Each call to `preparePreviewOfFile` was creating a new `WKWebView` and adding it to the view hierarchy without removing the previous one.

**Solution:** Check if a `WKWebView` already exists before creating one:
- If exists: Load the new HTML content into the existing instance
- If nil: Create, configure, and add to view hierarchy

**Reference:** [Apple Developer Documentation: QLPreviewingController](https://developer.apple.com/documentation/quicklook/qlpreviewingcontroller)

### 2. Emoji Replacement Algorithm (v0.5.1)
**Problem:** O(N×M) time complexity where N = text length, M = number of shortcodes (~175).

**Root Cause:** Original implementation iterated through the entire emoji dictionary and called `replacingOccurrences(of:with:)` for every key, scanning the full string each time.

**Solution:** Regex-based single-pass replacement:
1. Compile pattern matching shortcode format: `:[a-z0-9_+-]+:`
2. Find all matches in input string
3. Look up each match in the dictionary
4. Replace only valid matches, iterating in reverse to preserve string indices

**Result:** O(N) time complexity - single pass through the text.

### 3. External Resource Loading (v0.6.0)
**Problem:** CSS and JavaScript stored as multi-thousand-line string literals in Swift, preventing proper syntax highlighting, linting, and maintainability.

**Solution:** Extract to external files in `MarkdownPreview/Resources/`:
- `style.css` - All styling including light/dark mode
- `highlight.min.js` - Syntax highlighting library
- `mermaid.min.js` - Diagram rendering
- `tocbot.min.js` - Table of Contents generation

**Loading Pattern:**
- Generate HTML with `<link>` and `<script>` tags referencing filenames
- Pass `Bundle.main.resourceURL` as `baseURL` when loading HTML into WKWebView
- WebKit resolves relative paths against the bundle URL

**Reference:** [WKWebView loadHTMLString(_:baseURL:)](https://developer.apple.com/documentation/webkit/wkwebview/1415004-loadhtmlstring)

## Technical Limitations & Research

### 1. Table of Contents Animation Delay
**Issue:** A ~300ms delay exists between clicking the TOC toggle button and the animation starting.
**Root Cause:** Inherent architectural limitation of `WKWebView` running in a Quick Look sandbox.
- **Details:** The delay is caused by Inter-Process Communication (IPC) overhead between the host process and the `WKWebView` process, compounded by "First Responder" restrictions in Quick Look.
- **Investigation:** Extensive testing (transform-based animations, GPU acceleration, JS optimization) confirmed this is not a code performance issue but a platform constraint.
- **Resolution:** Accepted as unavoidable. Implemented a 300ms `cubic-bezier` transition to mask the latency with a smooth animation.

### 2. Parked Feature: "Copy Code" Button
**Status:** Not Feasible / Parked.
**Reason:** 
- **No API Support:** Quick Look extensions are designed as read-only.
- **Clipboard Access:** While `NSPasteboard` works, bridging the click event from a sandboxed `WKWebView` to the native extension requires complex message handlers.
- **UX:** Not standard behavior for Quick Look previews.

### 3. Parked Feature: Auto-Refresh on File Change
**Status:** Not Feasible.
**Reason:**
- **Statelessness:** Quick Look extensions are "one-shot" generators. `preparePreviewOfFile` is called once.
- **No Refresh API:** There is no mechanism to tell the host Quick Look daemon to reload the view.
- **File Monitoring:** `FSEvents` is restricted in the sandbox.

### 4. Parked Feature: "Open in Editor" Button
**Status:** Not Feasible.
**Reason:**
- **Sandbox:** `NSWorkspace.shared.open()` is blocked. The extension cannot launch other applications.
- **Native Alternative:** macOS provides a native "Open with [Default App]" button in the Quick Look UI.

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
- `MarkdownService.replaceEmojiShortcodes()` - Verify emoji replacement logic
- HTML generation output - Validate structure, script/style inclusion
- Edge cases - Empty files, malformed markdown, special characters

**Limitation:** Testing the full rendering pipeline (WKWebView output) is difficult since it requires WebKit, which isn't easily unit-testable.

### Removing Test Targets
If removing test folders, do it through Xcode (right-click target → Delete) to properly update the `.pbxproj` file. Deleting folders without removing targets will cause build errors.
