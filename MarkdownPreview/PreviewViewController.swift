//
//  PreviewViewController.swift
//  MarkdownPreview
//
//  Created by Noah Scott on 8/1/2026.
//

import Cocoa
import Quartz
import WebKit

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

        // Render markdown to HTML with resources from bundle
        // Note: Emoji shortcode replacement and markdown parsing now handled client-side by marked.js
        let htmlString: String
        do {
            htmlString = try markdownService.renderMarkdownToHTML(markdownString, bundle: Bundle(for: PreviewViewController.self))
        } catch {
            // If rendering fails, show an error page with the error details
            htmlString = """
            <!DOCTYPE html>
            <html>
            <head><meta charset="UTF-8"></head>
            <body style="font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; padding: 20px;">
                <div style="background: #ffebee; border: 2px solid #c62828; padding: 20px; border-radius: 8px;">
                    <h2>❌ Error Rendering Markdown</h2>
                    <p><strong>Error:</strong> \(error.localizedDescription)</p>
                    <p><strong>Bundle Path:</strong> \(Bundle(for: PreviewViewController.self).bundlePath)</p>
                </div>
                <div style="margin-top: 20px; padding: 20px; background: #f5f5f5; border-radius: 8px;">
                    <h3>Raw Content:</h3>
                    <pre style="white-space: pre-wrap; word-wrap: break-word;">\(markdownString.prefix(1000))</pre>
                </div>
            </body>
            </html>
            """
        }

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
            
            self.webView?.loadHTMLString(htmlString, baseURL: nil)
        }
    }
}
