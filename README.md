<div align="center">

<img src="public/openclaw-logo.svg" width="104" alt="OpenClaw Session Manager logo">

# OpenClaw Session Manager

**A lightweight, local-first interface for managing OpenClaw sessions.**

Keep your existing OpenClaw setup. Keep your session data on your machine.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Node.js](https://img.shields.io/badge/Node.js-22%2B-5FA04E?logo=nodedotjs&logoColor=white)](package.json)
[![macOS](https://img.shields.io/badge/macOS-12%2B-000000?logo=apple&logoColor=white)](macos/AppMain.swift)
[![OpenClaw](https://img.shields.io/badge/OpenClaw-Local-2563EB)](https://github.com/openclaw/openclaw)

[Features](#features) · [Quick start](#quick-start) · [How it works](#how-it-works) · [Security](#security) · [FAQ](#faq)

</div>

## What is OpenClaw Session Manager?

OpenClaw Session Manager is a local tool for browsing and maintaining sessions across all of your OpenClaw agents.

As the number of sessions grows, finding a session key, checking its model, tracking token usage, or running rename, reset, and delete commands becomes tedious. This project adds a focused graphical interface on top of your existing OpenClaw installation: it reads local sessions and uses the official OpenClaw Gateway API for write operations, without replacing OpenClaw or introducing another distribution.

## Why use it?

| Common problem | How this project helps |
| --- | --- |
| Sessions are spread across multiple agents | Browse all agents from one view, with search and filtering |
| Session keys are hard to recognize | Show labels, keys, agents, models, types, and update times together |
| Everyday maintenance requires memorizing commands | Rename, reset, abort, and delete from the session card |
| You do not want another OpenClaw fork installed | Connect directly to the OpenClaw CLI and Gateway you already use |
| Session data is private | Bind the service to `127.0.0.1` and keep data local |

## Features

- **Unified browsing**: View sessions from every agent and see total counts.
- **Fast discovery**: Search by label, session key, model, or channel; filter by agent.
- **At-a-glance status**: See model, session kind, last update time, and token usage.
- **Session maintenance**: Create sessions and set or clear display labels.
- **Runtime control**: Reset context or abort the current run.
- **Safer deletion**: Confirm destructive actions and optionally remove the transcript file too.
- **Two ways to run**: Use a native macOS window or open the local Web UI in a browser.

## Quick start

### Prerequisites

- [OpenClaw](https://github.com/openclaw/openclaw) installed and initialized
- Node.js 22 or later
- For the macOS app: macOS 12 or later and Xcode Command Line Tools

### Option 1: Web mode

```bash
git clone https://github.com/xiaoninemao/openclaw-session-manager.git
cd openclaw-session-manager
npm start
```

Open [http://127.0.0.1:43110](http://127.0.0.1:43110) in your browser.

The project has no third-party npm runtime dependencies, so `npm install` is not required.

If the OpenClaw CLI is not in one of the standard locations, provide its path explicitly:

```bash
OPENCLAW_CLI=/path/to/openclaw npm start
```

To use a different local port:

```bash
PORT=43111 npm start
```

### Option 2: Native macOS app

Build the app bundle:

```bash
npm run build:macos
```

The bundle is created at:

```text
build/OpenClaw 会话管理器.app
```

Build and install it into `/Applications`:

```bash
npm run install:macos
```

The app starts the local Node.js service and loads the UI in a native WebKit window. It is signed with an ad-hoc local signature for personal use. For public distribution, sign and notarize it with an Apple Developer certificate.

## Platform support

| Run mode | macOS | Linux | Windows |
| --- | --- | --- | --- |
| Native `.app` | ✅ Supported | — | — |
| Web mode | ✅ Supported | 🧪 Should run; more testing needed | 🧪 Testing and path adaptations needed |

The native app uses AppKit and WebKit, so it is macOS-only. The Web service is built with Node.js and does not depend on macOS at its core, but macOS is currently the primary tested platform.

## How it works

```text
Browser / native macOS app
             │
             │ HTTP (127.0.0.1 only)
             ▼
       Local Node.js service
             │
             ├── openclaw sessions --all-agents   read sessions
             ├── ~/.openclaw/agents/...            resolve local labels
             └── openclaw gateway call             create and mutate
                              │
                              ▼
                       OpenClaw Gateway
```

- **Web UI** handles the session list, search, filters, statistics, and confirmations.
- **Local service** locates the OpenClaw CLI, aggregates sessions, and maps UI actions to Gateway calls.
- **macOS shell** starts the service and provides a native window. Closing the window terminates the service process started by the app.

## Repository layout

```text
openclaw-session-manager/
├── public/               # Web UI, styles, and browser logic
├── macos/                # AppKit + WebKit native app shell
├── scripts/              # macOS build and install scripts
├── server.mjs            # Local HTTP service and OpenClaw adapter
└── package.json          # Run, check, and build commands
```

## Development

Start the local service:

```bash
npm start
```

Check the server and browser JavaScript syntax:

```bash
npm run check
```

## Security

- The service binds to the loopback address `127.0.0.1`; it does not listen on your LAN or the public internet.
- Session data is not sent to an external server by this project.
- Write operations are performed by the OpenClaw Gateway and follow OpenClaw's device authorization flow.
- Reset and delete are destructive actions and require confirmation in the UI.
- If you choose to delete the transcript as well, the related record may not be recoverable.

## FAQ

### “OpenClaw CLI not found”

Make sure OpenClaw is installed, or provide the executable's absolute path:

```bash
OPENCLAW_CLI=/absolute/path/to/openclaw npm start
```

### “pairing required”

Open the OpenClaw control panel, approve the CLI device on the **Devices** page, and refresh the manager.

### The macOS app cannot start the service

Make sure `node` and `openclaw` are available in a standard path, then inspect the log:

```text
~/Library/Logs/OpenClaw Session Manager.log
```

### Port `43110` is already in use

Web mode supports a custom port through `PORT`. The macOS app currently uses `43110`; stop the process using that port before launching it again.

## Contributing

Issues and pull requests are welcome, including bug fixes, cross-platform support, UI improvements, and documentation updates. Before opening a pull request, run:

```bash
npm run check
```

## License

This project is released under the [MIT License](LICENSE).
