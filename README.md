# cc-devenv-doctor

One command to take a bare Windows or Mac machine to a working [Claude Code](https://claude.com/claude-code) setup — plus a plugin that keeps diagnosing it afterwards.

> ภาษาไทย: [README.th.md](./README.th.md)

## Why this exists

This started at an **AI Agentic Engineering for IT** exam.

The material was not the hard part. Getting everyone's machine ready was. Installing git, then Node, then VS Code, then Docker, then the Claude Code CLI — one command at a time, across Windows and Mac at once, with PATH not refreshing, with installers that stop to ask a question nobody in the room knows how to answer. Hours went into that. Hours that were supposed to go into the actual subject.

The frustrating part is that none of it was interesting. It was the same handful of commands every time, in the same order, failing in the same few ways. That is exactly the kind of problem worth solving once and giving away, so nobody else has to spend their morning on it.

So: one script per OS, and a plugin that can tell you what's still broken afterwards.

## What it installs

- **Git**
- **Node.js** (LTS)
- **Bun** — required by claude-mem, which doesn't install it for you
- **Claude Code CLI** (via the official native installer)
- **[devenv-doctor](./devenv-doctor)** — the plugin bundled in this repo. Run `/devenv-doctor:environment-doctor` in Claude Code and it runs the real checks, then tells you exactly what to fix
- **Docker Desktop**, including WSL2 setup on Windows if it's missing
- **VS Code** + two extensions: [Claude Code](https://marketplace.visualstudio.com/items?itemName=anthropic.claude-code) and Docker
- **[mattpocock-skills](https://github.com/mattpocock/skills)** — a plugin on Anthropic's official marketplace (grilling, TDD, code review, and more)

## The last two are examples, not the point

The VS Code extensions and mattpocock-skills are here as **examples of what a ready machine looks like** — not as a claim that these are the right choices for you. The real point of the script is that once the base is working, adding the next skill or extension is a one-liner instead of an afternoon. They're in the list to show the shape of that, and to give someone brand new something that already works on day one.

Swap them for whatever you actually use. That's the intended way to fork this.

### On VS Code specifically

Straight answer: **I haven't opened VS Code since October 2025.** Not once.

It's in the script anyway, and I think that's the right call — if you're new, an editor that already has the Claude Code extension in it is the shortest path to something that works, and a much friendlier landing spot than a bare terminal.

But don't read its presence here as a recommendation from someone who uses it daily. If you already have an editor you like, delete that block from the script. Nothing else depends on it.

## Quick start

### If you have git

**Windows (PowerShell):**
```powershell
git clone https://github.com/killernay/cc-devenv-doctor.git
cd cc-devenv-doctor
powershell -ExecutionPolicy Bypass -File setup.ps1
```

**macOS:**
```bash
git clone https://github.com/killernay/cc-devenv-doctor.git
cd cc-devenv-doctor
bash setup.sh
```

### If you don't have git yet

1. Go to [github.com/killernay/cc-devenv-doctor](https://github.com/killernay/cc-devenv-doctor), click **Code → Download ZIP**, and extract it
2. Open a terminal / PowerShell inside the extracted folder — GitHub names it **`cc-devenv-doctor-main`**, not `cc-devenv-doctor`
3. Run the same script as above — `bash setup.sh` (macOS) or `powershell -ExecutionPolicy Bypass -File setup.ps1` (Windows). The script installs git for you along the way.

The script is idempotent — safe to run more than once. It skips anything already installed and reports a pass/fail summary at the end.

### One question the script asks you

Near the start it asks **where the plugins should be enabled**:

- **user** (recommended) — writes `~/.claude/settings.json`, so the plugins work in every project on this machine
- **project** — writes `.claude/settings.json` into the folder you ran the script from, so the plugins only load while you're inside *that folder*

Just press Enter to get `user`. Pick `project` only if you deliberately want the plugins scoped to one project — and note that if you ran the script from your downloads folder, `project` means "only in the downloads folder", which is almost certainly not what you want.

To skip the prompt entirely, set the scope up front:

```bash
PLUGIN_SCOPE=user bash setup.sh
```
```powershell
$env:PLUGIN_SCOPE="user"; powershell -ExecutionPolicy Bypass -File setup.ps1
```

### Just want the devenv-doctor plugin, not the full bootstrap?

Already have Claude Code **and git**? Two commands. No clone, no ZIP, no `cd` — `marketplace add` does the clone for you:

```
claude plugin marketplace add killernay/cc-devenv-doctor
claude plugin install devenv-doctor
```

Then open `claude` and run:

```
/devenv-doctor:environment-doctor
```

That's it. It installs to **user** scope, so it works in every project on this machine.

`marketplace add` shells out to `git clone`, so git has to be installed — without it you get *"Failed to clone marketplace repository"*. No git yet? Run the setup script above instead; it installs git along the way.

If a Claude Code session was already open while you installed, run `/reload-plugins` first — plugins are scanned at session start. A session started *after* the install picks it up on its own.

### Removing it again

```
claude plugin uninstall devenv-doctor@ngernthongdee
claude plugin marketplace remove ngernthongdee
```

Uninstall takes the full `name@marketplace` id — that's what `claude plugin list` shows. Removing the marketplace is the second, separate step; without it the marketplace stays registered with nothing installed from it.

#### ภาษาไทย

มี Claude Code **กับ git** อยู่แล้ว อยากได้แค่ปลั๊กอิน ไม่ต้อง clone เอง ไม่ต้องโหลด ZIP ไม่ต้อง `cd` ไปไหน:

```
claude plugin marketplace add killernay/cc-devenv-doctor
claude plugin install devenv-doctor
```

แล้วเปิด `claude` พิมพ์ `/devenv-doctor:environment-doctor` จบ — ติดตั้งเป็น scope **user** คือใช้ได้ทุกโปรเจกต์บนเครื่องนี้

`marketplace add` เรียก `git clone` ข้างใน เครื่องต้องมี git ไม่งั้นขึ้น *"Failed to clone marketplace repository"* — ถ้ายังไม่มี git ให้รันสคริปต์ setup ด้านบนแทน มันลง git ให้ด้วย

ถ้าตอนติดตั้งมีเซสชัน Claude Code เปิดค้างอยู่ ให้ `/reload-plugins` ก่อน เพราะปลั๊กอินถูกสแกนตอนเปิดเซสชัน เซสชันที่เปิดใหม่หลังติดตั้งไม่ต้องทำ

ถอนออก:

```
claude plugin uninstall devenv-doctor@ngernthongdee
claude plugin marketplace remove ngernthongdee
```

`uninstall` ต้องใส่ id เต็ม `name@marketplace` ตามที่ `claude plugin list` แสดง และต้องลบ marketplace เป็นอีกขั้นแยกต่างหาก ไม่งั้น marketplace จะยังค้างอยู่ทั้งที่ไม่มีปลั๊กอินเหลือแล้ว

## What still needs a human

Three things genuinely can't be scripted, because they need you personally to prove who you are or to answer a question:

1. **Logging in** — run `claude` after the script finishes; it opens your browser for you to sign in
2. **`npx claude-mem install`** — gives Claude Code memory that persists across sessions. It's an interactive installer that asks a couple of questions (which provider to use, etc.). Same category as the extensions above: an example of what you can bolt on once the base works. It needs Bun, which the script installs for you — if `Bun` showed `[!]` in the summary, fix that first, or claude-mem installs cleanly and then silently does nothing
3. **A restart**, if the script had to install WSL2 on Windows for you (Docker Desktop needs it) — the script tells you clearly if this applies

If the devenv-doctor or mattpocock-skills steps show `[!]` in the summary, it's usually because you weren't logged in yet when the script reached them. Log in, then re-run the script — it skips everything that already succeeded.

## devenv-doctor

Once installed, run **`/devenv-doctor:environment-doctor`** in any Claude Code session — or just describe the problem ("my setup is broken", "why isn't docker working"), which fires the same skill. It runs the real checks — git, Node, VS Code extensions, Docker, claude-mem, installed plugins — and gives you exact fix commands for whatever's missing, for your OS. Every check is read-only and pre-approved, so it won't interrupt you with permission prompts.

If it doesn't respond, the session was open before the plugin was installed — run `/reload-plugins`, or just start a new session.

### What it looks like

On a machine where the setup script has already run, the report comes back like this:

| Check | Status | Detail |
|---|---|---|
| git | ✅ | 2.54.0 |
| Node.js | ✅ | v22.22.2 (≥20) |
| Bun | ✅ | 1.3.13 |
| VS Code | ✅ | 1.131.0 |
| Docker | ✅ | 29.6.2, engine running |
| Claude Code CLI | ✅ | 2.1.222 |
| claude-mem | ✅ | installed, plugin v13.13.1 enabled |
| devenv-doctor | ✅ | 0.2.0, scope user, enabled |
| marketplace `ngernthongdee` | ✅ | Directory `/Users/you/Downloads/cc-devenv-doctor-main` |
| anthropic.claude-code | ✅ | |
| ms-azuretools.vscode-docker | ✅ | |

Anything that isn't ✅ comes back with the exact command to fix it, for your OS.

It also knows the two failures that look like success: a plugin installed into the wrong scope, and a plugin whose marketplace was never added.

## Why not just `npm install -g @anthropic-ai/claude-code`?

That installs Claude Code itself and leaves you to install git, Node, VS Code and Docker separately, and to work out the plugin syntax on your own — which is exactly where the morning goes.

## Development

macOS ships **bash 3.2**, and a bare machine has no newer one on `PATH` — which is precisely the machine `setup.sh` targets. Keep it bash-3.2 compatible: no negative array indices (`${arr[-1]}`), no associative arrays, and never expand `"${arr[@]}"` without a length check while `set -u` is on. `bash -n` will not catch any of these; they fail only at runtime.

In PowerShell, native commands (`winget`, `claude`, `code`) don't raise terminating errors, so `try`/`catch` around them never fires. Test `$LASTEXITCODE` instead.

Validate the plugin manifests before pushing:

```bash
claude plugin validate . --strict
claude plugin validate ./devenv-doctor --strict
```

## Contributing

Issues and PRs welcome — especially anything that removes a step a beginner currently has to do by hand.

## License

MIT — see [LICENSE](./LICENSE). Take it, fork it, swap the extension list for your own.
