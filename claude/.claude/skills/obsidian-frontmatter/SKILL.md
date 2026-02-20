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
tags:
  - tag1
  - tag2
---
```

### Optional Fields

```yaml
aliases:
  - alternative-name
source: https://...
author: Author Name
```

## Organization: Hubs over Tags

- **Hubs (MOC notes)** are the primary navigation tool — create a hub note for any topic with 3+ notes
- **Tags** are flat and minimal — used for search and lightweight categorization, not hierarchy
- Hubs can link to other hubs for natural hierarchy without needing folder nesting or hierarchical tags

## Rules

1. **Always include frontmatter** — every note must have `id` and `tags`
2. **`id` must be stable** — never change it after creation. Format: `YYYYMMDDHHmm-slug` or `timestamp-slug`
3. **Use flat tags** — `neovim`, `cli`, `aws` (not `tool/neovim` or `cloud/aws`)
4. **No spaces in tag names** — use hyphens (`knowledge-management`)
5. **2-5 tags per note** — if you need more, consider splitting the note
6. **Use `aliases` only when they add value** — alternate names, acronyms, abbreviations that differ from the filename. Do not duplicate the filename slug as an alias.
7. **Use `source` (singular)** for reference material — capture where information came from

## Common Pitfalls to Avoid

- Missing `---` delimiters — frontmatter must start on line 1
- Tabs instead of spaces — YAML requires spaces
- Unquoted special characters — values with `:`, `#`, `[`, `{` need quoting
- Duplicate keys — YAML silently uses the last value
- Content (headings, todos) inside the frontmatter block — only valid YAML between `---` delimiters
