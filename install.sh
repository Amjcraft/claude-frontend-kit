#!/usr/bin/env bash
set -euo pipefail

# ─────────────────────────────────────────────
# frontend-agent-toolkit installer
# ─────────────────────────────────────────────

TOOLKIT_REPO="https://raw.githubusercontent.com/your-username/frontend-agent-toolkit/main"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colors
BOLD='\033[1m'
DIM='\033[2m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
RESET='\033[0m'

print_header() {
  echo ""
  echo -e "${BOLD}${BLUE}╔══════════════════════════════════════╗${RESET}"
  echo -e "${BOLD}${BLUE}║   frontend-agent-toolkit installer   ║${RESET}"
  echo -e "${BOLD}${BLUE}╚══════════════════════════════════════╝${RESET}"
  echo ""
}

print_step() { echo -e "\n${BOLD}▶ $1${RESET}"; }
print_ok()   { echo -e "  ${GREEN}✓${RESET} $1"; }
print_warn() { echo -e "  ${YELLOW}⚠${RESET}  $1"; }
print_info() { echo -e "  ${DIM}$1${RESET}"; }
print_err()  { echo -e "  ${RED}✗${RESET} $1"; }

# ─────────────────────────────────────────────
# Resolve source directory
# ─────────────────────────────────────────────

# If running from a local clone, use that. Otherwise we'd need to fetch.
if [[ -d "$SCRIPT_DIR/template" ]]; then
  SOURCE_DIR="$SCRIPT_DIR"
else
  print_err "Could not find template directory. Run this script from the cloned frontend-agent-toolkit repo."
  echo ""
  echo "  git clone https://github.com/your-username/frontend-agent-toolkit.git"
  echo "  cd your-project"
  echo "  bash ../frontend-agent-toolkit/install.sh"
  echo ""
  exit 1
fi

# ─────────────────────────────────────────────
# Preflight checks
# ─────────────────────────────────────────────

print_header

TARGET_DIR="$(pwd)"

if [[ "$TARGET_DIR" == "$SOURCE_DIR" ]]; then
  print_err "Run this script from your project directory, not from the toolkit repo itself."
  exit 1
fi

if [[ ! -f "$TARGET_DIR/package.json" ]]; then
  print_warn "No package.json found in current directory."
  read -rp "  Continue anyway? (y/N): " confirm
  [[ "$confirm" =~ ^[Yy]$ ]] || exit 0
fi

# ─────────────────────────────────────────────
# Project info
# ─────────────────────────────────────────────

print_step "Project info"

read -rp "  Project name: " PROJECT_NAME
while [[ -z "$PROJECT_NAME" ]]; do
  print_warn "Project name cannot be empty."
  read -rp "  Project name: " PROJECT_NAME
done

read -rp "  Project description: " PROJECT_DESCRIPTION
if [[ -z "$PROJECT_DESCRIPTION" ]]; then
  PROJECT_DESCRIPTION="A Next.js application."
fi

echo ""
print_info "Name: $PROJECT_NAME"
print_info "Description: $PROJECT_DESCRIPTION"

# ─────────────────────────────────────────────
# Module selection
# ─────────────────────────────────────────────

print_step "Select optional modules"
echo ""
echo -e "  ${DIM}Use the numbers to toggle modules. Press Enter when done.${RESET}"
echo ""

AVAILABLE_MODULES=("figma" "playwright" "vercel" "storybook")
MODULE_DESCS=(
  "Figma MCP + design handoff skill (requires Figma token)"
  "Playwright MCP + E2E testing skill and command (project-scoped)"
  "Vercel MCP + deployment skill (requires Vercel token)"
  "Storybook skill + story generation command"
)

SELECTED_MODULES=()

