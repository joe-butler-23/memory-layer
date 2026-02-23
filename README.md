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

## Current Memories

### Task Management
| Intent | Memory Text | Exec Tags |
|--------|-------------|-----------|
| Create task | Operation contract for task creation | `ptt op schema task.create`, `ptt context operations` |
| List tasks | Current task list: | `ptt list` |
| Complete task | To mark a task complete: | `ptt completion` |
| View deadlines | Tasks with upcoming deadlines: | `ptt list --due` |
| Sprint tasks | Sprint-focused tasks: | `ptt list --sprint` |
| Completed tasks | Completed tasks from last 30 days: | `ptt list --done` |

### Events & Calendar
| Intent | Memory Text | Exec Tags |
|--------|-------------|-----------|
| Create event | Operation contract for event/reminder creation | `ptt op schema event.create` |
| List events | Upcoming events: | `ptt events` |
| Weekly view | Week ahead schedule: | `ptt week` |

### Planning & Review
| Intent | Memory Text | Exec Tags |
|--------|-------------|-----------|
| Plan day | (semantic match) | `ptt flow` |
| Weekly review | Weekly review workflow: | `ptt review` |

### Cooking & Shopping
| Intent | Memory Text | Exec Tags |
|--------|-------------|-----------|
| Todoist shopping sync | Todoist shopping sync control plane | `mep sl sync plan --help` |
| Todoist shopping preflight | Strict desired-state preflight before planning | `mep sl sync validate --help` |
| Todoist shopping recovery | Rollback-first recovery workflow from snapshots | `mep sl sync rollback --help` |

### Quick Capture
| Intent | Memory Text | Exec Tags |
|--------|-------------|-----------|
| Quick note | Quick notes → /home/joebutler/vault/scratchpad.md | - |
| Search vault | Search with ripgrep at /home/joebutler/vault | - |

### Interactive Maintenance (Instructional)
| Intent | Memory Text | Tags |
|--------|-------------|------|
| Update task | To update task details interactively, use `ptt update -i` | `ptt`, `update` |
| Archive task | To mark as done and move to archive, use `ptt archive -i` | `ptt`, `archive` |
| Log progress | To log progress on recurring task, use `ptt log -i` | `ptt`, `log` |
| Add note | To append note to task, use `ptt add-note -i` | `ptt`, `note` |

### AI Guidance & TUI (Instructional)
| Intent | Memory Text | Tags |
|--------|-------------|------|
| Behavior | Rules for agent behavior: `ptt behaviour` | `ptt`, `rules` |
| Planning | Planning principles: `ptt planning` | `ptt`, `planning` |
| Requests | SOPs for common requests: `ptt requests` | `ptt`, `sop` |
| Dashboard | Open daily dashboard: `expo today` | `ptt`, `tui` |
| Task Manager | Open task manager: `expo tasks` | `ptt`, `tui` |
| View Backlog | View backlog tasks: `ptt backlog` | `ptt`, `backlog` |
| JSON Views | Get raw JSON models: `ptt view today/tasks` | `ptt`, `json` |

## PTT Commands

```bash
ptt list              # Actionable tasks (priority 3=high, 1=low)
ptt list 3            # Filter by priority
ptt list --done       # Completed tasks (last 30 days)
ptt list --due        # Tasks with due dates
ptt list --sprint     # Sprint-flagged tasks
ptt events            # Upcoming events
ptt week              # Week ahead (events + scheduled tasks)
ptt review            # Weekly review workflow
ptt op schema task.create   # Task-create operation contract
ptt op schema event.create  # Event-create operation contract
ptt flow              # Execution flow guidance
ptt completion        # Task completion steps
```

## Example Flow

**User**: "What should I work on today?"

**System**:
1. `om-query` matches "ptt flow" memory (score: 2.8)
2. Plugin executes `ptt flow`
3. AI receives execution flow guidance
4. AI runs `ptt list` to see actual tasks
5. AI proposes top 3 prioritized tasks

**Result**: Contextual advice with zero user steering.

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

See [PLAN.md](./PLAN.md) for remaining priorities (plugin improvements, platform expansion).
