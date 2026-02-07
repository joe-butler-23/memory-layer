# OpenMemory First-Pass Baseline

Captured: 2026-02-07

## Environment

- OS: NixOS (Linux 6.18.7)
- Node: v22.21.1
- om-list: /run/current-system/sw/bin/om-list
- om-query: /run/current-system/sw/bin/om-query
- SQLite DB: ~/.local/share/openmemory/memory.sqlite
- Embedding config: ~/.config/openmemory/env (OM_EMBEDDINGS=openai)
- Embedding model: text-embedding-3-large (3072 dimensions)

## om-list Status

**BROKEN.** Both `om-list --project global` and `om-query --project global`
fail with:

```
[PostgresVectorStore] mode: sqlite (compat)
[DB] Using SQLite VectorStore with table: vectors

[Error: SQLITE_ERROR: no such column: user_id
Emitted 'error' event on Statement instance at:
] {
  errno: 1,
  code: 'SQLITE_ERROR'
}
```

The `vectors` table DOES have a `user_id` column, and the `memories` table
also has `user_id`. The error likely comes from a query against a table that
doesn't have it, or a schema mismatch in the om tool code vs the actual
database schema.

**Root cause hypothesis:** The om-list/om-query code expects a different table
structure than what exists. The database has 8 tables: `embed_logs`,
`memories`, `stats`, `temporal_edges`, `temporal_facts`, `users`, `vectors`,
`waypoints`. The tool may be querying against `vectors` directly when it should
be querying `memories`, or there's a column name mismatch.

## Database Stats

- memories table: 47 rows
- vectors table: 49 rows
- Total tables: 8 (embed_logs, memories, stats, temporal_edges, temporal_facts, users, vectors, waypoints)

## om-query Retrieval Status

**BLOCKED** by the same SQLite error. Cannot run retrieval queries until the
om tool code is fixed.

## Full Memory Dump (via direct SQLite query)

The following 47 memories were captured via direct SQL:

```
nix-shell -p sqlite --run "sqlite3 -header -separator '|' ~/.local/share/openmemory/memory.sqlite \
  \"SELECT id, primary_sector, content, tags, salience, created_at FROM memories ORDER BY created_at DESC;\""
```

