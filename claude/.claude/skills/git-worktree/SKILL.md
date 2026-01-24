---
name: git-worktree
description: Manage git worktrees - clone repos as bare for worktree workflow, or add new worktrees to existing repos. Use when the user says "clone as bare repo", "setup git worktrees", "worktree clone", "add worktree", "new worktree", or asks about worktree operations.
allowed-tools: Bash, AskUserQuestion
---

# Git Worktree

Manage git worktrees: clone repositories as bare repos for worktree workflow, or add new worktrees to existing bare repos. Worktrees are organized in type-based subfolders (fix/, feat/, docs/, chore/, etc.) for clean project structure.

## Arguments

The skill accepts optional arguments:

- `/git-worktree <repo-url>` - Clone repo as bare with auto-detected name
- `/git-worktree <repo-url> <directory-name>` - Clone repo as bare with custom name
- `/git-worktree <branch-name>` - Add new worktree for branch (in existing bare repo)
- `/git-worktree` - Interactive mode: detect context and ask what to do

## Mode Detection

1. **If argument looks like a URL** (contains `://`, `@`, or ends in `.git`):
   - Run **Clone Mode** - set up new bare repo
2. **If argument looks like a branch name** (e.g., `feat/add-auth`, `fix/bug-123`):
   - Run **Add Worktree Mode** - create worktree in existing bare repo
3. **If no arguments**:
   - Check if current directory is a bare repo or inside one
   - If yes: ask for branch name and run **Add Worktree Mode**
   - If no: ask for repo URL and run **Clone Mode**

---

## Clone Mode Instructions

Set up a new repository with bare repo + worktree workflow.

1. **Parse arguments:**
   - Extract repo URL (first arg) and optional directory name (second arg)
   - Directory name: use provided name, or derive from repo URL (last part without .git)
2. **Create directory structure** (use absolute path for `<repo-path>`):
   ```bash
   mkdir -p <repo-path>
   git clone --bare <repo-url> <repo-path>/.git
   ```
3. **Configure remote tracking**:
   ```bash
   git -C <repo-path> config remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*'
   ```
4. **Delete local branches** created during clone:
   ```bash
   git -C <repo-path> branch | sed 's/^[* ]*//' | xargs -r git -C <repo-path> branch -D
   ```
5. **Fetch remote branches:**
   ```bash
   git -C <repo-path> fetch
   ```
6. **Verify setup:**
   ```bash
   git -C <repo-path> branch -a  # Should show only remotes/origin/* branches
   git -C <repo-path> worktree list  # Should show only bare repo
   ```
7. **Create main worktree with tracking:**
   ```bash
   git -C <repo-path> worktree add -b main main origin/main
   ```
8. **Ask user if they want to create additional worktree(s)**
   - If yes, run Add Worktree Mode for each branch

---

## Add Worktree Mode Instructions

Add a new worktree to an existing bare repo setup.

1. **Find the bare repo root:**

   ```bash
   # If in a worktree, find the bare repo
   git rev-parse --git-common-dir 2>/dev/null | xargs dirname
   ```

   The bare repo root is the directory containing `.git/` (the bare repo itself)

2. **Parse the branch name** to determine type and path:
   - Branch: `feat/add-auth` → type: `feat`, name: `add-auth`
   - Branch: `fix/issue-123` → type: `fix`, name: `issue-123`
   - Full branch name for git: `feat/add-auth`
   - Worktree path: `<repo-root>/feat/add-auth`

3. **Create the type subfolder:**

   ```bash
   mkdir -p <repo-root>/<type>
   ```

4. **Create the worktree:**

   ```bash
   git -C <repo-root> worktree add -b <branch> <type>/<name> origin/main
   ```

5. **Fix tracking** to point to the correct remote branch:

   ```bash
   git -C <repo-root>/<type>/<name> config branch.<branch>.remote origin
   git -C <repo-root>/<type>/<name> config branch.<branch>.merge refs/heads/<branch>
   ```

6. **Verify:**
   ```bash
   git -C <repo-root> worktree list
   git -C <repo-root>/<type>/<name> branch -vv  # Should show tracking info
   ```

---

## Worktree Organization by Type

**ALWAYS** create worktrees in a subfolder based on branch type prefix:

| Branch Type     | Subfolder   | Example Branch     | Worktree Path             |
| --------------- | ----------- | ------------------ | ------------------------- |
| `fix/`          | `fix/`      | `fix/issue-123`    | `<repo>/fix/issue-123`    |
| `feat/`         | `feat/`     | `feat/new-api`     | `<repo>/feat/new-api`     |
| `docs/`         | `docs/`     | `docs/readme`      | `<repo>/docs/readme`      |
| `chore/`        | `chore/`    | `chore/deps`       | `<repo>/chore/deps`       |
| `refactor/`     | `refactor/` | `refactor/cleanup` | `<repo>/refactor/cleanup` |
| `test/`         | `test/`     | `test/coverage`    | `<repo>/test/coverage`    |
| `ci/`           | `ci/`       | `ci/actions`       | `<repo>/ci/actions`       |
| `main`/`master` | (root)      | `main`             | `<repo>/main`             |

**Exception:** The `main` or `master` branch lives at the root level, not in a subfolder.

---

## Example Usage

```bash
# Clone a repo as bare (Clone Mode)
/git-worktree git@github.com:org/my-project.git
/git-worktree git@github.com:org/my-project.git custom-name

# Add a new worktree (Add Worktree Mode) - run from within repo
/git-worktree feat/add-auth
/git-worktree fix/issue-123
```

## Example Structure

```
my-project/
├── .git/                           # Bare repository
├── main/                           # Worktree for main branch (root level)
├── feat/
│   ├── add-auth/                   # feat/add-auth branch
│   └── new-api/                    # feat/new-api branch
├── fix/
│   └── issue-123/                  # fix/issue-123 branch
└── docs/
    └── update-readme/              # docs/update-readme branch
```

## Rules

- MUST use absolute paths and `git -C <repo-path>` instead of `cd`
- MUST delete all local branches after clone (keep only remotes)
- MUST configure remote fetch before fetching
- MUST use `-b` flag when creating worktrees to create tracking branches
- MUST always create a main worktree tracking origin/main (in Clone Mode)
- **MUST create worktrees in type subfolders** (fix/, feat/, docs/, chore/, refactor/, test/, ci/) - NEVER at root level except for main/master
- **MUST create the type subfolder** with `mkdir -p` before creating the worktree
- **MUST fix tracking** immediately after creating worktree with `git config branch.<branch>.remote origin` and `git config branch.<branch>.merge refs/heads/<branch>`
- Verify the setup shows `(bare)` in `git worktree list`
