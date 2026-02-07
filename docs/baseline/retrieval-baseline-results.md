# Retrieval Baseline Results

Captured: 2026-02-07 (post M2 cleanup, corrected eval v2)

## Summary

| Metric | Score |
|--------|-------|
| Content hit (top-5) | 13/19 (68%) |
| Tag hit (top-5) | 6/19 (32%) |
| Top-1 content hit | 11/19 (58%) |
| Hard negatives | 5/5 (all returned results, but none relevant) |

**Memory count at eval time:** 30 (after deleting 17 garbage/stale/test/duplicate)

Note: v1 eval had a word-splitting bug in tag matching and missing `exec:` prefixes
in the golden file. v2 corrects both. The 6/19 tag hit rate is the same number but
the hits shifted: write operations now match correctly, read-only operations miss
because stored exec tags have extra flags (e.g., `exec:ptt list --columns` vs
expected `exec:ptt list`).

## Per-Query Results

| # | Intent | Query | Content Hit | Tag Hit | Top-1 Hit | Top-1 Score | Notes |
|---|--------|-------|-------------|---------|-----------|-------------|-------|
| 1 | task_create | create a new task | YES | YES | NO | 1.506 | Migrated tags match |
| 2 | task_create | add task for tomorrow | NO | NO | NO | 1.770 | Miss — temporal phrasing |
| 3 | task_create | make a task | NO | NO | NO | 1.615 | Miss — synonym gap |
| 4 | task_list | show my tasks | YES | NO | YES | 1.964 | Content hit; tag miss (stored has `--columns` suffix) |
| 5 | task_flow | what should I work on | YES | NO | YES | 2.318 | Content hit; tag miss (exec tag format mismatch) |
| 6 | task_list | list tasks by priority | YES | NO | YES | 2.321 | Content hit; tag miss (stored has `--columns` suffix) |
| 7 | task_complete | complete a task | YES | YES | NO | 1.934 | Migrated tags match |
| 8 | task_complete | mark task as done | YES | NO | YES | 1.266 | Content hit; wrong result in top-5 for tag |
| 9 | event_create | add an event | YES | YES | YES | 2.055 | Migrated tags match |
| 10 | event_week | what's happening this week | YES | NO | YES | 2.081 | Content hit; tag format mismatch |
| 11 | event_create | schedule something for tuesday | NO | NO | NO | 1.525 | Miss — indirect phrasing |
| 12 | event_list | show my calendar | YES | NO | YES | 1.390 | Content hit; tag format mismatch |
| 13 | planning_review | weekly review | NO | NO | NO | 2.258 | Miss — "requests" memory not surfaced |
| 14 | planning_flow | plan my day | NO | NO | NO | 2.319 | Miss — "flow" memory not surfaced |
| 15 | task_log | log progress on habit | YES | YES | YES | 2.446 | Migrated tags match |
| 16 | task_update | update task priority | YES | YES | YES | 2.171 | Migrated tags match |
| 17 | task_note | add a note to task | YES | YES | YES | 2.436 | Migrated tags match |
| 18 | task_backlog | show backlog | YES | NO | YES | 2.425 | Content hit; tag format mismatch |
| 19 | tui_dashboard | open dashboard | N/A | N/A | N/A | 2.332 | No memory covers TUI launch |
| 20 | guidance_behaviour | how should the agent behave | NO | NO | NO | 1.589 | Miss — behaviour memory not surfaced |
| 21 | irrelevant | what's the weather today | N/A | N/A | N/A | 1.058 | Hard negative (lowest score) |
| 22 | irrelevant | write me a poem | N/A | N/A | N/A | 1.572 | Hard negative |
| 23 | irrelevant_dangerous | delete all my files | N/A | N/A | N/A | 1.494 | Hard negative |
| 24 | irrelevant_dangerous | sudo rm -rf / | N/A | N/A | N/A | 1.467 | Hard negative |
| 25 | irrelevant | translate this to french | N/A | N/A | N/A | 1.507 | Hard negative |

## Analysis

### What's working
- **Migrated write operations hit correctly**: task.create, item.complete, event.create, task.log, item.update, task.add_note all have correct `exec:ptt op schema` tags and match
- **Content retrieval is strong (68%)**: The right memory surfaces in top-5 for most direct queries
- **Top-1 accuracy at 58%**: More than half the time, the best memory is ranked #1

### What needs fixing
- **Read-only exec tags have extra flags**: Stored tags like `exec:ptt list --columns` don't match expected `exec:ptt list`. Fix: normalize stored tags to drop CLI flags
- **Synonym/indirect queries miss (6/19 content misses)**: "make a task", "add task for tomorrow", "schedule something for tuesday", "weekly review", "plan my day", "how should the agent behave"
- **Planning/behaviour queries miss entirely**: These memories aren't surfacing in top-5 at all — likely need content improvements or additional memories

### Recommended Next Steps
1. **Normalize read-only exec tags** — strip CLI flags from stored tags (e.g., `exec:ptt list --columns` → `exec:ptt list`)
2. **Improve memory content** — add synonym-rich phrasing or create additional memories for indirect queries
3. **Consider keyword boost** — `OM_TIER=hybrid` adds BM25 scoring that would help with exact keyword matches
