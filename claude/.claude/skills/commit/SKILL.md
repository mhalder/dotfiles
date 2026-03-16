---
name: commit
description: Creates git commits with conventional commit messages. Use when the user says "commit", "commit changes", "create a commit", "save my changes", or asks to commit code.
allowed-tools: Bash, Read, Glob, Grep
---

# Git Commit

Analyze changes and create well-formatted commits using conventional commit format.

## Instructions

1. Run `git status` to see staged, unstaged, and untracked files
2. Run `git diff --staged` (or `git diff` if nothing staged) to view changes
3. Run `git log --oneline -5` to match existing commit style
4. **Run /update-readme skill** to ensure documentation is in sync with changes. If only non-code files changed (e.g., docs/requirements.md), verify the README is still current but skip the full skill if no code or structural changes were made.
5. Stage changes with `git add` if needed (ask user if unclear what to stage)
6. Create commit with conventional format (see below)
7. Run `git status` to verify success

## Conventional commit format

```
<type>[scope]: <description>

[optional body]
```

**Types:** feat, fix, docs, style, refactor, test, chore, build, ci, perf

**Example:**

```
feat(auth): add password reset flow

Implements forgot password email and reset token validation.
Closes #42
```

## Rules

- MUST use imperative mood ("add" not "added")
- MUST keep first line under 72 characters
- MUST use heredoc for multi-line messages
- Never add "Generated with Claude Code" or attribution
- Never add Co-Authored-By headers
- Never add attribution to PR descriptions either
- Never use `git commit --amend` unless explicitly requested
- Never use `git reset --hard` - it destroys local changes
- Never use `git push` unless explicitly requested
- Never push directly to main/master; always use a feature branch and PR
- Never create a PR without explicit user approval
- After committing, ALWAYS ASK the user before pushing or creating a PR/MR. Never push or create MRs automatically, even if the workflow seems obvious.
- Never stage files containing secrets (.env, credentials, API keys)
- Never stage or commit CLAUDE.md files or anything under `.claude/`
- When new tests reveal source code bugs, stage both the fix and the tests in a single commit
- When committing a large batch of fixes, group related changes into a single commit with a descriptive body listing each fix as a bullet point

## Heredoc format

```bash
git commit -m "$(cat <<'EOF'
type(scope): description

Body text here.
EOF
)"
```
