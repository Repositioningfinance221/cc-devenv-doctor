#!/usr/bin/env bash
# ===================================================================
# cc-devenv-doctor — macOS setup
# Usage: bash setup.sh
#        PLUGIN_SCOPE=user bash setup.sh    # skip the scope prompt
# Safe to re-run (idempotent) — skips anything already installed.
#
# COMPATIBILITY: macOS ships bash 3.2, and a bare machine has no newer
# one on PATH yet — which is exactly the machine this script targets.
# Keep it bash-3.2 compatible:
#   - no negative array indices   ${arr[-1]}
#   - no associative arrays       declare -A
#   - never expand "${arr[@]}" without a length check while `set -u` is on
# `bash -n` does NOT catch these; they only fail at runtime.
# ===================================================================
set -uo pipefail

RESULTS=()
has() { command -v "$1" >/dev/null 2>&1; }
report() {
  local step="$1" ok="$2" note="${3:-}" line
  if [ "$ok" = "1" ]; then
    line="[v] $step $note"
  else
    line="[!] $step $note"
  fi
  RESULTS+=("$line")
  echo "$line"
}

echo "=== cc-devenv-doctor — macOS setup ==="
echo ""

# --- Plugin scope — your choice, because it decides where plugins work ---
# 'project' writes .claude/settings.json into the CURRENT folder, so the
# plugins only load while you're inside it. For a bootstrap run that folder
# is usually this download, which is not where you'll actually be working.
PLUGIN_SCOPE="${PLUGIN_SCOPE:-}"
if [ -z "$PLUGIN_SCOPE" ]; then
  scope_choice=""
  if [ -t 0 ]; then
    echo "Where should the Claude Code plugins be enabled?"
    echo "  1) user    - every project on this machine (~/.claude/settings.json)   [recommended]"
    echo "  2) project - only this folder ($PWD/.claude/settings.json)"
    printf "Choose 1 or 2 [1]: "
    read -r scope_choice
  fi
  case "$scope_choice" in
    2) PLUGIN_SCOPE="project" ;;
    *) PLUGIN_SCOPE="user" ;;
  esac
fi
case "$PLUGIN_SCOPE" in
  user|project|local) ;;
  *) echo "Unknown PLUGIN_SCOPE '$PLUGIN_SCOPE' — using 'user' instead"; PLUGIN_SCOPE="user" ;;
esac
echo "Plugin scope: $PLUGIN_SCOPE"
echo ""

# --- Homebrew ---
if ! has brew; then
  echo "Homebrew not found — installing (will ask for your password)..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [ -x /usr/local/bin/brew ]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
fi
report "Homebrew" "$(has brew && echo 1 || echo 0)"

# --- Git ---
if has git; then
  report "Git" 1
else
  brew install git
  report "Git" "$(has git && echo 1 || echo 0)"
fi

# --- Node.js ---
if has node; then
  report "Node.js" 1
else
  brew install node
  report "Node.js" "$(has node && echo 1 || echo 0)"
fi

# --- Bun (claude-mem's hooks and worker run on it — `npx claude-mem install`
# does NOT install it, it just fails later with "Bun runtime not found") ---
# bun may already be here from the bun.sh installer, which puts it outside
# brew's prefix and only writes PATH into shell rc files this session hasn't read
[ -x "$HOME/.bun/bin/bun" ] && export PATH="$HOME/.bun/bin:$PATH"
if has bun; then
  report "Bun" 1
else
  brew install bun
  report "Bun" "$(has bun && echo 1 || echo 0)"
fi

# --- VS Code ---
if has code; then
  report "VS Code" 1
else
  brew install --cask visual-studio-code
  report "VS Code" "$(has code && echo 1 || echo 0)" "if 'code' still isn't found: open VS Code once, then Cmd+Shift+P > 'Shell Command: Install code command in PATH'"
fi

# --- VS Code extensions ---
if has code; then
  for ext in anthropic.claude-code ms-azuretools.vscode-docker; do
    code --install-extension "$ext" --force >/dev/null 2>&1
  done
  report "VS Code extensions" 1 "(Claude Code, Docker)"
else
  report "VS Code extensions" 0 "skipped — 'code' not found"
fi

# --- Claude Code CLI (native installer) ---
if has claude; then
  report "Claude Code CLI" 1
else
  curl -fsSL https://claude.ai/install.sh | bash
  report "Claude Code CLI" "$(has claude && echo 1 || echo 0)" "if still not found, open a new terminal and re-run this script"
fi

# --- devenv-doctor plugin (ships as part of this repo — no download needed) ---
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if has claude; then
  if [ -f "$SCRIPT_DIR/.claude-plugin/marketplace.json" ]; then
    # 'marketplace add' is non-fatal on re-runs — it may already be registered.
    claude plugin marketplace add "$SCRIPT_DIR" >/dev/null 2>&1 || true
    if claude plugin install devenv-doctor --scope "$PLUGIN_SCOPE" >/dev/null 2>&1; then
      report "devenv-doctor plugin" 1 "(scope: $PLUGIN_SCOPE)"
    else
      report "devenv-doctor plugin" 0 "install failed — you probably need to run 'claude' and log in first, then re-run this script"
    fi
  else
    report "devenv-doctor plugin" 0 ".claude-plugin/marketplace.json not found next to this script — make sure you cloned/downloaded the full repo"
  fi
else
  report "devenv-doctor plugin" 0 "skipped — Claude Code CLI not found"
fi

# --- Optional: mattpocock-skills (grilling, tdd, code-review), now on Anthropic's official marketplace ---
if has claude; then
  claude plugin marketplace add anthropics/claude-plugins-official >/dev/null 2>&1 || true
  if claude plugin install mattpocock-skills@claude-plugins-official --scope "$PLUGIN_SCOPE" >/dev/null 2>&1; then
    report "mattpocock-skills (optional)" 1 "(scope: $PLUGIN_SCOPE)"
  else
    report "mattpocock-skills (optional)" 0 "install failed — log in first via 'claude', then re-run (command is 'claude plugin install', singular 'plugin')"
  fi
else
  report "mattpocock-skills (optional)" 0 "skipped — Claude Code CLI not found"
fi

# --- Docker Desktop ---
if has docker; then
  report "Docker" 1
else
  brew install --cask docker
  report "Docker" 0 "installed — open Docker.app once to start the engine (macOS may ask for a Privacy/Security permission the first time)"
fi

echo ""
echo "=== Summary ==="
if [ ${#RESULTS[@]} -gt 0 ]; then
  for r in "${RESULTS[@]}"; do echo "$r"; done
fi

echo ""
echo "=== 2 steps left that truly can't be automated ==="
echo "1) Open a new terminal (important if anything was installed for the first time) and run: claude   -> opens your browser to log in with your Claude account"
echo "2) After logging in, run: npx claude-mem install   -> answer the prompts (pick Claude Code as the provider)"
echo ""
echo "If 'Bun' shows [!] above, fix that BEFORE step 2 — claude-mem installs fine without Bun and then silently does nothing, because its hooks and worker run on Bun. Install it with: brew install bun"
echo ""
echo "If 'devenv-doctor plugin' or 'mattpocock-skills' show [!] above, that's almost always because you weren't logged in yet on this run — log in, then re-run this script; it will skip what already succeeded."
echo "Once everything passes, open Claude Code and run: /devenv-doctor:environment-doctor   (if a session was already open during this script, run /reload-plugins first)"
