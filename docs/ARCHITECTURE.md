# Architecture & Design Decisions

## Core Architecture
- **Type:** macOS App Extension (Quick Look Preview).
- **Hosting:** Run within a sandboxed `WKWebView` instance.
- **Security:** Offline-only. Network access blocked by default (though entitlements allow it, we don't use it).
- **Dependencies:** 
  - `Down`: Markdown parsing.
  - `highlight.js`: Syntax highlighting (embedded).
  - `Mermaid.js`: Diagram rendering (embedded).
  - `Tocbot`: Table of Contents (embedded).

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
