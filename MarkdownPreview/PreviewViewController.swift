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

    private let markdownService = MarkdownService()

    private var webView: WKWebView?

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

        // Replace emoji shortcodes before rendering markdown
        let processedMarkdown = markdownService.replaceEmojiShortcodes(markdownString)

        // Render markdown to HTML
        let htmlString = try markdownService.renderMarkdownToHTML(processedMarkdown)

        // Create and configure WebView on main thread
        await MainActor.run {
            if self.webView == nil {
                let webView = WKWebView()
                webView.translatesAutoresizingMaskIntoConstraints = false
                self.view.addSubview(webView)
                NSLayoutConstraint.activate([
                    webView.topAnchor.constraint(equalTo: self.view.topAnchor),
                    webView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                    webView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                    webView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
                ])
                self.webView = webView
            }
            
            self.webView?.loadHTMLString(htmlString, baseURL: url.deletingLastPathComponent())
        }
    }
}
