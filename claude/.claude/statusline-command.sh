#!/usr/bin/env bash
# Claude Code status line - styled after Tide fish prompt
# Left items: pwd, git (mirrors tide_left_prompt_items: pwd git newline character)
# Right items: model, context usage (mirrors tide_right_prompt_items: status context ...)

input=$(cat)

cwd=$(echo "$input" | jq -r '.cwd // .workspace.current_dir // ""')
model=$(echo "$input" | jq -r '.model.display_name // ""')
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

# Shorten home directory to ~
home="$HOME"
display_cwd="${cwd/#$home/\~}"

# Git branch (skip optional locks to avoid blocking)
git_branch=""
if git -C "$cwd" rev-parse --git-dir >/dev/null 2>&1; then
  git_branch=$(git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null || git -C "$cwd" rev-parse --short HEAD 2>/dev/null)
fi

# ANSI colors matching Tide theme
# tide_pwd_color_anchors: #00AFFF (cyan)
# tide_git_color_branch: #5FD700 (green)
# tide_context_color_default: #D7AF87 (tan)
# tide_cmd_duration_color: #87875F (olive)
COLOR_RESET=$'\033[0m'
COLOR_PWD=$'\033[38;2;0;175;255m'     # #00AFFF - tide_pwd_color_anchors
COLOR_GIT=$'\033[38;2;95;215;0m'      # #5FD700 - tide_git_color_branch
COLOR_MODEL=$'\033[38;2;215;175;135m' # #D7AF87 - tide_context_color_default
COLOR_CTX=$'\033[38;2;135;135;95m'    # #87875F - tide_cmd_duration_color

left=""
left="${COLOR_PWD}${display_cwd}${COLOR_RESET}"

if [ -n "$git_branch" ]; then
  left+="  ${COLOR_GIT}${git_branch}${COLOR_RESET}"
fi

right=""
if [ -n "$model" ]; then
  right="${COLOR_MODEL}${model}${COLOR_RESET}"
fi

if [ -n "$used_pct" ]; then
  used_int=${used_pct%.*}
  used_int=${used_int:-0}
  if [ "$used_int" -ge 80 ]; then
    CTX_COLOR=$'\033[38;2;215;0;0m' # red when high
  elif [ "$used_int" -ge 50 ]; then
    CTX_COLOR=$'\033[38;2;215;175;0m' # yellow when medium
  else
    CTX_COLOR="$COLOR_CTX"
  fi
  if [ -n "$right" ]; then
    right+="  ${CTX_COLOR}ctx:${used_int}%${COLOR_RESET}"
  else
    right="${CTX_COLOR}ctx:${used_int}%${COLOR_RESET}"
  fi
fi

printf '%s  %s' "$left" "$right"
