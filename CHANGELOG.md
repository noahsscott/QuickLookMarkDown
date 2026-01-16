# Changelog

## [v0.4.9] - 2026-01-16
### Changed
- Refactored `PreviewViewController` monolithic class into `MarkdownService` and `Resources`.
- Consolidated documentation.
- Improved TOC animation and responsiveness.
- 
 Refactoring & Consolidation Plan (in prep for v0.5.0+) - COMPLETED
**Objective:** Deconstruct the `PreviewViewController.swift` monolith, consolidate documentation, and establish a clean architecture for future development.
 Phase 1: The Monolith Breakup
**Goal:** Split `PreviewViewController.swift` into logical components to improve readability and maintainability without altering functionality.
- [x] **1. Create `MarkdownPreview/Resources.swift`**
    - [x] Create file in Xcode structure (same target).
    - [x] Extract `highlightJS` (100KB+ string).
    - [x] Extract `mermaidJS` (3.5MB+ string).
    - [x] Extract `tocbotJS` string.
    - [x] Extract `css` string (Apple HIG styles).
    - [x] Verification: Project builds.

- [x] **2. Create `MarkdownPreview/MarkdownService.swift`**
    - [x] Create file.
    - [x] Move `Down` library rendering logic here.
    - [x] Move Emoji processing/replacement logic here.
    - [x] Move HTML template construction (injecting CSS/JS) here.
    - [x] Define clean interface: `func generateHTML(from url: URL) -> String`.

- [x] **3. Clean `PreviewViewController.swift`**
    - [x] Remove extracted code.
    - [x] Refactor `preparePreviewOfFile` to use `MarkdownService`.
    - [x] Retain only View Lifecycle (WKWebView setup, navigation delegate) and User Interaction logic.

- [x] **4. Verify Phase 1**
    - [x] **CRITICAL:** Execute Verification Protocol (Kill quicklookd -> Reset Cache -> Run Host App).
    - [x] Test rendering of `test-files/md-all-styles-test.md`.

## Phase 2: Documentation Consolidation
**Goal:** Separate public documentation from internal development notes.

- [x] **1. Create Public Documentation**
    - [x] Create `README.md` (root):
        - Source: `dev-notes/handover.md` (Overview, Features).
        - Add Installation/Usage instructions.
    - [x] Create `CHANGELOG.md` (root):
        - Source: Version history from `handover.md` and `todo.md`.

- [x] **2. Archive Technical Context**
    - [x] Create `docs/` directory.
    - [x] Create `docs/ARCHITECTURE.md`:
        - Source: `dev-notes/toc-development.md` (The "Why TOC is 300ms delayed" research).
        - Source: `dev-notes/todo.md` (Parked features: Copy Button, Auto-Refresh research).

- [x] **3. Internal Context Cleanup**
    - [x] Keep `dev-notes/claude-code-guidelines.md` (The "Prime Directive").
    - [x] Update `dev-notes/todo.md`:
        - Remove completed items.
        - Add "Add License" to todo list.
        - Link to new `ARCHITECTURE.md` for deep dives.
    - [x] Archive/Delete `dev-notes/handover.md` (content moved to README).
    - [x] Archive/Delete `dev-notes/toc-development.md` (content moved to ARCHITECTURE).

## Phase 3: Final Verification
**Goal:** Ensure the project state is clean and ready for v0.5.x or v1.0.

- [x] **1. Build Verification**
    - [x] Clean Build Folder (`Cmd+Shift+K`).
    - [x] Build (`Cmd+B`).
- [x] **2. Functional Verification**
    - [x] Run `scripts/update-extension.sh` (or manual protocol).
    - [x] Verify standard Markdown rendering.
    - [x] Verify Mermaid diagrams.
    - [x] Verify TOC functionality.

## [v0.4.8] - 2026-01-15
### Fixed
- Fixed TOC heading styling (H1/H2 bold+white, H3 grey).
- Removed H2 underlines from body content.

## [v0.4.7] - 2026-01-14
### Changed
- Reverted TOC animation to position-based for better layout reflow.
- Fixed body content cropping issue.
- Implemented cubic-bezier easing for smooth drawer animation.

## [v0.4.6] - 2026-01-13
### Added
- Smart TOC generation: Only shows TOC for long documents (1000+ words/3+ headings or 3000+ words).

## [v0.4.5] - 2026-01-13
### Added
- Initial Table of Contents implementation (Tocbot).
- Sidebar toggle button and responsive layout.

## [v0.4.0] - 2026-01-12
### Added
- Mermaid.js diagram support.

## [v0.3.0] - 2026-01-11
### Added
- Emoji shortcode support.

## [v0.2.0] - 2026-01-11
### Added
- Syntax highlighting (highlight.js).

## [v0.1.0] - 2026-01-09
### Added
- Initial release with Apple HIG styling.
