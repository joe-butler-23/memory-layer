# Memory Classification

Captured: 2026-02-07

Classification rules (from PLAN.md):

| Class | Rule |
|-------|------|
| `machine_exec` | Has `exec:` tag(s) with machine commands (no `-i` flag) |
| `human_instruction` | Has backtick command in text, no `exec:` tag |
| `human_exec` | Has `exec:` tag but references human CLI (`-i` flag) |
| `mixed` | Has both `exec:` tag AND backtick/imperative text |
| `informational` | No command reference |
| `test` | Test/smoke-test memory, should be cleaned up |
| `stale` | References deprecated systems (dashboard, mise-en-place obsidian) |
| `garbage` | Empty content or nonsensical |

## Classification Table

| # | ID (short) | Class | Content (summary) | Migration needed? |
|---|-----------|-------|-------------------|-------------------|
| 1 | 7d38e65f | machine_exec | Task create schema (exec:ptt schema task) | Yes — should use `exec:ptt op schema task.create` |
| 2 | 055d9cd7 | machine_exec | Task add schema (exec:ptt schema task) — DUPLICATE of #1 | Delete — duplicate |
| 3 | b24657df | test | Testing OpenAI embeddings | Delete |
| 4 | 7294894e | test | OpenAI embeddings test memory | Delete |
| 5 | 4ce1e5d2 | test | Test memory using OpenAI embeddings | Delete |
| 6 | 538b7c5a | informational | pt wrapper shortcut info | Keep — useful context |
| 7 | 2afb644a | machine_exec | Event create schema (exec:ptt schema event) | Yes — should use `exec:ptt op schema event.create` |
| 8 | 663edaef | human_instruction | om-ctx-add usage (backtick command in text) | No — om commands stay as-is |
| 9 | d9d3c2d1 | human_instruction | om-list/om-query/om-stats usage (backtick commands) | No — om commands stay as-is |
| 10 | 7d54a1ea | informational | How OpenMemory works (overview) | No |
| 11 | 0f3382b9 | machine_exec | Overdue tasks (exec:ptt list overdue) | No — read-only command, fine as-is |
| 12 | 219e5fc7 | machine_exec | Current task list (exec:ptt list --columns) | No — read-only command, fine as-is |
| 13 | d222cfb2 | human_instruction | Complete item: "use ptt complete item" (backtick) | Yes — should use `exec:ptt op schema item.complete` |
| 14 | e6c8da15 | human_instruction | Update task: "use ptt update task field=value" | Yes — should use `exec:ptt op schema item.update` |
| 15 | fc38bd85 | human_instruction | Log progress: "use ptt log task" | Yes — should use `exec:ptt op schema task.log` |
| 16 | c4f2b522 | human_instruction | Add note: "use ptt add-note task" | Yes — should use `exec:ptt op schema task.add_note` |
| 17 | 2279c215 | human_instruction | JSON view models: "use ptt view today --format json" | No — read-only command |
| 18 | e03ef2d3 | machine_exec | Behaviour rules (exec:ptt behaviour) | No — read-only |
| 19 | 61951eda | machine_exec | Planning principles (exec:ptt planning) | No — read-only |
| 20 | adc2d03a | machine_exec | Request workflows (exec:ptt requests) | No — read-only |
| 21 | fab979c6 | machine_exec | Execution flow (exec:ptt flow) | No — read-only |
| 22 | 667e48b8 | machine_exec | Completion steps (exec:ptt completion) | No — read-only |
| 23 | 33ccad19 | machine_exec | Week schedule (exec:ptt week) | No — read-only |
| 24 | 08264c0a | machine_exec | Upcoming events (exec:ptt events) | No — read-only |
| 25 | a669f69b | machine_exec | Sprint tasks (exec:ptt list --sprint) | No — read-only |
| 26 | 8da31e6d | machine_exec | Due tasks (exec:ptt list --due) | No — read-only |
| 27 | 8d7107d8 | machine_exec | Completed tasks (exec:ptt list --done) | No — read-only |
| 28 | 658a3aea | machine_exec | Backlog (exec:ptt backlog) | No — read-only |
| 29 | eb355655 | machine_exec | Project create schema (exec:ptt schema project) | Yes — should use `exec:ptt op schema note.create` (projects are notes) |
| 30 | a87f9088 | informational | Payday shopping list location | No |
| 31 | d05ae2f1 | informational | Quick notes → scratchpad.md | No |
| 32 | 9937e550 | stale | Dashboard data model (old Obsidian plugin) | Delete or archive |
| 33 | 8d73e050 | garbage | Empty content — dashboard standards | Delete |
| 34 | c8239f34 | stale | Dashboard refactoring patterns | Delete or archive |
| 35 | 5c7b09e0 | stale | Dashboard 4 pillars | Delete or archive |
| 36 | 652f634c | garbage | Empty content — dashboard design | Delete |
| 37 | 37e1df0c | stale | Dashboard monorepo structure | Delete or archive |
| 38 | 251b347d | stale | Mise en Place RecipeParser patterns | Delete or archive |
| 39 | 450ab9f0 | stale | Mise en Place file-watching patterns | Delete or archive |
| 40 | 027cad3c | garbage | Empty content — performance limits | Delete |
| 41 | 815bff91 | stale | Obsidian async processing | Delete or archive |
| 42 | bfff77d3 | garbage | Content is "--help" | Delete |
| 43 | 5d7b987e | test | Test project scoping | Delete |
| 44 | 9ee8ac22 | informational | Nix wiring changelog | Keep — useful context |
| 45 | cb54e5e6 | informational | Nix workflow pattern | Keep — useful context |
| 46 | b9ebe5d9 | informational | Nix-config flake info | Keep — useful context |
| 47 | 86342414 | test | Smoke test memory | Delete |

## Summary

| Class | Count | Action |
|-------|-------|--------|
| machine_exec (read-only) | 14 | Keep as-is |
| machine_exec (write-schema) | 3 | Migrate exec tags to `ptt op schema` |
| human_instruction (write) | 4 | Migrate to `exec:ptt op schema <id>` |
| human_instruction (read/om) | 3 | Keep as-is |
| informational | 6 | Keep |
| stale | 7 | Delete |
| garbage | 4 | Delete |
| test | 5 | Delete |
| duplicate | 1 | Delete |

**Total memories:** 47
**To delete:** 17 (stale + garbage + test + duplicate)
**To migrate:** 7 (write commands → ptt op schema)
**Clean after:** ~30 high-quality memories

## Migration Targets (for M2)

| Memory ID | Current | Target exec tags |
|-----------|---------|-----------------|
| 7d38e65f | `exec:ptt schema task` | `exec:ptt op schema task.create`,`exec:ptt context operations` |
| 2afb644a | `exec:ptt schema event` | `exec:ptt op schema event.create`,`exec:ptt context operations` |
| d222cfb2 | (no exec, backtick text) | `exec:ptt op schema item.complete`,`exec:ptt context operations` |
| e6c8da15 | (no exec, backtick text) | `exec:ptt op schema item.update`,`exec:ptt context operations` |
| fc38bd85 | (no exec, backtick text) | `exec:ptt op schema task.log`,`exec:ptt context operations` |
| c4f2b522 | (no exec, backtick text) | `exec:ptt op schema task.add_note`,`exec:ptt context operations` |
| eb355655 | `exec:ptt schema project` | `exec:ptt op schema note.create`,`exec:ptt context operations` |
