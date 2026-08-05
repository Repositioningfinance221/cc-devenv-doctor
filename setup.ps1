# ===================================================================
# cc-devenv-doctor — Windows setup
# Usage: powershell -ExecutionPolicy Bypass -File setup.ps1
#        $env:PLUGIN_SCOPE="user"; ... -File setup.ps1   # skip the scope prompt
# Safe to re-run (idempotent) — skips anything already installed.
#
# NOTE: native commands (winget, claude, code) do NOT raise terminating
# errors, so try/catch never fires for them. Always test $LASTEXITCODE.
# ===================================================================

$ErrorActionPreference = "Continue"
$script:results = @()

function Test-Cmd($name) { return [bool](Get-Command $name -ErrorAction SilentlyContinue) }

function Report($step, $ok, $note = "") {
  $mark = if ($ok) { "OK" } else { "FAIL" }
  $script:results += "$mark|$step|$note"
  Write-Host "[$mark] $step $note"
}

function Refresh-Path {
  $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
}

Write-Host "=== cc-devenv-doctor — Windows setup ===`n"

# --- Plugin scope — your choice, because it decides where plugins work ---
# 'project' writes .claude\settings.json into the CURRENT folder, so the
# plugins only load while you're inside it. For a bootstrap run that folder
# is usually this download, which is not where you'll actually be working.
$pluginScope = $env:PLUGIN_SCOPE
if (-not $pluginScope) {
  if (-not [Console]::IsInputRedirected) {
    Write-Host "Where should the Claude Code plugins be enabled?"
    Write-Host "  1) user    - every project on this machine (~\.claude\settings.json)   [recommended]"
    Write-Host "  2) project - only this folder ($PWD\.claude\settings.json)"
    $scopeChoice = Read-Host "Choose 1 or 2 [1]"
    if ($scopeChoice -eq "2") { $pluginScope = "project" } else { $pluginScope = "user" }
  } else {
    $pluginScope = "user"
  }
}
if ($pluginScope -notin @("user", "project", "local")) {
  Write-Host "Unknown PLUGIN_SCOPE '$pluginScope' — using 'user' instead"
  $pluginScope = "user"
}
Write-Host "Plugin scope: $pluginScope`n"

# --- winget ---
if (-not (Test-Cmd "winget")) {
  Report "winget" $false "winget not found — update Windows or install 'App Installer' from the Microsoft Store, then re-run this script"
  Write-Host "`nStopping here — the next steps need winget"
  exit 1
} else {
  Report "winget" $true
}

# --- Git ---
if (Test-Cmd "git") {
  Report "Git" $true
} else {
  winget install --id Git.Git -e --source winget --accept-source-agreements --accept-package-agreements
  Refresh-Path
  Report "Git" (Test-Cmd "git")
}

# --- Node.js LTS (needed to run npx claude-mem install later) ---
if (Test-Cmd "node") {
  Report "Node.js" $true
} else {
  winget install --id OpenJS.NodeJS.LTS -e --source winget --accept-source-agreements --accept-package-agreements
  Refresh-Path
  Report "Node.js" (Test-Cmd "node")
}

# --- Bun (claude-mem's hooks and worker run on it — `npx claude-mem install`
# does NOT install it, it just fails later with "Bun runtime not found") ---
$bunExe = "$env:USERPROFILE\.bun\bin\bun.exe"
if ((Test-Cmd "bun") -or (Test-Path $bunExe)) {
  Report "Bun" $true
} else {
  irm https://bun.sh/install.ps1 | iex
  Refresh-Path
  # the installer only writes the persisted PATH, so this session still needs it
  if (Test-Path $bunExe) { $env:Path = "$env:USERPROFILE\.bun\bin;$env:Path" }
  Report "Bun" (Test-Cmd "bun") "needed by claude-mem"
}

# --- VS Code ---
if (Test-Cmd "code") {
  Report "VS Code" $true
} else {
  winget install --id Microsoft.VisualStudioCode -e --source winget --accept-source-agreements --accept-package-agreements
  Refresh-Path
  Report "VS Code" (Test-Cmd "code") "If 'code' still isn't found, close and reopen PowerShell then re-run this script"
}

# --- VS Code extensions ---
if (Test-Cmd "code") {
  $exts = @(
    "anthropic.claude-code",
    "eamodio.gitlens",
    "ms-azuretools.vscode-docker",
    "dbaeumer.vscode-eslint",
    "esbenp.prettier-vscode"
  )
  foreach ($e in $exts) {
    code --install-extension $e --force | Out-Null
  }
  Report "VS Code extensions" $true "(Claude Code, GitLens, Docker, ESLint, Prettier)"
} else {
  Report "VS Code extensions" $false "skipped — 'code' not found in this terminal"
}

