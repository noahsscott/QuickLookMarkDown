# QuickLookMarkDown

A modern Quick Look extension for macOS that renders Markdown files with beautiful typography, syntax highlighting, Mermaid diagrams, and interactive navigation.

> **Note:** This project is in active development and not yet released for public use.

## Features

- **Apple Human Interface Guidelines Styling:** Native look and feel with full Light/Dark mode support.
- **Syntax Highlighting:** Supports 40+ programming languages (Swift, Python, JS, Rust, Go, etc.) via `highlight.js`.
- **Mermaid Diagrams:** Renders Flowcharts, Sequence diagrams, Gantt charts, and more directly within Quick Look.
- **Smart Table of Contents:** Automatically generates a floating, interactive TOC for long documents (>1000 words).
- **Emoji Support:** Renders GitHub-flavored emoji shortcodes (`:rocket:` → 🚀).
- **Privacy Focused:** Completely offline and sandboxed. Zero external network requests.

## Development Setup

### Requirements
- macOS 12.0 (Monterey) or later
- Xcode 16+

### Building
1. Clone the repository
2. Open `QuickLookMarkDown.xcodeproj` in Xcode
3. Select the **QuickLookMarkDown** scheme
4. Build and Run (`Cmd+R`)
5. Close the app window — the extension is now registered

### Testing Changes
After modifying extension code, run the full build & test protocol:
```bash
xcodebuild -project QuickLookMarkDown.xcodeproj -scheme QuickLookMarkDown -configuration Debug clean build && \
pkill -9 quicklookd && pkill -9 QuickLookUIService && killall Finder && sleep 3 && \
open ~/Library/Developer/Xcode/DerivedData/QuickLookMarkDown-*/Build/Products/Debug/QuickLookMarkDown.app && sleep 4 && \
pkill QuickLookMarkDown && pkill -9 quicklookd && sleep 2 && \
qlmanage -p your-file.md
```

## Project Structure

- `QuickLookMarkDown/` — Host macOS app (required wrapper)
- `MarkdownPreview/` — The core Quick Look extension
  - `PreviewViewController.swift` — Main view controller
  - `MarkdownService.swift` — Markdown processing and HTML generation
  - `Resources/` — CSS and JavaScript assets

## License

[MIT](LICENSE)
