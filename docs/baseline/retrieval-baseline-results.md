# Retrieval Baseline Results

Captured: 2026-02-07 (post M2 cleanup)

## Summary

| Metric | Score |
|--------|-------|
| Content hit (top-5) | 13/19 (68%) |
| Tag hit (top-5) | 6/19 (32%) |
| Top-1 content hit | 11/19 (58%) |
| Hard negatives | 5/5 (all returned results, but none relevant) |

**Memory count at eval time:** 30 (after deleting 17 garbage/stale/test/duplicate)

## Per-Query Results

| # | Intent | Query | Content Hit | Tag Hit | Top-1 Hit | Top-1 Score | Notes |
|---|--------|-------|-------------|---------|-----------|-------------|-------|
| 1 | task_create | create a new task | YES | NO | NO | 1.506 | Hit in top-5 but not top-1 |
| 2 | task_create | add task for tomorrow | NO | NO | NO | 1.770 | Miss — temporal phrasing confused retrieval |
| 3 | task_create | make a task | NO | NO | NO | 1.615 | Miss — synonym not matched |
| 4 | task_list | show my tasks | YES | YES | YES | 1.964 | Clean hit |
| 5 | task_flow | what should I work on | YES | YES | YES | 2.318 | Clean hit |
| 6 | task_list | list tasks by priority | YES | YES | YES | 2.321 | Clean hit |
| 7 | task_complete | complete a task | YES | NO | NO | 1.934 | Content hit but new exec tags not matched |
| 8 | task_complete | mark task as done | YES | NO | YES | 1.266 | Content hit, tag miss |
| 9 | event_create | add an event | YES | NO | YES | 2.055 | Content hit, tag miss |
| 10 | event_week | what's happening this week | YES | YES | YES | 2.081 | Clean hit |
| 11 | event_create | schedule something for tuesday | NO | NO | NO | 1.525 | Miss — indirect phrasing |
| 12 | event_list | show my calendar | YES | YES | YES | 1.390 | Clean hit |
| 13 | planning_review | weekly review | NO | NO | NO | 2.258 | Miss — "requests" memory not surfaced |
| 14 | planning_flow | plan my day | NO | NO | NO | 2.319 | Miss — "flow" memory not surfaced |
| 15 | task_log | log progress on habit | YES | NO | YES | 2.446 | Content hit, tag miss |
| 16 | task_update | update task priority | YES | NO | YES | 2.171 | Content hit, tag miss |
| 17 | task_note | add a note to task | YES | NO | YES | 2.436 | Content hit, tag miss |
| 18 | task_backlog | show backlog | YES | YES | YES | 2.425 | Clean hit |
| 19 | tui_dashboard | open dashboard | N/A | N/A | N/A | 2.332 | No memory covers TUI launch |
| 20 | guidance_behaviour | how should the agent behave | NO | NO | NO | 1.589 | Miss — behaviour memory not surfaced |
| 21 | irrelevant | what's the weather today | N/A | N/A | N/A | 1.058 | Hard negative (lowest score) |
| 22 | irrelevant | write me a poem | N/A | N/A | N/A | 1.572 | Hard negative |
| 23 | irrelevant_dangerous | delete all my files | N/A | N/A | N/A | 1.494 | Hard negative |
| 24 | irrelevant_dangerous | sudo rm -rf / | N/A | N/A | N/A | 1.467 | Hard negative |
| 25 | irrelevant | translate this to french | N/A | N/A | N/A | 1.507 | Hard negative |

## Analysis

### Strengths
- Read-only commands with established exec tags perform well (list, week, events, backlog, flow)
- Direct noun matches ("show my tasks", "show backlog") score highest

### Weaknesses
- **Tag hit rate is low (32%)**: The newly migrated exec tags (`ptt op schema ...`) aren't being matched yet. The tag scoring in HSG likely needs re-embedding after tag changes. The vectors are stale — they were embedded with the old tag content.
- **Synonym/indirect queries miss**: "make a task", "add task for tomorrow", "schedule something for tuesday" all miss because the embeddings don't bridge the semantic gap well enough
- **Planning/behaviour queries miss**: "weekly review" and "plan my day" and "how should the agent behave" don't surface the right memories

### Recommended Next Steps
1. **Re-embed the 7 migrated memories** — vectors are stale after tag changes
2. **Improve memory content** — add synonym-rich content or additional memories for indirect phrasings
3. **Consider keyword boost** — OM_TIER=hybrid would add BM25 keyword scoring on top of vector similarity
