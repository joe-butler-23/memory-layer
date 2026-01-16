# PLAN: Remaining Tasks

## Priority 1: Core Productivity Memories ✅ Complete

All memories seeded and PTT commands implemented.

### Task Management
| Intent | Memory Text | Exec Tags | Status |
|--------|-------------|-----------|--------|
| Create task | workType options: actionable, habit, phase... | `ptt schema task`, `ptt context` | ✅ |
| List tasks | Current task list: | `ptt list` | ✅ |
| Complete task | To mark a task complete: | `ptt completion` | ✅ |
| View deadlines | Tasks with upcoming deadlines: | `ptt list --due` | ✅ |
| Sprint tasks | Sprint-focused tasks: | `ptt list --sprint` | ✅ |
| Completed tasks | Completed tasks from last 30 days: | `ptt list --done` | ✅ |

### Events & Calendar
| Intent | Memory Text | Exec Tags | Status |
|--------|-------------|-----------|--------|
| Create event | (existing) | `ptt schema event` | ✅ |
| List events | Upcoming events: | `ptt events` | ✅ |
| Weekly view | Week ahead schedule: | `ptt week` | ✅ |

### Planning & Review
| Intent | Memory Text | Exec Tags | Status |
|--------|-------------|-----------|--------|
| Plan day | (existing) | `ptt flow` | ✅ |
| Weekly review | Weekly review workflow: | `ptt review` | ✅ |

### Quick Capture
| Intent | Memory Text | Exec Tags | Status |
|--------|-------------|-----------|--------|
| Quick note | Quick notes → /home/joebutler/vault/scratchpad.md | - | ✅ |
| Search vault | Search with ripgrep at /home/joebutler/vault | - | ✅ |

---

## Priority 2: Infrastructure Improvements

### Embedding Upgrade
- [ ] Switch from current embedding model to OpenAI `text-embedding-3-small`
- [ ] Benchmark intent matching accuracy before/after
- [ ] Update om-query configuration

### Plugin Improvements
- [ ] Deduplicate exec commands (currently runs same command multiple times if in multiple memories)
- [ ] Add score threshold for exec (only run if score > 1.0)
- [ ] Cache command output within session

### Platform Expansion
- [ ] Port exec: parsing to Claude Code (`~/.claude/hooks/memory-check.py`)
- [ ] Document standard Context Protocol for other agents

---

## Priority 3: PTT Command Gaps ✅ Complete

All required commands implemented:
- [x] `ptt list` - Base list
- [x] `ptt list --due` - Tasks with deadlines
- [x] `ptt list --sprint` - Sprint tasks
- [x] `ptt list --done` - Completed tasks (30 days)
- [x] `ptt events` - Upcoming events
- [x] `ptt week` - Week ahead view
- [x] `ptt review` - Weekly review workflow

---

## Priority 4: Extended Domains

### Coding Assistance
| Intent | Memory Content | Exec Tag |
|--------|---------------|----------|
| Find files | "To find files by name, use fd" | `exec:fd -t f` |
| Search code | "To search code, use rg" | - |
| Git status | "To check git status across repos" | `exec:git status` |

### System Maintenance
| Intent | Memory Content | Exec Tag |
|--------|---------------|----------|
| System health | "To check NixOS config, use nixos-rebuild dry-build" | `exec:nixos-rebuild dry-build` |
| Disk usage | "To check disk space, use df -h" | `exec:df -h` |

### OpenMemory Self-Management
| Intent | Memory Content | Exec Tag |
|--------|---------------|----------|
| Add memory | "To remember something, use om-ctx-add" | `exec:om-ctx-add --help` |
| List memories | "To see stored memories, use om-list" | `exec:om-list --project global` |

---

## Next Actions

1. ~~Verify ptt commands exist~~ ✅
2. ~~Seed Priority 1 memories~~ ✅
3. ~~Develop missing PTT commands~~ ✅
4. **Upgrade embeddings** - Switch to OpenAI model for better semantic matching
5. **Expand to Priority 2-4** - Plugin improvements and extended domains
