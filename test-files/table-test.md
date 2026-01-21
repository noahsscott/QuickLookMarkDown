# Table Rendering Test

## Simple Table

| Header 1 | Header 2 | Header 3 |
|----------|----------|----------|
| Row 1 A  | Row 1 B  | Row 1 C  |
| Row 2 A  | Row 2 B  | Row 2 C  |

## Table with Alignment

| Left | Center | Right |
|:-----|:------:|------:|
| A    | B      | C     |
| D    | E      | F     |

## Table from llm-guidelines.md

| File | Purpose |
|------|---------|
| `CHANGELOG.md` | Understand what's been built and recent changes |
| `docs/ARCHITECTURE.md` | Understand design decisions and system structure |
| `dev-notes/todo.md` | Current priorities and planned work |

## Mixed Content

Some text before the table.

| Column A | Column B |
|----------|----------|
| Value 1  | Value 2  |
| Value 3  | Value 4  |

Some text after the table.

## Edge Cases

Single column table:

| Header |
|--------|
| Data 1 |
| Data 2 |

Empty cells:

| A | B | C |
|---|---|---|
|   | X |   |
| Y |   | Z |
