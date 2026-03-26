# GameFlow CLI — Dev Releases

This repository hosts **pre-release and development builds** of the [GameFlow CLI](https://github.com/GameFlowGG/gameflow-cli).

> **These are not stable releases.** Dev builds are published automatically on every commit to `main` and are intended for testing and early access only.

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

The GameFlow CLI lets you manage your GameFlow resources from the terminal — deployments, server fleets, matchmaking configuration, and more.

---

## Download

Grab the latest dev build from the [Releases](https://github.com/GameFlowGG/gameflow-cli-dev-release/releases) page.

| Platform | Architecture | Binary |
|----------|-------------|--------|
| Linux    | x86_64      | `gameflow-linux-amd64` |
| Linux    | ARM64       | `gameflow-linux-arm64` |
| macOS    | x86_64      | `gameflow-darwin-amd64` |
| macOS    | Apple Silicon | `gameflow-darwin-arm64` |
| Windows  | x86_64      | `gameflow-windows-amd64.exe` |

### Quick install (macOS/Linux)

```bash
# macOS Apple Silicon example
curl -L https://github.com/GameFlowGG/gameflow-cli-dev-release/releases/download/dev/gameflow-darwin-arm64 -o gameflow
chmod +x gameflow
sudo mv gameflow /usr/local/bin/gameflow
```

---

## Release cadence

| Tag | Triggered by | Stability |
|-----|-------------|-----------|
| `dev` | Every push to `main` | Unstable — may break at any time |
| `vX.Y.Z` | Manual workflow dispatch | Pre-release candidate |

For stable releases, see the [main CLI repository](https://github.com/GameFlowGG/gameflow-cli).

---

## Links

- Website: https://www.gameflow.gg/
- Documentation: https://docs.gameflow.gg/
- CLI source: https://github.com/GameFlowGG/gameflow-cli
