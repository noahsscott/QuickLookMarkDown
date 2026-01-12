# Simple Mermaid Test

This is a simple test file to verify Mermaid diagrams are working.

## Test Diagram

```mermaid
graph TD
    A[Start] --> B{Working?}
    B -->|Yes| C[Success!]
    B -->|No| D[Debug]
    D --> B
    C --> E[End]
```

## Regular Code Block (Should NOT be rendered as diagram)

```javascript
console.log("This should remain as code");
function test() {
    return true;
}
```

## Another Mermaid Diagram

```mermaid
sequenceDiagram
    Alice->>Bob: Hello Bob!
    Bob-->>Alice: Hi Alice!
```
