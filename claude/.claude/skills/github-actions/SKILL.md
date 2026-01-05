---
name: github-actions
description: Write and debug GitHub Actions workflows. Use when the user says "create CI pipeline", "github actions", "workflow not working", "fix CI", "automate with github", or asks about GitHub Actions.
allowed-tools: Read, Write, Edit, Glob, Grep, Bash
---

# GitHub Actions

Create and troubleshoot GitHub Actions workflows for CI/CD pipelines.

## Instructions

When writing:

1. Understand the pipeline requirements
2. Check existing workflows in `.github/workflows/`
3. Write workflow following best practices below
4. Validate with `actionlint` if available

When debugging:

1. Read the workflow file
2. Check recent runs: `gh run list`
3. View run logs: `gh run view <run-id> --log-failed`
4. Identify and fix issues

## Workflow structure

```yaml
name: CI

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

permissions:
  contents: read

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Setup Node
        uses: actions/setup-node@v4
        with:
          node-version: "20"
          cache: "npm"

      - name: Install dependencies
        run: npm ci

      - name: Run tests
        run: npm test
```

## Best practices

- MUST pin actions to full SHA: `uses: actions/checkout@abc123...`
- MUST set minimal `permissions:` (not defaults)
- MUST use `npm ci` not `npm install` for reproducibility
- Use caching for dependencies
- Use matrix builds for multiple versions
- Use job dependencies with `needs:`
- Use concurrency to cancel outdated runs
- Store secrets in GitHub Secrets, reference with `${{ secrets.NAME }}`

## Security

```yaml
permissions:
  contents: read # Minimal permissions

env:
  API_KEY: ${{ secrets.API_KEY }} # Never hardcode
```

## Common patterns

```yaml
# Caching
- uses: actions/cache@v4
  with:
    path: ~/.cache/pip
    key: ${{ runner.os }}-pip-${{ hashFiles('**/requirements.txt') }}

# Matrix
strategy:
  matrix:
    node: [18, 20, 22]
    os: [ubuntu-latest, macos-latest]

# Concurrency
concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true

# Conditional
if: github.event_name == 'push' && github.ref == 'refs/heads/main'
```

## Debug commands

```bash
gh run list --limit 10
gh run view <run-id>
gh run view <run-id> --log-failed
gh run rerun <run-id>
```

## Rules

- MUST use pinned action versions (SHA or version tag)
- MUST set explicit permissions
- Never hardcode secrets in workflow files
- Never use `pull_request_target` with checkout of PR code
- Always test workflows in a branch first
