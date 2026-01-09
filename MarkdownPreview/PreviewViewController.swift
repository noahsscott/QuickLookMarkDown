//
//  PreviewViewController.swift
//  MarkdownPreview
//
//  Created by Noah Scott on 8/1/2026.
//

import Cocoa
import Quartz
import WebKit
import Down

class PreviewViewController: NSViewController, QLPreviewingController {

    override var nibName: NSNib.Name? {
        return nil
    }

    override func loadView() {
        self.view = NSView()
    }

    func preparePreviewOfFile(at url: URL) async throws {
        // Read the markdown file
        let data = try Data(contentsOf: url)
        guard let markdownString = String(data: data, encoding: .utf8) else {
            throw NSError(domain: "MarkdownPreview", code: 1, userInfo: [NSLocalizedDescriptionKey: "Unable to decode file as UTF-8"])
        }

        // Render markdown to HTML
        let htmlString = try renderMarkdownToHTML(markdownString, baseURL: url.deletingLastPathComponent())

        // Create and configure WebView on main thread
        await MainActor.run {
            let webView = WKWebView()
            webView.translatesAutoresizingMaskIntoConstraints = false

            self.view.addSubview(webView)
            NSLayoutConstraint.activate([
                webView.topAnchor.constraint(equalTo: self.view.topAnchor),
                webView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                webView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                webView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
            ])

            webView.loadHTMLString(htmlString, baseURL: url.deletingLastPathComponent())
        }
    }