# --- Claude Code CLI (native installer) ---
if (Test-Cmd "claude") {
  Report "Claude Code CLI" $true
} else {
  irm https://claude.ai/install.ps1 | iex
  Refresh-Path
  Report "Claude Code CLI" (Test-Cmd "claude") "If still not found, close/reopen PowerShell and re-run this script (PATH not refreshed is the #1 cause)"
}

# --- devenv-doctor plugin (ships as part of this repo — no download needed) ---
$marketplaceManifest = Join-Path $PSScriptRoot ".claude-plugin\marketplace.json"
if (Test-Cmd "claude") {
  if (Test-Path $marketplaceManifest) {
    # 'marketplace add' is non-fatal on re-runs — it may already be registered.
    claude plugin marketplace add $PSScriptRoot 2>&1 | Out-Null
    claude plugin install devenv-doctor --scope $pluginScope 2>&1 | Out-Null
    if ($LASTEXITCODE -eq 0) {
      Report "devenv-doctor plugin" $true "(scope: $pluginScope)"
    } else {
      Report "devenv-doctor plugin" $false "install failed — you probably need to run 'claude' and log in first, then re-run this script"
    }
  } else {
    Report "devenv-doctor plugin" $false ".claude-plugin\marketplace.json not found next to this script — make sure you cloned/downloaded the full repo"
  }
} else {
  Report "devenv-doctor plugin" $false "skipped — Claude Code CLI not found"
}

# --- Optional: mattpocock-skills (community plugin: grilling, tdd, code-review) ---
# Its marketplace is NOT known by default — it has to be added before the
# plugin name '@mattpocock' can resolve to anything.
if (Test-Cmd "claude") {
  claude plugin marketplace add mattpocock/skills 2>&1 | Out-Null
  claude plugin install mattpocock-skills@mattpocock --scope $pluginScope 2>&1 | Out-Null
  if ($LASTEXITCODE -eq 0) {
    Report "mattpocock-skills (optional)" $true "(scope: $pluginScope)"
  } else {
    Report "mattpocock-skills (optional)" $false "install failed — log in first via 'claude', then re-run (command is 'claude plugin install', singular 'plugin')"
  }
} else {
  Report "mattpocock-skills (optional)" $false "skipped — Claude Code CLI not found"
}

# --- WSL2 (required for Docker Desktop on Windows — check/install before Docker) ---
$needsRestart = $false
$wslOk = $false
wsl --status *> $null
if ($LASTEXITCODE -eq 0) { $wslOk = $true }

if ($wslOk) {
  Report "WSL2" $true
} else {
  Write-Host "WSL2 not found — installing (required for Docker Desktop on Windows)..."
  wsl --install --no-distribution
  $needsRestart = $true
  Report "WSL2" $false "installed, but you must restart your PC once before Docker's engine will start — restart, then re-run this script"
}

# --- Docker Desktop ---
if (Test-Cmd "docker") {
  Report "Docker" $true
} else {
  winget install --id Docker.DockerDesktop -e --source winget --accept-source-agreements --accept-package-agreements
  Start-Process "$env:ProgramFiles\Docker\Docker\Docker Desktop.exe" -ErrorAction SilentlyContinue
  if ($needsRestart) {
    Report "Docker" $false "installed — restart your PC (needed because WSL2 was just installed above), then open Docker Desktop once"
  } else {
    Report "Docker" $false "installed — open Docker Desktop once to start the engine (takes 1-2 minutes)"
  }
}

Write-Host "`n=== Summary ==="
foreach ($r in $script:results) {
  $parts = $r.Split("|")
  $icon = if ($parts[0] -eq "OK") { "[v]" } else { "[!]" }
  Write-Host "$icon $($parts[1]) $($parts[2])"
}

Write-Host "`n=== 2 steps left that truly can't be automated ==="
Write-Host "1) Open a new PowerShell window (important if anything was installed for the first time) and run: claude   -> opens your browser to log in with your Claude account"
Write-Host "2) After logging in, run: npx claude-mem install   -> answer the prompts (pick Claude Code as the provider)"
Write-Host "`nIf 'Bun' shows [!] above, fix that BEFORE step 2 — claude-mem installs fine without Bun and then silently does nothing, because its hooks and worker run on Bun. Install it with: irm https://bun.sh/install.ps1 | iex"
Write-Host "`nIf 'devenv-doctor plugin' or 'mattpocock-skills' show [!] above, that's almost always because you weren't logged in yet on this run — log in, then re-run this script; it will skip what already succeeded."
Write-Host "Once everything passes, try typing 'check my setup' in Claude Code — devenv-doctor will diagnose itself."
