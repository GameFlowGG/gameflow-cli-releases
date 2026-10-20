# GameFlow CLI — Releases

This repository hosts **builds** of the GameFlow CLI.

---

## What is GameFlow?

[GameFlow](https://www.gameflow.gg/) is a self-driving multiplayer infrastructure platform built for game developers. It handles the heavy lifting so you can focus on building great games.

**Key features:**

- **Game Server Hosting** — Deploy servers globally with automatic ping-based routing and DDoS protection
- **Matchmaking** — Visual rule engine for balanced, competitive matchmaking
- **Skill Rating** — AI-powered rating models without needing a data science team
- **Analytics** — Real-time stats, server monitoring, and performance insights
- **SDKs & APIs** — Integrate quickly with developer-friendly tooling

Learn more at [gameflow.gg](https://www.gameflow.gg/) · [docs.gameflow.gg](https://docs.gameflow.gg/)

---

## About the CLI

The GameFlow CLI lets you manage your GameFlow resources from the terminal — builds, server fleets, matchmaking configuration, and more. It is built for CI/CD pipelines, scripts, and AI agents as well as for people at a terminal.

### Quick start

```sh
gameflow login --api-key <your-key>
gameflow games list
gameflow builds create --game-id <id> --file ./server.zip --version 1.0.0
```

### Commands

| Area | Commands |
|------|----------|
| Auth | `login`, `logout`, `whoami` |
| Games | `games list`, `games get` |
| Builds | `builds list`, `builds status`, `builds create`, `builds tag` |
| Servers | `servers list`, `servers launch`, `servers stop`, `servers logs` |
| Regions | `regions list` |
| Misc | `version`, `schema`, `--api-info` |

Run `gameflow <command> --help` for flags.

Notable flags:

- `builds create --tag <tag>` assigns tags at upload time (repeatable, e.g. `--tag stable --tag canary`). `--poll-interval` sets how often build status is polled, and `--no-progress` disables the progress bar.
- `builds tag --tag <tag>` **replaces** the build's existing tags rather than adding to them.
- Global flags: `--debug` logs the underlying HTTP API calls to stderr, and `--pretty` pretty-prints JSON output.

### Pagination

List commands make a single request by default. Pass a flag to page through results:

| Command | Flags | Next page |
|---------|-------|-----------|
| `servers list` | `--limit` (max 50), `--cursor`, `--search`, `--sort` (`latest`, `oldest`, `name`, `status`) | `hasMore` and `nextCursor` in the output |
| `builds list` | `--page-size`, `--page-token` | `nextPageToken` in the output |
| `games list` | `--page`, `--page-size` | a page shorter than the page size is the last one |

### Scripts and AI agents

- **JSON output** — every command prints JSON to stdout, errors included. Progress and debug output go to stderr.
- **Stable errors** — failures print `{"error": "...", "code": "...", "status": ...}` and exit with a distinct code per kind: `1` internal, `2` usage / invalid argument, `3` unauthenticated / permission denied, `4` not found, `5` network, `6` build failed, `7` timeout.
- **Self-describing** — `gameflow schema` prints every command, flag, and error code as JSON.
- **Non-hanging** — `builds create --timeout 20m` (or `--no-wait`) and `servers logs --no-follow --tail 100` always return.
- **Safe previews** — `servers stop --dry-run` shows what would be stopped.

### Configuration

| Variable | Purpose |
|----------|---------|
| `GAMEFLOW_API_KEY` | Authenticate without a config file. Preferred in CI and agent runs. |
| `GAMEFLOW_TOKEN` | Short-lived token. Takes precedence over a stored key and is never written to disk. |
| `GAMEFLOW_API_URL` | Override the API base URL (also settable as `api_url` in the config file). |

`gameflow login --api-key-stdin` reads the key from stdin. Config and credentials are stored in `~/.gameflow/config.yaml`.

---

## Install

### macOS & Linux

```sh
curl -fsSL https://raw.githubusercontent.com/GameFlowGG/gameflow-cli-releases/main/install.sh | sh
```

This will:
1. Detect your OS and architecture automatically
2. Download the latest prod binary to `~/.gameflow/bin/gameflow`
3. Add it to your `PATH`

To install a specific version instead of `prod`:

```sh
curl -fsSL https://raw.githubusercontent.com/GameFlowGG/gameflow-cli-releases/main/install.sh | sh -s 1.2.0
```

### Windows

Run in PowerShell:

```powershell
irm https://raw.githubusercontent.com/GameFlowGG/gameflow-cli-releases/main/install.ps1 | iex
```

This will download the latest prod binary to `%USERPROFILE%\.gameflow\bin\gameflow.exe` and add it to your user `PATH`. No admin rights required.

To install a specific version:

```powershell
& ([scriptblock]::Create((irm https://raw.githubusercontent.com/GameFlowGG/gameflow-cli-releases/main/install.ps1))) 1.2.0
```

---

## Uninstall

### macOS & Linux

```sh
curl -fsSL https://raw.githubusercontent.com/GameFlowGG/gameflow-cli-releases/main/uninstall.sh | sh
```

### Windows

```powershell
irm https://raw.githubusercontent.com/GameFlowGG/gameflow-cli-releases/main/uninstall.ps1 | iex
```

Both scripts remove the install directory (including config and stored credentials) and clean up your `PATH`.

---

### Manual download

All platform binaries are available on the [Releases](https://github.com/GameFlowGG/gameflow-cli-releases/releases) page.

| Platform | Architecture | Binary |
|----------|-------------|--------|
| Linux    | x86_64      | `gameflow-linux-amd64` |
| Linux    | ARM64       | `gameflow-linux-arm64` |
| macOS    | x86_64      | `gameflow-darwin-amd64` |
| macOS    | Apple Silicon | `gameflow-darwin-arm64` |
| Windows  | x86_64      | `gameflow-windows-amd64.exe` |

---

## Links

- Website: https://www.gameflow.gg/
- Documentation: https://docs.gameflow.gg/
