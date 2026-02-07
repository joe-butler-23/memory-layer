# OpenMemory Hardening — Remaining Work

Status: in-progress
Owner: joebutler
Last updated: 2026-02-07

## Current State

- 30 memories in `global` project (17 garbage deleted, 7 write-ops migrated to `exec:ptt op schema` tags)
- Embedding model: `text-embedding-3-large` (3072 dims), `OM_EMBEDDINGS=openai`
- Retrieval baseline: content hit 68%, tag hit 32%, top-1 hit 58%
- Target: Recall@1 >= 0.90, safe-command-first >= 0.98
- Golden eval set: `tests/fixtures/retrieval-golden.jsonl` (25 queries including 5 hard negatives)
- Eval script: `/tmp/eval-retrieval-v2.sh` (needs to move to `scripts/eval/`)
- Nix pre-flight schema patch committed in `nix-config` (needs `nixos-rebuild switch`)

### Known Issue: Read-Only Exec Tag Mismatch

Stored read-only exec tags use full shell command format:
```
exec:echo '<task-list>'; ptt list --columns 'task scheduled'; echo '</task-list>'
```
Golden file expects simplified form: `exec:ptt list`. This drags down tag hit
rate. Fix: normalize stored tags to strip shell wrappers and CLI flags.

## Remaining Milestones

### M3: OpenAI Embedding Upgrade

1. Verify `text-embedding-3-large` (3072 dims) is active — run test queries,
   confirm dimensionality in `vectors` table.
2. Replace stub at `scripts/reindex-openai.sh` with working implementation:
   - Export all memories via `om-list --project global --json`
   - For each memory: delete vectors, re-add with same content + tags
   - Validate: run 5 golden queries, compare scores before/after
3. Add batching, retry, and timeout handling for OpenAI API calls.

Deliverables:
- Working `scripts/reindex-openai.sh`
- `docs/baseline/embedding-status.md` confirming model + dimensions

### M4: Safety Hardening

