# memory-layer

A system for injecting semantic context and executing commands automatically in AI conversations.

![Memory Layer Banner](assets/banner.png)

## Overview

This project implements **Executable Memories** - a pattern where:
1. User speaks naturally ("create a task for tomorrow")
2. OpenMemory semantically matches relevant procedural knowledge
3. Plugin executes embedded commands (`ptt op schema task.create`)
4. AI receives context + command output, acts without user steering

## Core Principles

- **Lazy Loading**: AI gets only what it needs, when it needs it
- **Single Source of Truth**: CLI commands are executed, not documented
- **Zero Friction**: "Add event next Tues 3pm cinema" just works
- **Platform Agnostic**: Works across OpenCode, Claude Code, Gemini, etc.

## Components

### OpenMemory (`om-query`)
Semantic search engine that matches user intent to stored knowledge.

### Instructional Memories (Backtick Style)
Memories that instruct the agent *how* to use the CLI, rather than executing it automatically.
```
text: "To update task details interactively, use `ptt update -i`."
tags: ptt, update, interactive
```
The agent receives this instruction and can choose to run the command.

### Executable Tags (`exec:...`)
Memories carry execution instructions. Memory text introduces the CLI output:
```
text: "Current task list:"
tags: ptt, task, list, exec:ptt list
```
When matched, the plugin runs these commands and injects output.

### Plugin (`memory-check.js`)
OpenCode plugin that:
1. Intercepts user messages
2. Queries `om-query --project global`
3. Parses `exec:` tags from matching memories
4. Executes commands via `sh -c`
5. Injects combined context into conversation

### Command Policy
Auto-executed `exec:` commands are policy-gated by `config/command-policy.json`.

- `exec_mode_default`: global mode default (`safe`, `plan`, `permissive`) when `OM_EXEC_MODE` is unset.
- `OM_EXEC_MODE`: runtime override per client/session (`safe`, `plan`, `permissive`).
- `read_only`: always eligible for auto execution.
- `write_safe`: auto-executed only in `permissive` mode.
- `write_guarded`: auto-executed in `permissive`, or in `plan` when command mode is `--mode plan`.
- `blocked_patterns`: always blocked regardless of mode.

## Installation

1. Copy plugin to `.opencode/plugin/memory-check.js`
2. Ensure `package.json` has `@opencode-ai/plugin` dependency
3. Run `bun install` in `.opencode/`
4. Launch OpenCode from the project directory

## Debugging

Watch the log:
```bash
tail -f /tmp/opencode-memory-debug.log
```

Successful execution shows:
```
QUERY: Querying memories for {"message":"create a task"}
EXEC: Auto-executing command {"cmd":"ptt op schema task.create"}
SUCCESS: Injected context {"totalLines":24}
```

## Dependencies

- `om-query` - OpenMemory CLI
- `ptt` - Plain Text Tasks CLI
- `bun` - JavaScript runtime
- OpenCode 1.1.20+

## Status

**Priority 1, 2 (Embeddings), & 3 Complete**

- All core productivity memories seeded
- PTT commands implemented (`--done`, `--due`, `--sprint`, `events`, `week`, `review`)
- OpenAI `text-embedding-3-large` embeddings active (3072 dimensions)
- Config: `~/.config/openmemory/env`
