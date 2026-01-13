# QuickLookMarkDown

A modern macOS Quick Look extension for rendering markdown files with beautiful Apple Human Interface Guidelines styling, syntax highlighting, GitHub-flavored emoji support, Mermaid diagrams, and interactive Table of Contents.

## Features

- **Interactive Table of Contents** - Fixed sidebar with smooth scrolling navigation and active link highlighting (v0.4.5 - In Progress)
- **Mermaid Diagrams** - Render flowcharts, sequence diagrams, Gantt charts, and more from text (v0.4.0)
- **Custom Apple HIG Styling** - Clean, native macOS look following Apple's design guidelines
- **Syntax Highlighting** - Code blocks support 40+ languages via embedded highlight.js v11.9.0
- **GitHub Emoji** - 130 curated emoji shortcodes (`:rocket:` → 🚀, `:bug:` → 🐛, `:heart:` → ❤️)
- **Light & Dark Mode** - Automatic theme switching with system appearance
- **Zero External Dependencies** - All styling and highlighting embedded offline
- **Completely Sandboxed** - Secure, native macOS App Extension

## Installation

### From Source

1. Clone the repository:
   ```bash
   git clone https://github.com/noahsscott/QuickLookMarkDown.git
   cd QuickLookMarkDown
   ```

2. Open in Xcode:
   ```bash
   open QuickLookMarkDown.xcodeproj
   ```

3. Build and run (⌘R) - This installs the extension

4. Test by selecting any `.md` file in Finder and pressing **Spacebar**

### Requirements

- macOS 10.13 (High Sierra) or later
- Xcode 14+ (for building from source)

## Usage

1. Run `QuickLookMarkDown.app` once to register the extension
2. In Finder, select any markdown file
3. Press **Spacebar** to preview

The extension automatically handles:
- Standard markdown (headings, lists, tables, blockquotes, code blocks)
- Interactive Table of Contents (auto-generated from headings with smooth navigation)
- Mermaid diagrams (flowcharts, sequence diagrams, Gantt charts, etc.)
- Syntax highlighted code blocks (JavaScript, Python, Swift, Java, Go, Rust, etc.)
- GitHub emoji shortcodes (`:tada:`, `:rocket:`, `:bug:`, and 127 more)

## Supported Emoji Shortcodes

Developer-specific: `:bug:` `:rocket:` `:construction:` `:wrench:` `:fire:` `:sparkles:` `:zap:`

Common reactions: `:+1:` `:heart:` `:tada:` `:clap:` `:pray:`

And many more! See `emoji-test.md` for a full list.

## Development

### Project Structure

```
QuickLookMarkDown/
├── QuickLookMarkDown/          # Host macOS app (minimal wrapper)
├── MarkdownPreview/            # The actual Quick Look extension
│   ├── PreviewViewController.swift  # Main rendering logic
│   ├── Info.plist              # Supported file types
│   └── MarkdownPreview.entitlements
└── dev-notes/                  # Documentation
    ├── handover.md             # Technical deep-dive
    ├── todo.md                 # Roadmap and session notes
    └── claude-code-guidelines.md
```

### Building

```bash
# Clean build
xcodebuild -scheme QuickLookMarkDown clean build

# Run and register extension
open ~/Library/Developer/Xcode/DerivedData/QuickLookMarkDown-*/Build/Products/Debug/QuickLookMarkDown.app

# Test with command line
qlmanage -p test.md
```

### Troubleshooting

If the extension doesn't load:

```bash
# Reset QuickLook cache
pkill -9 quicklookd
qlmanage -r
qlmanage -r cache

# Verify extension is registered
pluginkit -m -v -p com.apple.quicklook.preview | grep QuickLookMarkDown
```

See `dev-notes/handover.md` for detailed troubleshooting.

## Technical Details

- **Markdown Rendering**: Down library (CommonMark spec)
- **Syntax Highlighting**: highlight.js v11.9.0 (embedded, 119KB)
- **Emoji Database**: 130 curated shortcuts (embedded, ~15KB)
- **Mermaid Diagrams**: Mermaid.js v11 (embedded, ~3.5MB)
- **Table of Contents**: Tocbot v4.25.0 (embedded, ~11KB)
- **Rendering**: WKWebView with custom CSS
- **Bundle ID**: `com.markdownquicklook.QuickLookMarkDown.MarkdownPreview`

## Version History

- **v0.4.5** (2026-01-13) - WIP: Table of Contents with toggle, reduced width, improved spacing (incomplete)
- **v0.4.0** (2026-01-12) - Added Mermaid diagram support (10+ diagram types)
- **v0.3.0** (2026-01-11) - Added emoji shortcode support (130 GitHub emoji)
- **v0.2.0** (2026-01-11) - Added syntax highlighting for 40+ languages
- **v0.1.0** (2026-01-09) - Initial release with Apple HIG styling

## Roadmap

See `dev-notes/todo.md` for detailed roadmap.

**Should-Have:**
- Complete Table of Contents UX refinements (v0.4.5 → v0.5.0)
- Font size controls

**Nice-to-Have:**
- Math expression support (LaTeX/MathJax)
- YAML front matter display
- Custom themes
- App Store distribution

## Contributing

This project welcomes contributions! See `dev-notes/claude-code-guidelines.md` for development guidelines.

## License

[Add your license here]

## Acknowledgments

- Markdown parsing: [Down](https://github.com/johnxnguyen/Down)
- Syntax highlighting: [highlight.js](https://highlightjs.org/)
- Emoji data: [GitHub's gemoji](https://github.com/github/gemoji)
- Diagram rendering: [Mermaid.js](https://mermaid.js.org/)
- Table of Contents: [Tocbot](https://tscanlin.github.io/tocbot/)
- Built with assistance from [Claude Code](https://claude.com/claude-code)
