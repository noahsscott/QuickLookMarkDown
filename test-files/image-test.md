# Image Display Test

Testing how images are rendered and formatted in QuickLook.

## Basic Image Syntax

### Image with Alt Text
![A sample image](sample.png)

### Image with Alt Text and Title
![Sample image](sample.png "This is the title text")

### Image Without Alt Text
![](sample.png)

## Relative Path Variations

### Current Directory
![Current dir](./sample.png)

### Parent Directory
![Parent dir](../sample.png)

### Subdirectory (if exists)
![Subdirectory](images/sample.png)

## Absolute Paths

### Home Directory Image
![Home path](~/Desktop/sample.png)

### Full Absolute Path
![Absolute](/Users/noahscott/Desktop/sample.png)

## Remote Images (May Be Blocked by Sandbox)

### HTTPS Image
![Remote HTTPS](https://via.placeholder.com/300x200)

### GitHub Raw Content
![GitHub](https://raw.githubusercontent.com/github/explore/main/topics/markdown/markdown.png)

## Images in Context

### Image in a Paragraph
Here is some text before the image. ![Inline](sample.png) And here is text after the image.

### Image in a List
- First item
- ![List image](sample.png)
- Third item

### Image in Blockquote
> This is a blockquote with an image:
> ![Quoted image](sample.png)
> More quoted text below.

### Image in a Table
| Column 1 | Image Column | Column 3 |
|----------|--------------|----------|
| Text | ![Table img](sample.png) | More text |
| Row 2 | Another cell | End |

## Multiple Images

### Side by Side (if supported)
![Image 1](sample1.png) ![Image 2](sample2.png)

### Stacked Images
![First](sample1.png)

![Second](sample2.png)

![Third](sample3.png)

## Image as Link

### Clickable Image
[![Click me](sample.png)](https://example.com)

### Image Linking to Another Image
[![Thumbnail](thumb.png)](full-size.png)

## Edge Cases

### Very Long Alt Text
![This is a very long alt text that might cause layout issues if not handled properly by the CSS styles in the preview extension](sample.png)

### Special Characters in Alt Text
![Image with "quotes" & ampersand <angle brackets>](sample.png)

### Missing/Broken Image
![This image does not exist](nonexistent-image-12345.png)

### Empty Source
![Empty source]()

### Image with Query Parameters
![With params](sample.png?v=1&size=large)

## HTML Image Tags (if supported)

<img src="sample.png" alt="HTML img tag">

<img src="sample.png" alt="With dimensions" width="200" height="150">

<img src="sample.png" alt="Centered" style="display: block; margin: 0 auto;">

## Image Formats (if you have test files)

### PNG
![PNG image](test.png)

### JPEG
![JPEG image](test.jpg)

### GIF
![GIF image](test.gif)

### SVG
![SVG image](test.svg)

### WebP
![WebP image](test.webp)

---

## Notes

- Remote images may not load due to QuickLook sandbox restrictions
- Relative paths are resolved relative to the markdown file location
- HTML img tags may or may not be rendered depending on markdown parser settings
