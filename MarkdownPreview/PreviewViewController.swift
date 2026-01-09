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
        .markdown-body {
          --base-size-4: 0.25rem;
          --base-size-8: 0.5rem;
          --base-size-16: 1rem;
          --base-size-24: 1.5rem;
          --base-size-40: 2.5rem;
          --base-text-weight-normal: 400;
          --base-text-weight-medium: 500;
          --base-text-weight-semibold: 600;
          --fontStack-monospace: ui-monospace, SFMono-Regular, SF Mono, Menlo, Consolas, Liberation Mono, monospace;
          --fgColor-accent: Highlight;
        }
        @media (prefers-color-scheme: dark) {
          .markdown-body, [data-theme="dark"] {
            color-scheme: dark;
            --focus-outlineColor: #1f6feb;
            --fgColor-default: #f0f6fc;
            --fgColor-muted: #9198a1;
            --fgColor-accent: #4493f8;
            --fgColor-success: #3fb950;
            --fgColor-attention: #d29922;
            --fgColor-danger: #f85149;
            --fgColor-done: #ab7df8;
            --bgColor-default: #0d1117;
            --bgColor-muted: #151b23;
            --bgColor-neutral-muted: #656c7633;
            --bgColor-attention-muted: #bb800926;
            --borderColor-default: #3d444d;
            --borderColor-muted: #3d444db3;
            --borderColor-neutral-muted: #3d444db3;
            --borderColor-accent-emphasis: #1f6feb;
            --borderColor-success-emphasis: #238636;
            --borderColor-attention-emphasis: #9e6a03;
            --borderColor-danger-emphasis: #da3633;
            --borderColor-done-emphasis: #8957e5;
            --color-prettylights-syntax-comment: #9198a1;
            --color-prettylights-syntax-constant: #79c0ff;
            --color-prettylights-syntax-constant-other-reference-link: #a5d6ff;
            --color-prettylights-syntax-entity: #d2a8ff;
            --color-prettylights-syntax-storage-modifier-import: #f0f6fc;
            --color-prettylights-syntax-entity-tag: #7ee787;
            --color-prettylights-syntax-keyword: #ff7b72;
            --color-prettylights-syntax-string: #a5d6ff;
            --color-prettylights-syntax-variable: #ffa657;
            --color-prettylights-syntax-brackethighlighter-unmatched: #f85149;
            --color-prettylights-syntax-brackethighlighter-angle: #9198a1;
            --color-prettylights-syntax-invalid-illegal-text: #f0f6fc;
            --color-prettylights-syntax-invalid-illegal-bg: #8e1519;
            --color-prettylights-syntax-carriage-return-text: #f0f6fc;
            --color-prettylights-syntax-carriage-return-bg: #b62324;
            --color-prettylights-syntax-string-regexp: #7ee787;
            --color-prettylights-syntax-markup-list: #f2cc60;
            --color-prettylights-syntax-markup-heading: #1f6feb;
            --color-prettylights-syntax-markup-italic: #f0f6fc;
            --color-prettylights-syntax-markup-bold: #f0f6fc;
            --color-prettylights-syntax-markup-deleted-text: #ffdcd7;
            --color-prettylights-syntax-markup-deleted-bg: #67060c;
            --color-prettylights-syntax-markup-inserted-text: #aff5b4;
            --color-prettylights-syntax-markup-inserted-bg: #033a16;
            --color-prettylights-syntax-markup-changed-text: #ffdfb6;
            --color-prettylights-syntax-markup-changed-bg: #5a1e02;
            --color-prettylights-syntax-markup-ignored-text: #f0f6fc;
            --color-prettylights-syntax-markup-ignored-bg: #1158c7;
            --color-prettylights-syntax-meta-diff-range: #d2a8ff;
            --color-prettylights-syntax-sublimelinter-gutter-mark: #3d444d;
          }
        }
        @media (prefers-color-scheme: light) {
          .markdown-body, [data-theme="light"] {
            color-scheme: light;
            --focus-outlineColor: #0969da;
            --fgColor-default: #1f2328;
            --fgColor-muted: #59636e;
            --fgColor-accent: #0969da;
            --fgColor-success: #1a7f37;
            --fgColor-attention: #9a6700;
            --fgColor-danger: #d1242f;
            --fgColor-done: #8250df;
            --bgColor-default: #ffffff;
            --bgColor-muted: #f6f8fa;
            --bgColor-neutral-muted: #818b981f;
            --bgColor-attention-muted: #fff8c5;
            --borderColor-default: #d1d9e0;
            --borderColor-muted: #d1d9e0b3;
            --borderColor-neutral-muted: #d1d9e0b3;
            --borderColor-accent-emphasis: #0969da;
            --borderColor-success-emphasis: #1a7f37;
            --borderColor-attention-emphasis: #9a6700;
            --borderColor-danger-emphasis: #cf222e;
            --borderColor-done-emphasis: #8250df;
            --color-prettylights-syntax-comment: #59636e;
            --color-prettylights-syntax-constant: #0550ae;
            --color-prettylights-syntax-constant-other-reference-link: #0a3069;
            --color-prettylights-syntax-entity: #6639ba;
            --color-prettylights-syntax-storage-modifier-import: #1f2328;
            --color-prettylights-syntax-entity-tag: #0550ae;
            --color-prettylights-syntax-keyword: #cf222e;
            --color-prettylights-syntax-string: #0a3069;
            --color-prettylights-syntax-variable: #953800;
            --color-prettylights-syntax-brackethighlighter-unmatched: #82071e;
            --color-prettylights-syntax-brackethighlighter-angle: #59636e;
            --color-prettylights-syntax-invalid-illegal-text: #f6f8fa;
            --color-prettylights-syntax-invalid-illegal-bg: #82071e;
            --color-prettylights-syntax-carriage-return-text: #f6f8fa;
            --color-prettylights-syntax-carriage-return-bg: #cf222e;
            --color-prettylights-syntax-string-regexp: #116329;
            --color-prettylights-syntax-markup-list: #3b2300;
            --color-prettylights-syntax-markup-heading: #0550ae;
            --color-prettylights-syntax-markup-italic: #1f2328;
            --color-prettylights-syntax-markup-bold: #1f2328;
            --color-prettylights-syntax-markup-deleted-text: #82071e;
            --color-prettylights-syntax-markup-deleted-bg: #ffebe9;
            --color-prettylights-syntax-markup-inserted-text: #116329;
            --color-prettylights-syntax-markup-inserted-bg: #dafbe1;
            --color-prettylights-syntax-markup-changed-text: #953800;
            --color-prettylights-syntax-markup-changed-bg: #ffd8b5;
            --color-prettylights-syntax-markup-ignored-text: #d1d9e0;
            --color-prettylights-syntax-markup-ignored-bg: #0550ae;
            --color-prettylights-syntax-meta-diff-range: #8250df;
            --color-prettylights-syntax-sublimelinter-gutter-mark: #818b98;
          }
        }

        .markdown-body {
          -ms-text-size-adjust: 100%;
          -webkit-text-size-adjust: 100%;
          margin: 0;
          color: var(--fgColor-default);
          background-color: var(--bgColor-default);
          font-family: -apple-system,BlinkMacSystemFont,"Segoe UI","Noto Sans",Helvetica,Arial,sans-serif,"Apple Color Emoji","Segoe UI Emoji";
          font-size: 16px;
          line-height: 1.5;
          word-wrap: break-word;
          padding: 20px;
        }

        .markdown-body h1 { margin: .67em 0; font-weight: 600; padding-bottom: .3em; font-size: 2em; border-bottom: 1px solid var(--borderColor-muted); }
        .markdown-body h2 { font-weight: 600; padding-bottom: .3em; font-size: 1.5em; border-bottom: 1px solid var(--borderColor-muted); }
        .markdown-body h3 { font-weight: 600; font-size: 1.25em; }
        .markdown-body h4 { font-weight: 600; font-size: 1em; }
        .markdown-body h5 { font-weight: 600; font-size: .875em; }
        .markdown-body h6 { font-weight: 600; font-size: .85em; color: var(--fgColor-muted); }
        .markdown-body h1, .markdown-body h2, .markdown-body h3, .markdown-body h4, .markdown-body h5, .markdown-body h6 { margin-top: var(--base-size-24); margin-bottom: var(--base-size-16); line-height: 1.25; }
        .markdown-body p { margin-top: 0; margin-bottom: 10px; }
        .markdown-body blockquote { margin: 0; padding: 0 1em; color: var(--fgColor-muted); border-left: .25em solid var(--borderColor-default); }
        .markdown-body ul, .markdown-body ol { margin-top: 0; margin-bottom: 0; padding-left: 2em; }
        .markdown-body code, .markdown-body tt { padding: .2em .4em; margin: 0; font-size: 85%; white-space: break-spaces; background-color: var(--bgColor-neutral-muted); border-radius: 6px; font-family: var(--fontStack-monospace); }
        .markdown-body pre { margin-top: 0; margin-bottom: 0; font-family: var(--fontStack-monospace); font-size: 12px; word-wrap: normal; }
        .markdown-body .highlight pre, .markdown-body pre { padding: var(--base-size-16); overflow: auto; font-size: 85%; line-height: 1.45; color: var(--fgColor-default); background-color: var(--bgColor-muted); border-radius: 6px; }
        .markdown-body pre code, .markdown-body pre tt { display: inline; max-width: auto; padding: 0; margin: 0; overflow: visible; line-height: inherit; word-wrap: normal; background-color: transparent; border: 0; }
        .markdown-body table { border-spacing: 0; border-collapse: collapse; display: block; width: max-content; max-width: 100%; overflow: auto; }
        .markdown-body table th, .markdown-body table td { padding: 6px 13px; border: 1px solid var(--borderColor-default); }
        .markdown-body table th { font-weight: 600; }
        .markdown-body table tr { background-color: var(--bgColor-default); border-top: 1px solid var(--borderColor-muted); }
        .markdown-body table tr:nth-child(2n) { background-color: var(--bgColor-muted); }
        .markdown-body img { max-width: 100%; box-sizing: content-box; border-style: none; }
        .markdown-body hr { box-sizing: content-box; overflow: hidden; background: transparent; border-bottom: 1px solid var(--borderColor-muted); height: .25em; padding: 0; margin: var(--base-size-24) 0; background-color: var(--borderColor-default); border: 0; }
        .markdown-body a { background-color: transparent; color: var(--fgColor-accent); text-decoration: none; }
        .markdown-body a:hover { text-decoration: underline; }
        .markdown-body mark { background-color: var(--bgColor-attention-muted); color: var(--fgColor-default); }
        .markdown-body kbd { display: inline-block; padding: var(--base-size-4); font: 11px var(--fontStack-monospace); line-height: 10px; color: var(--fgColor-default); vertical-align: middle; background-color: var(--bgColor-muted); border: solid 1px var(--borderColor-neutral-muted); border-radius: 6px; box-shadow: inset 0 -1px 0 var(--borderColor-neutral-muted); }
        .markdown-body b, .markdown-body strong { font-weight: 600; }
        .markdown-body del { text-decoration: line-through; }
        .markdown-body input[type="checkbox"] { box-sizing: border-box; padding: 0; }
        .markdown-body .task-list-item { list-style-type: none; }
        .markdown-body .task-list-item-checkbox { margin: 0 .2em .25em -1.4em; vertical-align: middle; }
        .markdown-body>*:first-child { margin-top: 0 !important; }
        .markdown-body>*:last-child { margin-bottom: 0 !important; }
        .markdown-body p, .markdown-body blockquote, .markdown-body ul, .markdown-body ol, .markdown-body dl, .markdown-body table, .markdown-body pre, .markdown-body details { margin-top: 0; margin-bottom: var(--base-size-16); }
        body { margin: 0; padding: 0; }
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
            <div class="markdown-body">
                \(htmlBody)
            </div>
        </body>
        </html>
        """
    }
}
