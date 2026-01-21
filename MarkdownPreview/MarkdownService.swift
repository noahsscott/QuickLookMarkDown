//
//  MarkdownService.swift
//  MarkdownPreview
//
//  Created by Noah Scott on 8/1/2026.
//

import Foundation

class MarkdownService {

    func renderMarkdownToHTML(_ markdown: String, bundle: Bundle = Bundle.main) throws -> String {
        // Escape markdown for safe embedding in JavaScript
        // Using JSON encoding ensures proper escaping of quotes, newlines, backslashes, etc.
        let jsonData = try JSONEncoder().encode(markdown)
        let escapedMarkdown = String(data: jsonData, encoding: .utf8) ?? "\"\""

        // Read CSS and JS resources from bundle
        guard let cssURL = bundle.url(forResource: "style", withExtension: "css"),
              let markedURL = bundle.url(forResource: "marked.min", withExtension: "js"),
              let highlightURL = bundle.url(forResource: "highlight.min", withExtension: "js"),
              let mermaidURL = bundle.url(forResource: "mermaid.min", withExtension: "js"),
              let tocbotURL = bundle.url(forResource: "tocbot.min", withExtension: "js"),
              let temmlCSSURL = bundle.url(forResource: "Temml-Local", withExtension: "css"),
              let temmlJSURL = bundle.url(forResource: "temml.min", withExtension: "js") else {
            // Fallback: return unstyled HTML with error message if resources not found
            return """
            <!DOCTYPE html>
            <html>
            <head><meta charset="UTF-8"></head>
            <body>
                <div style="padding: 20px; background: #fff3cd; border: 1px solid #ffc107; margin: 20px;">
                    <h3>Resource Error</h3>
                    <p>Unable to find CSS/JS resource files in bundle.</p>
                    <p>Bundle path: \(bundle.bundlePath)</p>
                    <p>Resource path: \(bundle.resourcePath ?? "nil")</p>
                </div>
                <pre style="padding: 20px;">\(markdown)</pre>
            </body>
            </html>
            """
        }

        let css = try String(contentsOf: cssURL, encoding: .utf8)
        let markedJS = try String(contentsOf: markedURL, encoding: .utf8)
        let highlightJS = try String(contentsOf: highlightURL, encoding: .utf8)
        let mermaidJS = try String(contentsOf: mermaidURL, encoding: .utf8)
        let tocbotJS = try String(contentsOf: tocbotURL, encoding: .utf8)
        let temmlCSS = try String(contentsOf: temmlCSSURL, encoding: .utf8)
        let temmlJS = try String(contentsOf: temmlJSURL, encoding: .utf8)

        return """
        <!DOCTYPE html>
        <html>
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
            <style>
            \(css)
            </style>
            <style>
            \(temmlCSS)
            </style>
        </head>
        <body class="preload">
            <!-- TOC Toggle Button -->
            <button class="toc-toggle" id="toc-toggle" aria-label="Toggle Table of Contents">
                <div class="toc-toggle-icon">
                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 14 12">
                        <path d="M1.83984375,10.7871094 L11.9765625,10.7871094 C12.59375,10.7871094 13.0546875,10.6357422 13.359375,10.3330078 C13.6640625,10.0302734 13.8164062,9.57617188 13.8164062,8.97070312 L13.8164062,1.81640625 C13.8164062,1.2109375 13.6640625,0.756835938 13.359375,0.454101562 C13.0546875,0.151367188 12.59375,0 11.9765625,0 L1.83984375,0 C1.2265625,0 0.766601562,0.151367188 0.459960938,0.454101562 C0.153320312,0.756835938 0,1.2109375 0,1.81640625 L0,8.97070312 C0,9.57617188 0.153320312,10.0302734 0.459960938,10.3330078 C0.766601562,10.6357422 1.2265625,10.7871094 1.83984375,10.7871094 Z M1.8515625,9.84375 C1.55859375,9.84375 1.33398438,9.76660156 1.17773438,9.61230469 C1.02148438,9.45800781 0.943359375,9.22851562 0.943359375,8.92382812 L0.943359375,1.86328125 C0.943359375,1.55859375 1.02148438,1.32910156 1.17773438,1.17480469 C1.33398438,1.02050781 1.55859375,0.943359375 1.8515625,0.943359375 L11.9648438,0.943359375 C12.2539062,0.943359375 12.4775391,1.02050781 12.6357422,1.17480469 C12.7939453,1.32910156 12.8730469,1.55859375 12.8730469,1.86328125 L12.8730469,8.92382812 C12.8730469,9.22851562 12.7939453,9.45800781 12.6357422,9.61230469 C12.4775391,9.76660156 12.2539062,9.84375 11.9648438,9.84375 L1.8515625,9.84375 Z M4.46484375,10.0253906 L5.38476562,10.0253906 L5.38476562,0.767578125 L4.46484375,0.767578125 L4.46484375,10.0253906 Z M3.33984375,3.1171875 C3.42578125,3.1171875 3.50292969,3.08300781 3.57128906,3.01464844 C3.63964844,2.94628906 3.67382812,2.87109375 3.67382812,2.7890625 C3.67382812,2.69921875 3.63964844,2.62207031 3.57128906,2.55761719 C3.50292969,2.49316406 3.42578125,2.4609375 3.33984375,2.4609375 L2.08007812,2.4609375 C1.99414062,2.4609375 1.91796875,2.49316406 1.8515625,2.55761719 C1.78515625,2.62207031 1.75195312,2.69921875 1.75195312,2.7890625 C1.75195312,2.87109375 1.78515625,2.94628906 1.8515625,3.01464844 C1.91796875,3.08300781 1.99414062,3.1171875 2.08007812,3.1171875 L3.33984375,3.1171875 Z M3.33984375,4.63476562 C3.42578125,4.63476562 3.50292969,4.6015625 3.57128906,4.53515625 C3.63964844,4.46875 3.67382812,4.390625 3.67382812,4.30078125 C3.67382812,4.21484375 3.63964844,4.13964844 3.57128906,4.07519531 C3.50292969,4.01074219 3.42578125,3.97851562 3.33984375,3.97851562 L2.08007812,3.97851562 C1.99414062,3.97851562 1.91796875,4.01074219 1.8515625,4.07519531 C1.78515625,4.13964844 1.75195312,4.21484375 1.75195312,4.30078125 C1.75195312,4.390625 1.78515625,4.46875 1.8515625,4.53515625 C1.91796875,4.6015625 1.99414062,4.63476562 2.08007812,4.63476562 L3.33984375,4.63476562 Z M3.33984375,6.14648438 C3.42578125,6.14648438 3.50292969,6.11425781 3.57128906,6.04980469 C3.63964844,5.98535156 3.67382812,5.91015625 3.67382812,5.82421875 C3.67382812,5.734375 3.63964844,5.65722656 3.57128906,5.59277344 C3.50292969,5.52832031 3.42578125,5.49609375 3.33984375,5.49609375 L2.08007812,5.49609375 C1.99414062,5.49609375 1.91796875,5.52832031 1.8515625,5.59277344 C1.78515625,5.65722656 1.75195312,5.734375 1.75195312,5.82421875 C1.75195312,5.91015625 1.78515625,5.98535156 1.8515625,6.04980469 C1.91796875,6.11425781 1.99414062,6.14648438 2.08007812,6.14648438 L3.33984375,6.14648438 Z"/>
                    </svg>
                </div>
            </button>

            <!-- Table of Contents -->
            <div class="toc-container" id="toc-container">
                <nav class="js-toc"></nav>
            </div>

            <!-- Main Content -->
            <div class="markdown-body js-toc-content" id="content"></div>

            <script>
            \(markedJS)
            </script>
            <script>
            \(highlightJS)
            </script>
            <script>
            \(mermaidJS)
            </script>
            <script>
            // Emoji shortcode dictionary
            const emojiShortcodes = {
                // Most Popular Reactions & Gestures
                ":+1:": "👍", ":thumbsup:": "👍", ":-1:": "👎", ":thumbsdown:": "👎",
                ":heart:": "❤️", ":tada:": "🎉", ":clap:": "👏", ":pray:": "🙏",
                ":wave:": "👋", ":muscle:": "💪", ":raised_hands:": "🙌", ":v:": "✌️",
                // Developer-Specific
                ":bug:": "🐛", ":rocket:": "🚀", ":construction:": "🚧", ":wrench:": "🔧",
                ":hammer:": "🔨", ":gear:": "⚙️", ":fire:": "🔥", ":sparkles:": "✨",
                ":zap:": "⚡", ":boom:": "💥", ":bulb:": "💡", ":memo:": "📝",
                ":warning:": "⚠️", ":white_check_mark:": "✅", ":x:": "❌",
                ":question:": "❓", ":exclamation:": "❗", ":lock:": "🔒", ":unlock:": "🔓",
                ":key:": "🔑", ":mag:": "🔍", ":link:": "🔗", ":package:": "📦",
                ":books:": "📚", ":book:": "📖", ":bookmark:": "🔖", ":recycle:": "♻️",
                // Arrows
                ":arrow_up:": "⬆️", ":arrow_down:": "⬇️", ":arrow_left:": "⬅️", ":arrow_right:": "➡️",
                // Smileys - Positive
                ":smile:": "😄", ":smiley:": "😃", ":grin:": "😁", ":laughing:": "😆",
                ":satisfied:": "😆", ":joy:": "😂", ":rofl:": "🤣", ":blush:": "😊",
                ":innocent:": "😇", ":wink:": "😉", ":heart_eyes:": "😍", ":kissing_heart:": "😘",
                ":sunglasses:": "😎", ":star_struck:": "🤩",
                // Smileys - Thinking/Neutral
                ":thinking:": "🤔", ":face_with_monocle:": "🧐", ":neutral_face:": "😐",
                ":smirk:": "😏", ":unamused:": "😒", ":roll_eyes:": "🙄",
                // Smileys - Negative
                ":disappointed:": "😞", ":worried:": "😟", ":confused:": "😕", ":cry:": "😢",
                ":sob:": "😭", ":angry:": "😠", ":rage:": "😡", ":scream:": "😱",
                // Smileys - Other
                ":skull:": "💀", ":poop:": "💩", ":hankey:": "💩", ":shit:": "💩",
                ":ghost:": "👻", ":robot:": "🤖",
                // Hearts
                ":sparkling_heart:": "💖", ":heartbeat:": "💓", ":broken_heart:": "💔",
                ":yellow_heart:": "💛", ":green_heart:": "💚", ":blue_heart:": "💙", ":purple_heart:": "💜",
                // Symbols & Shapes
                ":star:": "⭐", ":star2:": "🌟", ":100:": "💯", ":trophy:": "🏆",
                ":crown:": "👑", ":gem:": "💎",
                // Tech & Office
                ":computer:": "💻", ":keyboard:": "⌨️", ":phone:": "☎️", ":iphone:": "📱",
                ":email:": "📧", ":envelope:": "✉️", ":bell:": "🔔", ":clipboard:": "📋",
                ":calendar:": "📅", ":pushpin:": "📌", ":paperclip:": "📎",
                // Nature & Weather
                ":sunny:": "☀️", ":cloud:": "☁️", ":rainbow:": "🌈", ":snowflake:": "❄️",
                ":tree:": "🌳", ":seedling:": "🌱", ":rose:": "🌹",
                // Animals
                ":cat:": "🐱", ":dog:": "🐶", ":rabbit:": "🐰", ":bear:": "🐻",
                ":panda_face:": "🐼", ":monkey_face:": "🐵", ":bird:": "🐦", ":penguin:": "🐧",
                ":bee:": "🐝", ":fish:": "🐟",
                // Food & Drink
                ":coffee:": "☕", ":tea:": "🍵", ":beer:": "🍺", ":beers:": "🍻",
                ":pizza:": "🍕", ":hamburger:": "🍔", ":fries:": "🍟", ":cake:": "🍰",
                ":apple:": "🍎", ":banana:": "🍌", ":watermelon:": "🍉", ":strawberry:": "🍓",
                // Activities & Events
                ":gift:": "🎁", ":balloon:": "🎈", ":confetti_ball:": "🎊",
                // Flags
                ":checkered_flag:": "🏁"
            };

            // Replace emoji shortcodes in text
            function replaceEmoji(text) {
                return text.replace(/:[a-zA-Z0-9_+-]+:/g, function(match) {
                    return emojiShortcodes[match] || match;
                });
            }

            // Raw markdown from Swift (JSON-encoded for safety)
            const rawMarkdown = \(escapedMarkdown);

            // Process: emoji replacement -> markdown parsing -> HTML
            const markdownWithEmoji = replaceEmoji(rawMarkdown);
            const htmlContent = marked.parse(markdownWithEmoji);

            // Insert into content container
            document.getElementById('content').innerHTML = htmlContent;

            // Initialize syntax highlighting
            hljs.highlightAll();

            // Initialize Mermaid
            mermaid.initialize({
                startOnLoad: false,
                theme: window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'base',
                securityLevel: 'loose'
            });

            // Convert markdown code blocks to Mermaid diagrams and render
            (async function() {
                // Find all code blocks marked with language-mermaid
                const mermaidBlocks = document.querySelectorAll('code.language-mermaid');

                for (let index = 0; index < mermaidBlocks.length; index++) {
                    const codeBlock = mermaidBlocks[index];

                    // Get the mermaid diagram text content
                    const mermaidCode = codeBlock.textContent;

                    // Create a new div element for Mermaid
                    const mermaidDiv = document.createElement('div');
                    mermaidDiv.className = 'mermaid';
                    mermaidDiv.textContent = mermaidCode;

                    // Replace the pre>code block with the mermaid div
                    const preBlock = codeBlock.parentElement;
                    preBlock.parentElement.replaceChild(mermaidDiv, preBlock);
                }

                // Run Mermaid to render all diagrams
                try {
                    await mermaid.run();
                } catch (error) {
                    console.error('Mermaid rendering error:', error);
                }
            })();
            </script>
            <script>
            \(tocbotJS)
            </script>
            <script>
            \(temmlJS)
            </script>
            <script>
            // Initialize Temml for math rendering
            if (typeof temml !== 'undefined') {
                document.addEventListener('DOMContentLoaded', function() {
                    try {
                        temml.renderMathInElement(document.body, {
                            delimiters: [
                                {left: "$$", right: "$$", display: true},
                                {left: "$", right: "$", display: false}
                            ],
                            throwOnError: false,
                            ignoredTags: [
                                "script", "noscript", "style", "textarea", "pre", "code"
                            ],
                            ignoredClasses: ["language-*"]
                        });
                    } catch (error) {
                        console.error('Temml rendering error:', error);
                    }
                });
            }
            </script>
            <script>
            // Generate IDs for headings that don't have them
            const usedIds = {};
            document.querySelectorAll('.js-toc-content h1, .js-toc-content h2, .js-toc-content h3, .js-toc-content h4, .js-toc-content h5, .js-toc-content h6').forEach(function(heading) {
                if (!heading.id) {
                    // Generate ID from heading text
                    const text = heading.textContent || heading.innerText;
                    let id = text
                        .toLowerCase()
                        .replace(/[^\\w\\s-]/g, '')  // Remove special characters
                        .replace(/\\s+/g, '-')       // Replace spaces with hyphens
                        .replace(/-+/g, '-')        // Replace multiple hyphens with single
                        .replace(/^-|-$/g, '');     // Remove leading/trailing hyphens

                    // Handle duplicate IDs by appending a counter
                    let finalId = id;
                    let counter = 1;
                    while (usedIds[finalId]) {
                        finalId = id + '-' + counter;
                        counter++;
                    }

                    usedIds[finalId] = true;
                    heading.id = finalId;
                }
            });

            // Smart TOC generation - determine if document needs TOC
            const headings = document.querySelectorAll('.js-toc-content h1, .js-toc-content h2, .js-toc-content h3');
            const contentElement = document.querySelector('.js-toc-content');
            const contentText = contentElement ? contentElement.innerText : '';
            const wordCount = contentText.trim().split(/\\s+/).filter(word => word.length > 0).length;

            // Show TOC if:
            // - 1000+ words AND 3+ headings, OR
            // - 3000+ words regardless of heading count
            const shouldShowTOC = (wordCount >= 1000 && headings.length >= 3) || wordCount >= 3000;

            // Hide TOC elements if document doesn't meet threshold
            if (!shouldShowTOC) {
                const tocToggle = document.getElementById('toc-toggle');
                const tocContainer = document.getElementById('toc-container');
                if (tocToggle) tocToggle.style.display = 'none';
                if (tocContainer) tocContainer.style.display = 'none';
            }

            // Initialize Tocbot (only if TOC should be shown)
            if (shouldShowTOC && typeof tocbot !== 'undefined') {
                tocbot.init({
                    tocSelector: '.js-toc',
                    contentSelector: '.js-toc-content',
                    headingSelector: 'h1, h2, h3',
                    hasInnerContainers: true,
                    collapseDepth: 3,
                    scrollSmooth: true,
                    scrollSmoothDuration: 420,
                    headingsOffset: 80,
                    orderedList: false
                });

                // Add heading-level classes to TOC links for styling
                document.querySelectorAll('.js-toc .toc-link').forEach(function(link) {
                    const href = link.getAttribute('href');
                    if (href && href.startsWith('#')) {
                        const targetId = href.substring(1);
                        const targetHeading = document.getElementById(targetId);
                        if (targetHeading) {
                            const tagName = targetHeading.tagName.toLowerCase();
                            link.classList.add('toc-' + tagName);
                        }
                    }
                });
            }

            // TOC Toggle functionality (only if TOC is shown)
            if (shouldShowTOC) {
                const tocToggle = document.getElementById('toc-toggle');
                const tocContainer = document.getElementById('toc-container');

                if (tocToggle && tocContainer) {
                    tocToggle.addEventListener('click', function(e) {
                        // Immediately toggle class for instant visual feedback
                        document.body.classList.toggle('toc-open');

                        // Defer localStorage to avoid blocking rendering
                        const isOpen = document.body.classList.contains('toc-open');
                        setTimeout(function() {
                            try {
                                localStorage.setItem('toc-open', isOpen);
                            } catch (e) {
                                // localStorage might not be available in QuickLook sandbox
                            }
                        }, 0);
                    }, false);

                    // Restore previous state from localStorage (only if viewport is wide enough)
                    // Skip for small Finder preview pane to avoid distracting animations
                    try {
                        const wasOpen = localStorage.getItem('toc-open') === 'true';
                        if (wasOpen && window.innerWidth > 700) {
                            document.body.classList.add('toc-open');
                        }
                    } catch (e) {
                        // localStorage might not be available in QuickLook sandbox
                    }

                    // Remove preload class to enable transitions for user interactions
                    // Use requestAnimationFrame to ensure initial state is rendered first
                    requestAnimationFrame(function() {
                        document.body.classList.remove('preload');
                    });
                }
            }
            </script>
        </body>
        </html>
        """
    }
}
