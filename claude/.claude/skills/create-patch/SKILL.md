---
name: create-patch
description: Creates a patch file with all uncommitted changes and moves it to ~/Downloads. Use when the user says "create patch", "save my changes as patch", "export changes", or asks to create a diff file.
allowed-tools: Bash, Read
---

# Create Patch

Create a patch file containing all uncommitted changes (staged and unstaged) and save it to ~/Downloads.

## Instructions

1. Run `git status` to verify there are uncommitted changes
2. Get the current branch name with `git branch --show-current`
3. Generate a filename using format: `<branch>-<timestamp>.patch`
4. Create the patch with `git diff HEAD` to capture all uncommitted changes (staged + unstaged)
5. Move the patch file to `~/Downloads/`
6. Report the full path and summary of what was included

## Patch Generation

```bash
# Get branch name (sanitize for filename)
branch=$(git branch --show-current | tr '/' '-')

# Generate timestamp
timestamp=$(date +%Y%m%d-%H%M%S)

# Create patch filename
filename="${branch}-${timestamp}.patch"

# Generate patch with all uncommitted changes
git diff HEAD > "/tmp/${filename}"

# Move to Downloads
mv "/tmp/${filename}" ~/Downloads/

# Show result
echo "Patch saved to: ~/Downloads/${filename}"
```

## Rules

- MUST include both staged and unstaged changes (use `git diff HEAD`)
- MUST sanitize branch name for valid filename (replace `/` with `-`)
- MUST verify the patch is non-empty before moving
- MUST report the full path of the created patch
- If no changes exist, inform the user and do not create an empty patch
- Never modify or stage any files
- Never commit anything
