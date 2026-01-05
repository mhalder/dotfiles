---
name: review-pr
description: Review pull requests for code quality, security, and best practices. Use when the user says "review PR", "review pull request", "check this PR", "PR review", or provides a PR number or URL to review.
allowed-tools: Bash, Read, Glob, Grep
---

# Review Pull Request

Analyze pull request changes for code quality, security issues, and best practices.

## Instructions

1. Get PR details: `gh pr view <number> --json title,body,files,additions,deletions`
2. Get the diff: `gh pr diff <number>`
3. Read modified files for full context
4. Review changes against checklist below
5. Provide structured feedback

## Review checklist

### Security (Critical)
- No hardcoded secrets, API keys, passwords
- No SQL injection vulnerabilities (use parameterized queries)
- No XSS vulnerabilities (sanitize user input)
- No path traversal (validate file paths)
- Dependencies don't have known CVEs

### Code Quality
- Functions/methods not too long (>50 lines)
- No code duplication
- Clear naming conventions
- Error handling present
- Edge cases considered

### Testing
- Tests added for new functionality
- Tests pass (check CI status)
- Edge cases covered
- No skipped tests added

### Documentation
- Public APIs documented
- Complex logic has comments
- README updated if needed

## Commands

```bash
# View PR details
gh pr view <number>
gh pr diff <number>
gh pr checks <number>

# List changed files
gh pr view <number> --json files --jq '.files[].path'

# View specific file in PR
gh pr diff <number> -- <filepath>
```

## Output format

```
## Summary
Brief description of what this PR does.

## Security Issues
- [ ] Critical: Found hardcoded API key in config.js:42

## Code Quality
- [ ] Warning: Function `processData` is 120 lines, consider splitting
- [ ] Suggestion: Extract duplicate code in lines 50-60 and 80-90

## Tests
- [ ] Missing tests for error handling path

## Approved / Changes Requested / Needs Discussion
```

## Rules

- MUST check for security issues first
- MUST read full context of changed files, not just diff
- Never approve PRs with hardcoded secrets
- Never approve PRs with failing CI
- Always provide actionable feedback with line numbers