1. Create `config/command-policy.json` with:
   - `default_policy: deny`
   - Read-only allowlist: `ptt list`, `ptt events`, `ptt week`, `ptt review`,
     `ptt flow`, `ptt context`, `ptt behaviour`, `ptt planning`, `ptt requests`,
     `ptt backlog`, `ptt completion`, `ptt scan`, `ptt notes`, `ptt show`,
     `ptt op list`, `ptt op schema`, `ptt view *`, `om-query`, `om-list`
   - Write-guarded: `ptt op run` (allow plan mode only, block apply mode)
   - Blocked patterns: `rm`, `mv`, `cp`, `chmod`, `chown`, `>`, `>>`, `|`,
     `;`, `&&`, `||`, `` ` ``, `$(`, `eval`
2. Add `is_command_allowed()` check to all three hooks before `sh -c` execution:
   - Claude: `~/.claude/hooks/memory-check.py`
   - OpenCode: `~/.config/opencode/plugins/memory-check.js`
   - Gemini: `wrappers/gemini-memory-wrapper.sh`
3. Write `tests/test_safety.sh` covering:
   - Read-only commands pass
   - `ptt op run --mode plan` passes
   - `ptt op run --mode apply` blocked from auto-exec
   - Shell injection vectors blocked
   - Unknown commands rejected (default deny)

Deliverables:
- `config/command-policy.json`
- Updated hooks (all three)
- `tests/test_safety.sh`

### M5: Retrieval Quality Eval and Refinement

1. Move eval script to `scripts/eval/run_retrieval_eval.sh` (currently at `/tmp/eval-retrieval-v2.sh`).
2. Add metrics: Recall@1, Recall@3, MRR, safe-command-first rate.
3. Set CI-friendly quality gates:
   - Recall@1 >= 0.90
   - safe-command-first >= 0.98
   - Exit 0 for pass, 1 for fail
4. Normalize read-only exec tags (strip shell wrappers and CLI flags from
   stored tags so they match golden file expectations).
5. Improve memory content for missed queries:
   - "add task for tomorrow" / "make a task" (synonym gap)
   - "schedule something for tuesday" (indirect phrasing)
   - "weekly review" / "plan my day" (planning memories not surfacing)
   - "how should the agent behave" (behaviour memory not surfacing)
6. Create `docs/eval/retrieval-quality.md` with error analysis template.

Deliverables:
- `scripts/eval/run_retrieval_eval.sh`
- `docs/eval/retrieval-quality.md`
- Normalized exec tags in memory DB
- Quality gates passing at target thresholds

### M6: Hook and Documentation Parity

1. Create `docs/hook-parity-checklist.md` comparing features across hooks:
   - Score threshold (Claude/OpenCode: 1.5, Gemini: 0.5 — align to 1.5)
   - Command dedup (missing in Gemini)
   - Project + global merge (missing in Gemini)
   - Command allowlist (from M4)
2. Align Gemini hook:
   - Set `SCORE_THRESHOLD=1.5`
   - Add command dedup
   - Add project-local + global merge
3. Update `scripts/seed_ptt_instructions.sh` to use `ptt op` references
   for all write operations.
4. Update `README.md`:
   - Fix embedding model to `text-embedding-3-large` (3072 dims)
   - Document `ptt op` machine interface
   - Add safety class column to memory table
   - Remove stale `-i` (interactive) flag references
5. Create `docs/quickstart.md` for fresh agent session setup.
6. Create `tests/test_e2e_smoke.sh` covering:
   - `om-list` + `om-query` exit 0
   - `ptt op list` shows 11+ operations
   - Eval harness passes
   - Safety tests pass

Deliverables:
- `docs/hook-parity-checklist.md`
- Updated hooks (Gemini threshold/dedup/merge)
- Updated `scripts/seed_ptt_instructions.sh`
- Updated `README.md`
- `docs/quickstart.md`
- `tests/test_e2e_smoke.sh`

## Dependency Order

```
M3 (embeddings) ──┐
                   ├──> M5 (eval + refinement) ──> M6 (parity + docs)
M4 (safety) ──────┘
```

M3 and M4 are independent and can run in parallel.
M5 depends on both (needs working embeddings + safety policy for safe-command-first metric).
M6 depends on M4 (safety policy) and M5 (eval in smoke test).

## Key File Reference

### Hooks
| File | Type |
|------|------|
| `~/.claude/hooks/memory-check.py` | Python, 216 lines |
| `~/.config/opencode/plugins/memory-check.js` | JS, 234 lines |
| `wrappers/gemini-memory-wrapper.sh` | Bash, 89 lines |

### Memory DB
- SQLite: `~/.local/share/openmemory/memory.sqlite`
- Config: `~/.config/openmemory/env`
- API key: `~/development/memory-layer/.env`

### PTT Operations
| Operation ID | Safety Class |
|-------------|-------------|
| `task.create` | write_guarded |
| `event.create` | write_guarded |
| `item.complete` | write_guarded |
| `item.archive` | write_guarded |
| `item.update` | write_guarded |
| `item.update_body` | write_guarded |
| `item.reschedule` | write_guarded |
| `task.add_note` | write_safe |
| `task.log` | write_safe |
| `note.create` | write_safe |
| `week.plan` | write_guarded |

### Eval Fixtures
- Golden queries: `tests/fixtures/retrieval-golden.jsonl`
- Baseline results: `docs/baseline/retrieval-baseline-results.md`
- Memory classification: `docs/baseline/memory-classification.md`

## Verification

After all milestones:
1. `tests/test_safety.sh` — all pass
2. `scripts/eval/run_retrieval_eval.sh` — gate passes (Recall@1 >= 0.90)
3. `tests/test_e2e_smoke.sh` — end-to-end green
4. Manual: type "create a task" in Claude Code, verify context shows
   `ptt op schema task.create` output