    private func renderMarkdownToHTML(_ markdown: String, baseURL: URL) throws -> String {
        let down = Down(markdownString: markdown)
        let htmlBody = try down.toHTML(.default)

        let css = """
        <style>
        /**
         * Apple macOS Markdown Style Stylesheet
         * Follows Apple Human Interface Guidelines
         * Supports light and dark modes
         * Uses San Francisco font family
         */

        :root {
          /* Light mode colours */
          --text-primary: #1d1d1f;
          --text-secondary: #86868b;
          --text-tertiary: #6e6e73;
          --link-color: #0066cc;
          --link-hover: #0077ed;
          --background: #ffffff;
          --background-secondary: #f5f5f7;
          --background-tertiary: #e8e8ed;
          --border-color: #d2d2d7;
          --code-background: #f5f5f7;
          --code-border: #e8e8ed;
          --blockquote-border: #0066cc;
          --table-header-bg: #f5f5f7;
          --table-border: #d2d2d7;
          --selection-bg: #b3d7ff;

          /* Syntax highlighting - light mode */
          --syntax-comment: #6e6e73;
          --syntax-keyword: #ad3da4;
          --syntax-string: #d12f1b;
          --syntax-function: #3e8087;
          --syntax-number: #272ad8;
          --syntax-operator: #1d1d1f;
          --syntax-constant: #804fb8;

          /* Spacing (Apple's 8pt grid system) */
          --spacing-xs: 4px;
          --spacing-sm: 8px;
          --spacing-md: 16px;
          --spacing-lg: 24px;
          --spacing-xl: 32px;
          --spacing-2xl: 48px;

          /* Typography scale */
          --font-size-xs: 11px;
          --font-size-sm: 13px;
          --font-size-base: 15px;
          --font-size-lg: 17px;
          --font-size-xl: 21px;
          --font-size-2xl: 26px;
          --font-size-3xl: 32px;
          --font-size-4xl: 40px;

          /* Line heights */
          --line-height-tight: 1.2;
          --line-height-normal: 1.47;
          --line-height-relaxed: 1.6;

          /* Border radius */
          --radius-sm: 4px;
          --radius-md: 6px;
          --radius-lg: 8px;
        }

        @media (prefers-color-scheme: dark) {
          :root {
            /* Dark mode colours */
            --text-primary: #f5f5f7;
            --text-secondary: #a1a1a6;
            --text-tertiary: #86868b;
            --link-color: #2997ff;
            --link-hover: #409cff;
            --background: #1d1d1f;
            --background-secondary: #2c2c2e;
            --background-tertiary: #3a3a3c;
            --border-color: #424245;
            --code-background: #2c2c2e;
            --code-border: #3a3a3c;
            --blockquote-border: #2997ff;
            --table-header-bg: #2c2c2e;
            --table-border: #424245;
            --selection-bg: #1e3a5f;

            /* Syntax highlighting - dark mode */
            --syntax-comment: #86868b;
            --syntax-keyword: #fc5fa3;
            --syntax-string: #fc6a5d;
            --syntax-function: #67b7a4;
            --syntax-number: #d0bf69;
            --syntax-operator: #f5f5f7;
            --syntax-constant: #d0a8ff;
          }
        }

        /* Base styles */
        body {
          font-family: -apple-system, BlinkMacSystemFont, "SF Pro Text", "Helvetica Neue", Helvetica, Arial, sans-serif;
          font-size: var(--font-size-base);
          line-height: var(--line-height-normal);
          color: var(--text-primary);
          background-color: var(--background);
          max-width: 720px;
          margin: 0 auto;
          padding: var(--spacing-2xl) var(--spacing-lg);
          -webkit-font-smoothing: antialiased;
          -moz-osx-font-smoothing: grayscale;
        }

        ::selection {
          background-color: var(--selection-bg);
        }

        /* Headings */
        h1, h2, h3, h4, h5, h6 {
          font-family: -apple-system, BlinkMacSystemFont, "SF Pro Display", "Helvetica Neue", Helvetica, Arial, sans-serif;
          font-weight: 600;
          line-height: var(--line-height-tight);
          margin-top: var(--spacing-xl);
          margin-bottom: var(--spacing-md);
          color: var(--text-primary);
          letter-spacing: -0.015em;
        }

        h1 {
          font-size: var(--font-size-4xl);
          font-weight: 700;
          margin-top: 0;
          margin-bottom: var(--spacing-lg);
          letter-spacing: -0.025em;
        }

        h2 {
          font-size: var(--font-size-3xl);
          margin-top: var(--spacing-2xl);
          padding-bottom: var(--spacing-sm);
          border-bottom: 1px solid var(--border-color);
        }

        h3 {
          font-size: var(--font-size-2xl);
        }

        h4 {
          font-size: var(--font-size-xl);
        }

        h5 {
          font-size: var(--font-size-lg);
        }

        h6 {
          font-size: var(--font-size-base);
          color: var(--text-secondary);
        }

        /* Paragraphs and text */
        p {
          margin-top: 0;
          margin-bottom: var(--spacing-md);
        }

        /* Links */
        a {
          color: var(--link-color);
          text-decoration: none;
          transition: color 0.15s ease;
        }

        a:hover {
          color: var(--link-hover);
          text-decoration: underline;
        }

        a:active {
          opacity: 0.7;
        }

        /* Strong and emphasis */
        strong, b {
          font-weight: 600;
          color: var(--text-primary);
        }

        em, i {
          font-style: italic;
        }

        /* Strikethrough */
        del, s {
          text-decoration: line-through;
          color: var(--text-secondary);
        }

        /* Inline code */
        code {
          font-family: "SF Mono", Monaco, "Cascadia Code", "Roboto Mono", Consolas, "Courier New", monospace;
          font-size: 0.92em;
          background-color: var(--code-background);
          border: 1px solid var(--code-border);
          border-radius: var(--radius-sm);
          padding: 2px 6px;
          color: var(--text-primary);
        }

        /* Code blocks */
        pre {
          font-family: "SF Mono", Monaco, "Cascadia Code", "Roboto Mono", Consolas, "Courier New", monospace;
          font-size: var(--font-size-sm);
          line-height: var(--line-height-relaxed);
          background-color: var(--code-background);
          border: 1px solid var(--code-border);
          border-radius: var(--radius-md);
          padding: var(--spacing-md);
          overflow-x: auto;
          margin: var(--spacing-md) 0;
        }

        pre code {
          background-color: transparent;
          border: none;
          padding: 0;
          font-size: inherit;
          border-radius: 0;
        }

        /* Syntax highlighting */
        .hljs-comment,
        .hljs-quote {
          color: var(--syntax-comment);
          font-style: italic;
        }

        .hljs-keyword,
        .hljs-selector-tag,
        .hljs-subst {
          color: var(--syntax-keyword);
          font-weight: 600;
        }

        .hljs-string,
        .hljs-title,
        .hljs-section,
        .hljs-attribute,
        .hljs-literal,
        .hljs-template-tag,
        .hljs-template-variable,
        .hljs-type {
          color: var(--syntax-string);
        }

        .hljs-function,
        .hljs-name,
        .hljs-selector-id,
        .hljs-selector-class {
          color: var(--syntax-function);
        }

        .hljs-number,
        .hljs-meta {
          color: var(--syntax-number);
        }

        .hljs-operator,
        .hljs-punctuation {
          color: var(--syntax-operator);
        }

        .hljs-built_in,
        .hljs-constant,
        .hljs-symbol {
          color: var(--syntax-constant);
        }

        /* Blockquotes */
        blockquote {
          margin: var(--spacing-lg) 0;
          padding-left: var(--spacing-lg);
          border-left: 4px solid var(--blockquote-border);
          color: var(--text-secondary);
          font-style: italic;
        }

        blockquote p {
          margin-bottom: var(--spacing-sm);
        }

        blockquote cite {
          display: block;
          margin-top: var(--spacing-sm);
          font-size: var(--font-size-sm);
          color: var(--text-tertiary);
          font-style: normal;
        }

        blockquote cite::before {
          content: "— ";
        }

        /* Lists */
        ul, ol {
          margin: var(--spacing-md) 0;
          padding-left: var(--spacing-lg);
        }

        ul ul, ul ol, ol ul, ol ol {
          margin: var(--spacing-xs) 0;
        }

        li {
          margin-bottom: var(--spacing-xs);
          line-height: var(--line-height-normal);
        }

        li > p {
          margin-bottom: var(--spacing-xs);
        }

        /* Task lists */
        ul.contains-task-list {
          list-style: none;
          padding-left: 0;
        }

        ul.contains-task-list li {
          padding-left: var(--spacing-lg);
          position: relative;
        }

        input[type="checkbox"] {
          position: absolute;
          left: 0;
          top: 4px;
          width: 16px;
          height: 16px;
          margin: 0;
          cursor: pointer;
          accent-color: var(--link-color);
        }

        /* Tables */
        table {
          width: 100%;
          border-collapse: collapse;
          margin: var(--spacing-lg) 0;
          font-size: var(--font-size-sm);
          border: 1px solid var(--table-border);
          border-radius: var(--radius-md);
          overflow: hidden;
        }

        thead {
          background-color: var(--table-header-bg);
        }

        th {
          font-weight: 600;
          text-align: left;
          padding: var(--spacing-sm) var(--spacing-md);
          border-bottom: 2px solid var(--table-border);
          color: var(--text-primary);
        }

        td {
          padding: var(--spacing-sm) var(--spacing-md);
          border-bottom: 1px solid var(--table-border);
        }

        tr:last-child td {
          border-bottom: none;
        }

        tbody tr:hover {
          background-color: var(--background-secondary);
        }

        /* Horizontal rule */
        hr {
          border: none;
          border-top: 1px solid var(--border-color);
          margin: var(--spacing-2xl) 0;
        }

        /* Images */
        img {
          max-width: 100%;
          height: auto;
          border-radius: var(--radius-lg);
          margin: var(--spacing-md) 0;
        }

        /* Definition lists */
        dl {
          margin: var(--spacing-md) 0;
        }

        dt {
          font-weight: 600;
          margin-top: var(--spacing-md);
          color: var(--text-primary);
        }

        dd {
          margin-left: var(--spacing-lg);
          margin-bottom: var(--spacing-sm);
          color: var(--text-secondary);
        }

        /* Abbreviations */
        abbr {
          text-decoration: underline dotted;
          cursor: help;
          border-bottom: 1px dotted var(--text-secondary);
        }

        /* Keyboard input */
        kbd {
          font-family: "SF Mono", Monaco, "Cascadia Code", "Roboto Mono", Consolas, "Courier New", monospace;
          font-size: 0.85em;
          background-color: var(--background-secondary);
          border: 1px solid var(--border-color);
          border-radius: var(--radius-sm);
          padding: 2px 6px;
          box-shadow: 0 1px 0 var(--border-color);
          display: inline-block;
          line-height: 1;
        }

        /* Sample output */
        samp {
          font-family: "SF Mono", Monaco, "Cascadia Code", "Roboto Mono", Consolas, "Courier New", monospace;
          font-size: 0.92em;
          background-color: var(--code-background);
          padding: 2px 6px;
          border-radius: var(--radius-sm);
        }

        /* Variable */
        var {
          font-family: "SF Mono", Monaco, "Cascadia Code", "Roboto Mono", Consolas, "Courier New", monospace;
          font-style: italic;
          color: var(--syntax-constant);
        }

        /* Mark/highlight */
        mark {
          background-color: rgba(255, 214, 10, 0.3);
          color: var(--text-primary);
          padding: 2px 4px;
          border-radius: var(--radius-sm);
        }

        @media (prefers-color-scheme: dark) {
          mark {
            background-color: rgba(255, 214, 10, 0.2);
          }
        }

        /* Subscript and superscript */
        sub, sup {
          font-size: 0.75em;
          line-height: 0;
          position: relative;
          vertical-align: baseline;
        }

        sup {
          top: -0.5em;
        }

        sub {
          bottom: -0.25em;
        }

        /* Footnotes */
        .footnotes {
          margin-top: var(--spacing-2xl);
          padding-top: var(--spacing-md);
          border-top: 1px solid var(--border-color);
          font-size: var(--font-size-sm);
          color: var(--text-secondary);
        }

        .footnotes ol {
          padding-left: var(--spacing-md);
        }

        /* Details/Summary */
        details {
          margin: var(--spacing-md) 0;
          padding: var(--spacing-md);
          background-color: var(--background-secondary);
          border: 1px solid var(--border-color);
          border-radius: var(--radius-md);
        }

        summary {
          cursor: pointer;
          font-weight: 600;
          user-select: none;
          color: var(--text-primary);
          margin: calc(-1 * var(--spacing-md));
          padding: var(--spacing-md);
          border-radius: var(--radius-md);
          transition: background-color 0.15s ease;
        }

        summary:hover {
          background-color: var(--background-tertiary);
        }

        details[open] summary {
          margin-bottom: var(--spacing-md);
          border-bottom: 1px solid var(--border-color);
          border-radius: var(--radius-md) var(--radius-md) 0 0;
        }

        /* Figure and figcaption */
        figure {
          margin: var(--spacing-lg) 0;
          text-align: center;
        }

        figcaption {
          margin-top: var(--spacing-sm);
          font-size: var(--font-size-sm);
          color: var(--text-secondary);
          font-style: italic;
        }

        /* Print styles */
        @media print {
          body {
            max-width: 100%;
            padding: 0;
            color: #000;
            background: #fff;
          }

          a {
            color: #000;
            text-decoration: underline;
          }

          a[href]::after {
            content: " (" attr(href) ")";
            font-size: 0.9em;
            color: #666;
          }

          pre, blockquote {
            page-break-inside: avoid;
            border: 1px solid #999;
          }

          thead {
            display: table-header-group;
          }

          tr, img {
            page-break-inside: avoid;
          }

          h1, h2, h3, h4, h5, h6 {
            page-break-after: avoid;
          }
        }

        /* Responsive adjustments */
        @media (max-width: 768px) {
          body {
            padding: var(--spacing-lg) var(--spacing-md);
            font-size: var(--font-size-sm);
          }

          h1 {
            font-size: var(--font-size-3xl);
          }

          h2 {
            font-size: var(--font-size-2xl);
          }

          h3 {
            font-size: var(--font-size-xl);
          }

          h4 {
            font-size: var(--font-size-lg);
          }

          pre {
            padding: var(--spacing-sm);
            font-size: var(--font-size-xs);
          }

          table {
            font-size: var(--font-size-xs);
          }

          th, td {
            padding: var(--spacing-xs) var(--spacing-sm);
          }
        }
        </style>
        """

        return """
        <!DOCTYPE html>
        <html>
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            \(css)
        </head>
        <body>
            \(htmlBody)
        </body>
        </html>
        """
    }
}