| # | ID (short) | Sector | Content (truncated) | Tags | Salience | Created |
|---|-----------|--------|---------------------|------|----------|---------|
| 1 | 7d38e65f | procedural | to create or add a new task, create a markdown file... | context,ptt,task,create,add,new,schema,exec:ptt schema task | 0.4 | 2026-01-29 |
| 2 | 055d9cd7 | semantic | to add a task, create a markdown file... | context,ptt,task,add,create,new,schema,exec:ptt schema task | 0.4 | 2026-01-29 |
| 3 | b24657df | semantic | Testing OpenAI embeddings with explicit API key | test,openai | 0.4 | 2026-01-29 |
| 4 | 7294894e | semantic | OpenAI embeddings test memory for semantic comparison | test,openai,semantic | 0.4 | 2026-01-29 |
| 5 | 4ce1e5d2 | semantic | This is a test memory using OpenAI embeddings... | test,openai,embedding | 0.5 | 2026-01-29 |
| 6 | 538b7c5a | semantic | pt is a shortcut wrapper: pt -> scripts/wrappers/pt... | pttui,wrapper,cli | 0.4 | 2026-01-27 |
| 7 | 2afb644a | episodic | Add an event / create an event: create a markdown file... | context,ptt,event,add,create,exec:ptt schema event | 0.4 | 2026-01-27 |
| 8 | 663edaef | semantic | Add a memory / remember this: om-ctx-add... | context,openmemory,om,add,remember,create | 0.4 | 2026-01-27 |
| 9 | d9d3c2d1 | procedural | How to list or find memories: om-list... | context,openmemory,om,list,query,stats,delete | 0.5 | 2026-01-27 |
| 10 | 7d54a1ea | procedural | How to use OpenMemory: it semantically matches... | context,openmemory,om,use,overview | 0.4 | 2026-01-27 |
| 11 | 0f3382b9 | semantic | overdue tasks (see overdue below): | context,ptt,task,overdue,exec:ptt list overdue | 0.4 | 2026-01-27 |
| 12 | 219e5fc7 | semantic | current task list (see task-list below): | context,ptt,task,list,show,exec:ptt list | 0.4 | 2026-01-26 |
| 13 | d222cfb2 | episodic | to complete an item, use ptt complete item | context,ptt,complete,completion,archive | 0.4 | 2026-01-26 |
| 14 | e6c8da15 | semantic | to update task details, use ptt update task field=value | context,ptt,update,edit | 0.4 | 2026-01-26 |
| 15 | fc38bd85 | semantic | to log progress on a recurring task or habit... | context,ptt,log,habit,recurring | 0.4 | 2026-01-26 |
| 16 | c4f2b522 | semantic | to append a timestamped note to a task... | context,ptt,add-note,note,append | 0.4 | 2026-01-26 |
| 17 | 2279c215 | episodic | to get raw json view models for ui integration... | context,ptt,api,json,view | 0.4 | 2026-01-26 |
| 18 | e03ef2d3 | semantic | for ai behaviour rules, see behaviour below: | context,ptt,behaviour,exec:ptt behaviour | 0.4 | 2026-01-26 |
| 19 | 61951eda | semantic | for planning principles, see planning below: | context,ptt,planning,exec:ptt planning | 0.4 | 2026-01-26 |
| 20 | adc2d03a | semantic | for common request workflows... | context,ptt,requests,exec:ptt requests | 0.4 | 2026-01-26 |
| 21 | fab979c6 | procedural | if asked what to work on or how to decide... | context,ptt,flow,exec:ptt flow | 0.4 | 2026-01-26 |
| 22 | 667e48b8 | semantic | to mark a task complete, see the completion steps... | context,ptt,completion,exec:ptt completion | 0.4 | 2026-01-26 |
| 23 | 33ccad19 | semantic | week ahead schedule (see week below): | context,ptt,week,exec:ptt week | 0.4 | 2026-01-26 |
| 24 | 08264c0a | semantic | upcoming events (see events below): | context,ptt,event,exec:ptt events | 0.4 | 2026-01-26 |
| 25 | a669f69b | semantic | sprint-focused tasks (see sprint below): | context,ptt,task,sprint,exec:ptt list --sprint | 0.4 | 2026-01-26 |
| 26 | 8da31e6d | semantic | tasks with upcoming deadlines (see due below): | context,ptt,task,due,exec:ptt list --due | 0.4 | 2026-01-26 |
| 27 | 8d7107d8 | semantic | completed tasks from the last 30 days... | context,ptt,task,done,exec:ptt list --done | 0.4 | 2026-01-26 |
| 28 | 658a3aea | semantic | to view tasks in the backlog (someday/maybe list)... | context,ptt,backlog,exec:ptt backlog | 0.4 | 2026-01-26 |
| 29 | eb355655 | procedural | to create a new project, create a markdown file... | context,ptt,project,create,exec:ptt schema project | 0.4 | 2026-01-26 |
| 30 | a87f9088 | semantic | To add items to payday shopping list, edit payday.md... | payday,add,append,list,shopping | 0.4 | 2026-01-17 |
| 31 | d05ae2f1 | semantic | Quick notes should be appended to scratchpad.md | context,note,capture,quick,scratchpad | 0.4 | 2026-01-16 |
| 32 | 9937e550 | semantic | Dashboard uses file-based data model... | context,dashboard,data-model | 0.4 | 2026-01-10 |
| 33 | 8d73e050 | semantic | (empty content) | context,dashboard,standards,react | 0.4 | 2026-01-10 |
| 34 | c8239f34 | episodic | Dashboard refactoring patterns: extract duplicate... | context,dashboard,refactoring,pattern | 0.4 | 2026-01-10 |
| 35 | 5c7b09e0 | semantic | Dashboard organizes life into 4 pillars... | context,dashboard,domain,pillars | 0.4 | 2026-01-10 |
| 36 | 652f634c | semantic | (empty content) | context,dashboard,design,ui | 0.4 | 2026-01-10 |
| 37 | 37e1df0c | semantic | Dashboard plugin uses monorepo structure... | context,architecture,dashboard,pattern | 0.4 | 2026-01-10 |
| 38 | 251b347d | reflective | Implemented across Mise en Place RecipeParser... | pattern,typescript,network,api,security | 0.4 | 2026-01-08 |
| 39 | 450ab9f0 | reflective | Prevents corrupted processing of mid-update files... | pattern,typescript,file-watching,race-condition | 0.4 | 2026-01-08 |
| 40 | 027cad3c | semantic | (empty content) | context,performance,limits,mise-en-place | 0.4 | 2026-01-08 |
| 41 | 815bff91 | episodic | All processing is async with retry logic | context,architecture,obsidian,async | 0.4 | 2026-01-08 |
| 42 | bfff77d3 | semantic | --help | (no tags) | 0.4 | 2026-01-08 |
| 43 | 5d7b987e | semantic | Test project scoping: for memory-layer project | context | 0.4 | 2026-01-07 |
| 44 | 9ee8ac22 | semantic | Restored sys-apps.nix and wired OpenMemory wrappers | changelog,openmemory,infra | 0.4 | 2026-01-06 |
| 45 | cb54e5e6 | semantic | Use apply_patch for single-file edits... | pattern,nix,workflow | 0.4 | 2026-01-06 |
| 46 | b9ebe5d9 | semantic | nix-config is a NixOS flake with overlays... | context,nixos,flake | 0.4 | 2026-01-06 |
| 47 | 86342414 | semantic | Smoke test memory: OpenMemory local wrappers | context | 0.4 | 2026-01-06 |

## Immediate Blockers

1. **om-list and om-query are broken** — SQLite query error prevents all retrieval.
   Fix required before M1 retrieval queries (Task 1.2) or M5 eval harness can run.
2. **3 test memories** (#3, #4, #5) and **3 empty-content memories** (#33, #36, #40)
   should be cleaned up.
3. **1 garbage memory** (#42: content is "--help") should be deleted.
4. **Duplicate task-create memories** (#1 and #2) — same content, different sectors.