select_modules() {
  local selected=()
  for i in "${!AVAILABLE_MODULES[@]}"; do
    selected+=("")
  done

  while true; do
    echo -e "\r\033[${#AVAILABLE_MODULES[@]}A"
    for i in "${!AVAILABLE_MODULES[@]}"; do
      local name="${AVAILABLE_MODULES[$i]}"
      local desc="${MODULE_DESCS[$i]}"
      local num=$((i + 1))
      if [[ "${selected[$i]}" == "x" ]]; then
        echo -e "  ${GREEN}[x]${RESET} ${num}. ${BOLD}${name}${RESET} — ${DIM}${desc}${RESET}"
      else
        echo -e "  [ ] ${num}. ${BOLD}${name}${RESET} — ${DIM}${desc}${RESET}"
      fi
    done
    echo ""
    read -rp "  Toggle module (1-${#AVAILABLE_MODULES[@]}) or Enter to confirm: " choice
    if [[ -z "$choice" ]]; then
      break
    fi
    local idx=$((choice - 1))
    if [[ $idx -ge 0 && $idx -lt ${#AVAILABLE_MODULES[@]} ]]; then
      if [[ "${selected[$idx]}" == "x" ]]; then
        selected[$idx]=""
      else
        selected[$idx]="x"
      fi
    fi
  done

  for i in "${!AVAILABLE_MODULES[@]}"; do
    if [[ "${selected[$i]}" == "x" ]]; then
      SELECTED_MODULES+=("${AVAILABLE_MODULES[$i]}")
    fi
  done
}

# Print initial state
for i in "${!AVAILABLE_MODULES[@]}"; do
  echo -e "  [ ] $((i + 1)). ${BOLD}${AVAILABLE_MODULES[$i]}${RESET} — ${DIM}${MODULE_DESCS[$i]}${RESET}"
done
echo ""

select_modules

echo ""
if [[ ${#SELECTED_MODULES[@]} -gt 0 ]]; then
  print_info "Selected: ${SELECTED_MODULES[*]}"
else
  print_info "No optional modules selected."
fi

# ─────────────────────────────────────────────
# Confirm
# ─────────────────────────────────────────────

print_step "Summary"
echo ""
echo -e "  Installing into: ${BOLD}$TARGET_DIR${RESET}"
echo -e "  Project name:    ${BOLD}$PROJECT_NAME${RESET}"
echo -e "  Modules:         ${BOLD}${SELECTED_MODULES[*]:-none}${RESET}"
echo ""
read -rp "  Proceed? (Y/n): " go
[[ -z "$go" || "$go" =~ ^[Yy]$ ]] || { echo "Aborted."; exit 0; }

# ─────────────────────────────────────────────
# Install base template
# ─────────────────────────────────────────────

print_step "Installing base template"

TEMPLATE_DIR="$SOURCE_DIR/template"

copy_file() {
  local src="$1"
  local dest_rel="${src#$TEMPLATE_DIR/}"
  local dest="$TARGET_DIR/$dest_rel"
  local dest_dir
  dest_dir="$(dirname "$dest")"

  mkdir -p "$dest_dir"

  if [[ -f "$dest" ]]; then
    print_warn "Exists, skipping: $dest_rel"
  else
    cp "$src" "$dest"
    print_ok "Created: $dest_rel"
  fi
}

# Process CLAUDE.md with substitutions
process_claude_md() {
  local src="$TEMPLATE_DIR/CLAUDE.md"
  local dest="$TARGET_DIR/CLAUDE.md"
  if [[ -f "$dest" ]]; then
    print_warn "Exists, skipping: CLAUDE.md"
    return
  fi
  sed \
    -e "s/{{PROJECT_NAME}}/$PROJECT_NAME/g" \
    -e "s/{{PROJECT_DESCRIPTION}}/$PROJECT_DESCRIPTION/g" \
    "$src" > "$dest"
  print_ok "Created: CLAUDE.md (with project name + description)"
}

process_claude_md

# Copy remaining template files (excluding CLAUDE.md)
while IFS= read -r -d '' file; do
  [[ "$(basename "$file")" == "CLAUDE.md" ]] && continue
  copy_file "$file"
done < <(find "$TEMPLATE_DIR" -type f -print0)

# Merge .gitignore entries
merge_gitignore() {
  local entries_file="$TARGET_DIR/.gitignore.claude"
  local gitignore="$TARGET_DIR/.gitignore"

  if [[ ! -f "$entries_file" ]]; then
    return
  fi

  if [[ ! -f "$gitignore" ]]; then
    touch "$gitignore"
  fi

  local added=0
  while IFS= read -r line || [[ -n "$line" ]]; do
    # Skip comments and empty lines
    [[ "$line" =~ ^#.*$ || -z "$line" ]] && continue
    if ! grep -qxF "$line" "$gitignore"; then
      echo "$line" >> "$gitignore"
      added=$((added + 1))
    fi
  done < "$entries_file"

  if [[ $added -gt 0 ]]; then
    print_ok "Added $added entries to .gitignore"
  else
    print_info ".gitignore entries already present"
  fi
}

merge_gitignore

# ─────────────────────────────────────────────
# Merge MCP entries (base + modules)
# ─────────────────────────────────────────────

merge_mcp_entry() {
  local entry_file="$1"
  local mcp_file="$TARGET_DIR/.mcp.json"

  if ! command -v jq &>/dev/null; then
    print_warn "jq not found — skipping automatic MCP merge for module."
    print_info "Manually add the contents of $entry_file to .mcp.json"
    return
  fi

  local merged
  merged="$(jq -s '.[0].mcpServers * .[1] | {mcpServers: .}' "$mcp_file" "$entry_file")"
  echo "$merged" > "$mcp_file"
}

# ─────────────────────────────────────────────
# Install selected modules
# ─────────────────────────────────────────────

if [[ ${#SELECTED_MODULES[@]} -gt 0 ]]; then
  print_step "Installing modules"

  for module in "${SELECTED_MODULES[@]}"; do
    echo ""
    echo -e "  ${BOLD}Module: $module${RESET}"

    local_module_dir="$SOURCE_DIR/modules/$module"

    if [[ ! -d "$local_module_dir" ]]; then
      print_warn "Module directory not found: $local_module_dir"
      continue
    fi

    # Copy module template files
    local module_template="$local_module_dir/template"
    if [[ -d "$module_template" ]]; then
      while IFS= read -r -d '' file; do
        copy_file "$file"
      done < <(find "$module_template" -type f -print0)
    fi

    # Merge project-scoped MCP entries
    local meta_file="$local_module_dir/meta.json"
    local mcp_entry="$local_module_dir/mcp-entry.json"
    local mcp_scope=""

    if [[ -f "$meta_file" ]] && command -v jq &>/dev/null; then
      mcp_scope="$(jq -r '.mcpScope // empty' "$meta_file")"
    fi

    if [[ -f "$mcp_entry" && "$mcp_scope" == "project" ]]; then
      merge_mcp_entry "$mcp_entry"
      print_ok "Merged $module MCP server into .mcp.json"
    fi

    print_ok "$module installed"
  done
fi

# ─────────────────────────────────────────────
# User-scoped tool setup
# ─────────────────────────────────────────────

print_step "Setting up user-scoped tools"
echo ""

CLAUDE_CMD=""
if command -v claude &>/dev/null; then
  CLAUDE_CMD="claude"
else
  print_warn "claude CLI not found. Install it first: npm install -g @anthropic-ai/claude-code"
  print_info "Skipping user-scoped MCP setup. Re-run the script after installing Claude Code."
fi

setup_user_mcp() {
  local name="$1"
  local command_str="$2"
  local env_var="${3:-}"
  local prompt="${4:-}"
  local token_val=""

  echo -e "  ${BOLD}$name${RESET}"

  if [[ -n "$env_var" ]]; then
    if [[ -n "${!env_var:-}" ]]; then
      token_val="${!env_var}"
      print_info "Using \$$env_var from environment"
    else
      read -rsp "  $prompt " token_val
      echo ""
    fi
    export "$env_var=$token_val"
  fi

  if [[ -n "$CLAUDE_CMD" ]]; then
    if eval "$command_str" &>/dev/null 2>&1; then
      print_ok "Installed"
    else
      print_warn "Install command failed — you may need to set this up manually"
    fi
  fi
}

# Always-installed user-scoped servers
echo -e "  ${DIM}Setting up GitHub MCP (no token needed — uses your GitHub CLI auth)${RESET}"
if [[ -n "$CLAUDE_CMD" ]]; then
  claude mcp add --scope user github -- npx -y "@github/mcp-server@latest" &>/dev/null 2>&1 \
    && print_ok "GitHub MCP installed" \
    || print_warn "GitHub MCP: run 'gh auth login' first, then re-run this script"
fi

# User-scoped servers from selected modules
for module in "${SELECTED_MODULES[@]}"; do
  local_module_dir="$SOURCE_DIR/modules/$module"
  meta_file="$local_module_dir/meta.json"
  mcp_entry="$local_module_dir/mcp-entry.json"

  if [[ ! -f "$meta_file" ]] || ! command -v jq &>/dev/null; then
    continue
  fi

  mcp_scope="$(jq -r '.mcpScope // empty' "$meta_file")"
  [[ "$mcp_scope" != "user" ]] && continue

  module_name="$(jq -r '.name' "$meta_file")"
  setup_prompt="$(jq -r '.setupPrompt // empty' "$meta_file")"
  env_var="$(jq -r '.requiresEnv[0] // empty' "$meta_file")"

  echo ""
  echo -e "  ${BOLD}$module_name MCP${RESET}"

  token_val=""
  if [[ -n "$env_var" ]]; then
    if [[ -n "${!env_var:-}" ]]; then
      token_val="${!env_var}"
      print_info "Using \$$env_var from environment"
    else
      read -rsp "  $setup_prompt " token_val
      echo ""
    fi
  fi

  if [[ -n "$CLAUDE_CMD" && -f "$mcp_entry" ]] && command -v jq &>/dev/null; then
    # Build claude mcp add command from mcp-entry.json
    local_server_name="$(jq -r 'keys[0]' "$mcp_entry")"
    local_cmd="$(jq -r ".[\"$local_server_name\"].command" "$mcp_entry")"
    local_args="$(jq -r ".[\"$local_server_name\"].args | join(\" \")" "$mcp_entry")"
    local_env_flag=""
    if [[ -n "$env_var" && -n "$token_val" ]]; then
      local_env_flag="-e $env_var=$token_val"
    fi

    if claude mcp add --scope user $local_env_flag "$local_server_name" -- $local_cmd $local_args &>/dev/null 2>&1; then
      print_ok "$module_name MCP installed"
    else
      print_warn "$module_name MCP: install failed. Add manually if needed."
    fi
  fi
done

# ─────────────────────────────────────────────
# Done
# ─────────────────────────────────────────────

echo ""
echo -e "${BOLD}${GREEN}╔═══════════════════════════════════════╗${RESET}"
echo -e "${BOLD}${GREEN}║   Installation complete!              ║${RESET}"
echo -e "${BOLD}${GREEN}╚═══════════════════════════════════════╝${RESET}"
echo ""
echo -e "  ${BOLD}Files installed:${RESET}"
echo -e "  ${DIM}CLAUDE.md, .mcp.json, AI-TOOLING-SETUP.md${RESET}"
echo -e "  ${DIM}.claude/skills/ — component-patterns, project-conventions${RESET}"
echo -e "  ${DIM}.claude/commands/ — design-review, generate-component${RESET}"
[[ ${#SELECTED_MODULES[@]} -gt 0 ]] && echo -e "  ${DIM}Modules: ${SELECTED_MODULES[*]}${RESET}"
echo ""
echo -e "  ${BOLD}Next steps:${RESET}"
echo -e "  ${DIM}1. Review and customize CLAUDE.md for your project${RESET}"
echo -e "  ${DIM}2. Commit the new files: git add .claude CLAUDE.md .mcp.json AI-TOOLING-SETUP.md${RESET}"
echo -e "  ${DIM}3. Share AI-TOOLING-SETUP.md with teammates${RESET}"
echo -e "  ${DIM}4. Open Claude Code in this project to activate the config${RESET}"
echo ""
