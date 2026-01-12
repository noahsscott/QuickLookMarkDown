# Mermaid Diagram Test File

This file tests various Mermaid diagram types to verify the QuickLook extension renders them correctly.

## 1. Flowchart

```mermaid
graph TD
    A[Start] --> B{Is it working?}
    B -->|Yes| C[Great!]
    B -->|No| D[Debug]
    D --> B
    C --> E[End]
```

## 2. Sequence Diagram

```mermaid
sequenceDiagram
    participant Alice
    participant Bob
    participant John
    Alice->>John: Hello John, how are you?
    loop Healthcheck
        John->>John: Fight against hypochondria
    end
    Note right of John: Rational thoughts!
    John-->>Alice: Great!
    John->>Bob: How about you?
    Bob-->>John: Jolly good!
```

## 3. Gantt Chart

```mermaid
gantt
    title A Project Schedule
    dateFormat  YYYY-MM-DD
    section Planning
    Research           :a1, 2024-01-01, 30d
    Requirements       :a2, after a1, 20d
    section Development
    Design             :b1, 2024-02-01, 25d
    Implementation     :b2, after b1, 40d
    Testing            :b3, after b2, 20d
    section Deployment
    Beta Release       :c1, after b3, 15d
    Final Release      :c2, after c1, 10d
```

## 4. Class Diagram

```mermaid
classDiagram
    Animal <|-- Duck
    Animal <|-- Fish
    Animal <|-- Zebra
    Animal : +int age
    Animal : +String gender
    Animal: +isMammal()
    Animal: +mate()
    class Duck{
        +String beakColor
        +swim()
        +quack()
    }
    class Fish{
        -int sizeInFeet
        -canEat()
    }
    class Zebra{
        +bool is_wild
        +run()
    }
```

## 5. State Diagram

```mermaid
stateDiagram-v2
    [*] --> Still
    Still --> [*]
    Still --> Moving
    Moving --> Still
    Moving --> Crash
    Crash --> [*]
```

## 6. Entity Relationship Diagram

```mermaid
erDiagram
    CUSTOMER ||--o{ ORDER : places
    ORDER ||--|{ LINE-ITEM : contains
    CUSTOMER {
        string name
        string custNumber
        string sector
    }
    ORDER {
        int orderNumber
        string deliveryAddress
    }
    LINE-ITEM {
        string productCode
        int quantity
        float pricePerUnit
    }
```

## 7. User Journey

```mermaid
journey
    title My working day
    section Go to work
      Make tea: 5: Me
      Go upstairs: 3: Me
      Do work: 1: Me, Cat
    section Go home
      Go downstairs: 5: Me
      Sit down: 5: Me
```

## 8. Pie Chart

```mermaid
pie title Programming Languages Used
    "JavaScript" : 35
    "Python" : 30
    "Swift" : 15
    "Rust" : 10
    "Other" : 10
```

## 9. Git Graph

```mermaid
gitGraph
    commit
    commit
    branch develop
    checkout develop
    commit
    commit
    checkout main
    merge develop
    commit
    commit
```

## 10. Complex Flowchart

```mermaid
graph TB
    A[Christmas] -->|Get money| B(Go shopping)
    B --> C{Let me think}
    C -->|One| D[Laptop]
    C -->|Two| E[iPhone]
    C -->|Three| F[Car]
    D --> G[Result 1]
    E --> G
    F --> G
    G --> H{Good?}
    H -->|Yes| I[Celebrate]
    H -->|No| J[Try again]
    J --> A
```

---

## Test Notes

- All diagrams should render as SVG graphics
- Diagrams should adapt to light/dark mode
- Text should be readable and properly sized
- No JavaScript errors in console
- Rendering should be relatively fast

### Expected Behavior

When viewing this file with QuickLook (press Spacebar in Finder):
1. All code blocks marked with `mermaid` should be rendered as diagrams
2. Regular code blocks without `mermaid` should remain as syntax-highlighted code
3. Diagrams should be interactive (zoom, pan if supported)
4. Theme should match system appearance (light/dark)
