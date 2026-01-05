---
name: git-rebase
description: Guide interactive rebasing, commit squashing, and conflict resolution. Use when the user says "squash commits", "rebase onto main", "interactive rebase", "clean up commits", "fix commit history", or asks about rebasing.
allowed-tools: Bash, Read
---

# Git Rebase

Guide through interactive rebasing, squashing commits, and resolving conflicts.

## Instructions

1. Check current branch state: `git status` and `git log --oneline`
2. Identify rebase target (main, specific commit, etc.)
3. Guide through the rebase process step by step
4. Help resolve conflicts if they occur
5. Verify final state

## Common operations

### Squash last N commits

```bash
# Squash last 3 commits into one
git rebase -i HEAD~3

# In editor, change 'pick' to 'squash' (or 's') for commits to squash
# Keep 'pick' for the first commit
```

### Rebase onto main

```bash
git fetch origin
git rebase origin/main
```

### Rebase interactive options

```
pick   = use commit
reword = use commit, but edit message
edit   = use commit, but stop for amending
squash = meld into previous commit
fixup  = like squash, but discard message
drop   = remove commit
```

## Conflict resolution

```bash
# See conflicting files
git status

# After fixing conflicts in files
git add <file>
git rebase --continue

# To abort and return to original state
git rebase --abort

# To skip a problematic commit
git rebase --skip
```

## Safety checks

```bash
# Before rebasing, create backup branch
git branch backup-branch

# Check if branch has been pushed
git log origin/<branch>..<branch>

# If commits are pushed, warn about force push
```

## Rules

- MUST check if commits have been pushed before rebasing
- MUST warn about force push requirements after rebasing pushed commits
- MUST suggest creating a backup branch for complex rebases
- Never use `-i` flag (interactive mode not supported)
- Never force push to main/master
- Never rebase public/shared branches without explicit approval
- Always show `git log --oneline` before and after

## Non-interactive alternatives

Since interactive mode (`-i`) requires manual editor input, use these instead:

```bash
# Squash all commits on branch into one
git reset --soft origin/main && git commit -m "message"

# Fixup a specific commit (auto-squash)
git commit --fixup=<commit>
git rebase --autosquash origin/main

# Reword last commit
git commit --amend -m "new message"
```
