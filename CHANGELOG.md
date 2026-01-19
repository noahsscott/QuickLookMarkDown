# Changelog

## [v0.5.0] - 2026-01-16 - 
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
