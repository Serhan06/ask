# ask

A Bash CLI tool that sends prompts to any OpenAI-compatible API.
Built with only `curl` and `jq` — no extra dependencies.

## Requirements

- `bash`
- `curl`
- `jq`
- `make` (only needed for the pipeline — see below)

### Installing `jq`

**macOS**
```bash
brew install jq
```

**Ubuntu / Debian**
```bash
sudo apt install jq
```

**Windows**
```bash
winget install jqlang.jq --accept-source-agreements --accept-package-agreements
```
> After installing on Windows, open a **new terminal** so the PATH update takes effect. Run the script inside **Git Bash**, not PowerShell or CMD.

### Installing `make`

**macOS** — comes pre-installed. If missing:
```bash
xcode-select --install
```

**Ubuntu / Debian**
```bash
sudo apt install make
```

**Windows** — `make` is not available in PowerShell or CMD. Use one of:

- **Option A (recommended):** Install [Git for Windows](https://git-scm.com/download/win), which includes Git Bash. Then install make via winget:
  ```bash
  winget install GnuWin32.Make --accept-source-agreements --accept-package-agreements
  ```
  Open a **new Git Bash terminal** after installing so the PATH update takes effect.

- **Option B:** Use [WSL](https://learn.microsoft.com/en-us/windows/wsl/install) (Windows Subsystem for Linux) and run everything inside a Linux shell.

> **Windows users:** All commands in this README (`make`, `./ask`, `export`, etc.) must be run inside **Git Bash** or **WSL** — not PowerShell or CMD.

## Setup

Clone the repo and make the script executable:

```bash
git clone https://github.com/Serhan06/ask.git
cd ask
chmod +x ask
```

Set these environment variables (replace the placeholders with your actual values):

```bash
export ASK_API_URL="https://api.groq.com/openai/v1/chat/completions"
export ASK_MODEL="llama-3.3-70b-versatile"
export ASK_API_KEY="your-api-key-here"
```

> You can get a free Groq API key at https://console.groq.com

> **Note:** These exports last only for the current terminal session. You need to re-run them each time you open a new terminal, or add them to your shell's config file (e.g. `~/.bashrc` or `~/.zshrc`).

## Usage

```bash
# Basic prompt
./ask "What is the tallest mountain in the world?"

# Multiple arguments are joined into one prompt
./ask "Establishment dates of" "Turkey" "Azerbaijan" "Japan"

# Pipe a file into the prompt
cat script.sh | ./ask "Explain what this script does:"

# Combine pipe and arguments
./ask "Explain this output:" "$(uname -a)"

# Use as an alias
alias ask-fix="./ask 'Fix any grammar or spelling errors in the following text:'"
ask-fix "Rhythim is evrywhere"
```

## Pipeline (make -j)

The repository includes a `Makefile` and a sample `codebase.txt` that run a 5-phase LLM review pipeline and produce a final `action.plan.md`.

Set the environment variables first (see Setup above), then:

```bash
# Run the full pipeline in parallel
make -j

# Remove all generated files and start fresh
make clean
```

The pipeline produces these files in order:

```
codebase.txt
  ├── quality.md   ──► quality.sum.md ──┐
  ├── perf.md      ──► perf.sum.md    ──┼──► concatenated.md ──► refined.md ──► action.plan.md
  └── security.md  ──► security.sum.md ─┘
```

Make only rebuilds what has changed — for example, if only `refined.md` is modified, only `action.plan.md` is regenerated.

## Known Limitations

- No conversation history — every call is independent
- No streaming — output appears only after the full response is received
- Requires the API provider to be reachable from your network
- Environment variables must be set manually in each new terminal session

## License

MIT
