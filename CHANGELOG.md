# Changelog

## [Unreleased]
### Added
- YAML front matter display - metadata at top of markdown files shown in styled box
  - Parses `---` delimited YAML at document start
  - Displays key-value pairs in Apple-styled metadata box
  - Supports inline arrays `[a, b, c]`
  - Does not affect TOC (uses div elements, not headings)
- DOMPurify 3.3.1 (`purify.min.js`) for HTML sanitisation of rendered markdown output

### Security
- Fixed XSS in front matter rendering — switched from string concatenation to DOM API (`textContent`)
- Fixed XSS in error fallback pages — added HTML escaping for raw markdown content
- Sanitised `marked.parse()` output with `DOMPurify.sanitize()` (defense in depth)
- Changed Mermaid.js `securityLevel` from `'loose'` to `'strict'` (disables click callbacks, prevents script injection)

### Fixed
- Task list checkboxes no longer detach to top-left corner in narrow Finder preview pane — replaced absolute positioning with inline flow
- Front matter values no longer overflow box boundary at narrow widths — added word-break and min-width fix

### Changed
- Enhanced `test-extension.sh` to accept optional file argument and `--list` flag
- Mermaid.js now loads conditionally - 2.6MB library only included when document contains diagrams (89% JS reduction for non-diagram files)
- `QLSupportedContentTypes` narrowed from `public.plain-text` (all text files) to markdown-specific UTIs (`net.daringfireball.markdown`, `public.markdown`, `com.unknown.md`)
- Bundle resources (CSS/JS) now cached after first load — eliminates redundant disk reads on subsequent previews

### Removed
- Deleted unused `Resources.swift` (177 lines) - emoji dictionary was superseded by JavaScript implementation in v0.7.0
- Deleted unused `PreviewProvider.swift` - Xcode template file not referenced by extension

## [v0.7.1] - 2026-01-21
### Added
- `test-extension.sh` script for simplified deploy/test workflow

### Fixed
- TOC now hidden by default in CSS, shown via JS only when threshold met (prevents flash on short documents)
- Task list checkbox styling now works with marked.js output (not just GitHub-style classes)

## [v0.7.0] - 2026-01-21
### Added
- Math/LaTeX support via Temml library
  - Inline math with `$...$` delimiters
  - Display/block math with `$$...$$` delimiters
  - Native MathML rendering in WebKit (lightweight ~180KB)
  - Added `temml.min.js`, `Temml-Local.css`, `Temml.woff2` to Resources
- Test files for math (`math-test.md`) and tables (`table-test.md`)
- **GFM table support** now works correctly with marked.js

### Changed
- **Migrated markdown parser from Down-gfm to marked.js**
  - Resolves table rendering issue (Down-gfm didn't enable cmark-gfm extensions)
  - Client-side JavaScript parsing via marked.js v15.0.12
  - Full GFM support: tables, strikethrough, task lists, autolinks
  - Emoji shortcode replacement moved from Swift to JavaScript
  - Removed Down-gfm Swift package dependency
- Updated `dev-notes/llm-guidelines.md` with versioning and release workflow documentation

## [v0.6.1] - 2026-01-20
### Added
- MIT License file

### Changed
- Updated README for development use (removed end-user installation instructions, added build & test protocol)

## [v0.6.0] - 2026-01-20
### Resource Architecture Refactor
- Extracted CSS and JavaScript from inline strings to external bundle files
- Added `MarkdownPreview/Resources/` directory with `style.css`, `highlight.min.js`, `mermaid.min.js`, `tocbot.min.js`
- Updated `MarkdownService` to load resources from bundle using `baseURL` pattern
- Cleaned up `Resources.swift` to contain only emoji shortcode dictionary
- Improved maintainability: syntax highlighting and proper tooling now available for CSS/JS files

## [v0.5.1] - 2026-01-20
### Fixed
- Fixed memory leak: `WKWebView` instances now reused instead of recreated on each preview
- Optimized emoji replacement: O(N×M) loop replaced with O(N) regex-based approach
- Improved extension stability for rapid file navigation in Finder

## [v0.5.0] - 2026-01-16
### Refactor architecture and consolidate documentation
- Split monolithic PreviewViewController into MarkdownService and Resources
- Create MarkdownPreview/Resources.swift for static assets (JS/CSS)
- Create MarkdownPreview/MarkdownService.swift for logic
- Add docs/ARCHITECTURE.md and CHANGELOG.md
- Update README.md with comprehensive project info
- Clean up dev-notes and organize test files

## [v0.4.9] - 2026-01-16
### Fixed
- Fix initial load animation glitch using preload class and requestAnimationFrame
- Adjust toggle button alignment (centered on border)
- Prevent auto-open on small preview windows (>700px width requirement)
- Add SVG source file for navigation icon
- Add new formatting stress test and image test files
- Remove obsolete test files
- Update documentation and todo lists

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
