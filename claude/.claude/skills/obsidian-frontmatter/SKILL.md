---
name: obsidian-frontmatter
description: Enforces Obsidian frontmatter schema and best practices when creating or editing markdown notes. Automatically applied when working in an Obsidian vault. Use when the user says "create a note", "new note", "add frontmatter", or is working with Obsidian markdown files.
allowed-tools: Read, Write, Edit, Glob, Grep
---

# Obsidian Frontmatter

Enforce consistent YAML frontmatter on all markdown notes in Obsidian vaults.

## Frontmatter Schema

### Core Fields (required on every note)

```yaml
---
id: unique-identifier
type: <type>
tags:
  - tag1
  - tag2
created: YYYY-MM-DD
---
```

### Optional Fields

```yaml
modified: YYYY-MM-DD
status: seedling | growing | evergreen | active | completed
aliases:
  - alternative-name
source: https://...
author: Author Name
```

## Valid `type` Values

| Type       | Usage                                              |
| ---------- | -------------------------------------------------- |
| `inbox`    | Quick captures, fleeting notes                     |
| `daily`    | Daily journal entries                              |
| `project`  | Active project notes                               |
| `area`     | Ongoing responsibility notes                       |
| `resource` | Reference material, tools, guides, knowledge notes |
| `archive`  | Completed/outdated material                        |
| `moc`      | Maps of Content                                    |
| `book`     | Book notes and highlights                          |
| `snippet`  | Code snippets and examples                         |
| `decision` | Decision records with context and options          |
| `idea`     | Ideas and seeds for future exploration             |
| `meeting`  | Meeting notes with attendees and actions           |
| `person`   | People notes and contacts                          |
| `research` | Research notes with questions and findings         |

## Rules

1. **Always include frontmatter** — every note must have `id`, `type`, `tags`, `created`
2. **`id` must be stable** — never change it after creation. Format: `YYYYMMDDHHmm-slug` for most notes, `YYYY-MM-DD` for daily notes
3. **`type` must be from the valid set** — never invent new type values
4. **`status` must be from the valid set** — `seedling`, `growing`, `evergreen`, `active`, `completed`
5. **Date format: `YYYY-MM-DD`** — ISO 8601, no exceptions
6. **Use hierarchical tags** — `tool/obsidian`, `cloud/aws`, `project/active`
7. **No spaces in tag names** — use hyphens (`knowledge-management`) or slashes (`tool/obsidian`)
8. **2-5 tags per note** — if you need more, consider splitting the note
9. **Use `source` (singular)** for reference material — always capture where information came from
10. **Use `aliases`** for discoverability — abbreviations, acronyms, alternate names

## Field Distinctions

- **`id`** is custom — Obsidian ignores it. Used for Dataview queries, scripts, stable references that survive renames.
- **`aliases`** is Obsidian-native — values appear in `[[` autocomplete, search, and graph view.
- **Frontmatter tags** (YAML list) are preferred for structured queries. Inline `#tags` are fine for situational markers.

## Common Pitfalls to Avoid

- Missing `---` delimiters — frontmatter must start on line 1
- Tabs instead of spaces — YAML requires spaces
- Unquoted special characters — values with `:`, `#`, `[`, `{` need quoting
- Duplicate keys — YAML silently uses the last value
- Using `sources` (plural) instead of `source` (singular)
- Using status values not in the valid set (e.g., `seed` instead of `seedling`, `pending` instead of `active`)
