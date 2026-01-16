# QuickLookMarkDown

A modern, fast, and feature-rich Quick Look extension for macOS that renders Markdown files with beautiful typography, syntax highlighting, Mermaid diagrams, and interactive navigation.

![Banner](https://github.com/noahsscott/QuickLookMarkDown/raw/main/assets/banner.png) *(Note: Placeholder for screenshot)*

## Features

-   **Apple Human Interface Guidelines Styling:** Native look and feel with full Light/Dark mode support.
-   **Syntax Highlighting:** Supports 40+ programming languages (Swift, Python, JS, Rust, Go, etc.) via `highlight.js`.
-   **Mermaid Diagrams:** Renders Flowcharts, Sequence diagrams, Gantt charts, and more directly within Quick Look.
-   **Smart Table of Contents:** Automatically generates a floating, interactive TOC for long documents (>1000 words).
-   **Emoji Support:** Renders GitHub-flavored emoji shortcodes (`:rocket:` → 🚀).
-   **Privacy Focused:** Completely offline and sandboxed. Zero external network requests.

## Installation

### Prerequisites
-   macOS 12.0 (Monterey) or later recommended.
-   Xcode 16+ (to build from source).

### Build from Source
1.  Clone the repository:
    ```bash
    git clone https://github.com/noahsscott/QuickLookMarkDown.git
    ```
2.  Open `QuickLookMarkDown.xcodeproj` in Xcode.
3.  Select the **QuickLookMarkDown** scheme (host app).
4.  Build and Run (`Cmd+R`).
5.  Close the app window. The extension is now installed.

### Troubleshooting
If the preview doesn't appear or shows an old version:
1.  Run the host app once to register the extension.
2.  Restart the QuickLook daemon:
    ```bash
    pkill -9 quicklookd
    ```
3.  Select a markdown file and press Spacebar.

## Project Structure

-   `QuickLookMarkDown/`: Host macOS app (required wrapper).
-   `MarkdownPreview/`: The core Quick Look extension.
    -   `PreviewViewController.swift`: Main view controller.
    -   `MarkdownService.swift`: Markdown processing and HTML generation.
    -   `Resources.swift`: Embedded JS/CSS assets.

## License

[Add License Here]
