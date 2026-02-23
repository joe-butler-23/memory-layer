#!/usr/bin/env bash
set -euo pipefail

# seed_all_memories.sh -- re-create canonical OpenMemory entries
# Generated from memory.sqlite on 2026-02-08

source ~/.config/openmemory/env

SQLITE="/nix/store/awm8pnzpcj63lb26asvjm24j4kwg4d76-sqlite-3.50.4-bin/bin/sqlite3"
DB="$HOME/.local/share/openmemory/memory.sqlite"

echo '==> Wiping existing data...'
$SQLITE "$DB" "DELETE FROM vectors; DELETE FROM waypoints; DELETE FROM embed_logs; DELETE FROM memories;"

MEMORY_COUNT=$(grep -c '^om-ctx-add ' "$0")
echo "==> Seeding $MEMORY_COUNT canonical memories..."

# 1. 4cb3b40c-c1b1-4b9e-ae97-6c44c134c264
om-ctx-add 'current task list (see task-list below): run ptt list to see actionable tasks.' --project global --tags 'context,ptt,task,list,show,exec:ptt list'

# 2. 29ce777f-5d5f-4116-8298-5980781dd6ef
om-ctx-add 'overdue tasks (see overdue below): run ptt list overdue to see tasks past their due date.' --project global --tags 'context,ptt,task,overdue,exec:ptt list overdue'

# 3. 67157889-3131-4f6a-a1d6-d77e0135f570
om-ctx-add 'Completed tasks from the last 30 days (see done below): run ptt list --done for archive.' --project global --tags 'context,ptt,task,done,exec:ptt list --done'

# 4. e0d521e4-fb00-4a07-996a-017e9d419d62
om-ctx-add 'Tasks with upcoming deadlines (see due below): run ptt list --due for tasks with due dates.' --project global --tags 'context,ptt,task,due,exec:ptt list --due'

# 5. finance check-in workflow
om-ctx-add 'Finance check-in workflow: run ptt context finance for database locations, SQL queries, and weekly budget calculations.' --project global --tags 'context,ptt,finance,budget,checkin,exec:ptt context finance'

# 6. ab1ad79b-183c-44de-bd33-7be22846086a
om-ctx-add 'Upcoming events (see events below): run ptt events to see calendar events.' --project global --tags 'context,ptt,event,exec:ptt events'

# 7. 7d2916b5-14d8-48aa-b8c9-6ea550958010
om-ctx-add 'Week ahead schedule (see week below): run ptt week for upcoming events and tasks.' --project global --tags 'context,ptt,week,exec:ptt week'

# 8. 2dae5ad0-264a-4236-a4e6-234eba6c7989
om-ctx-add 'To see task completion workflow steps (reference doc), run ptt completion. Note: this is different from ptt complete <name> which marks a task done.' --project global --tags 'context,ptt,completion,workflow,exec:ptt completion'

# 9. f018ffbd-0ef2-4689-8974-c9cd342dbacb
om-ctx-add 'if asked what to work on or how to decide next action, see flow below: run ptt flow for execution guidance.' --project global --tags 'context,ptt,flow,exec:ptt flow'

# 10. 8dfd02e0-1bcb-4863-91db-96404a9f6e84
om-ctx-add 'for common request workflows (organise, plan my day, add to inbox, etc), see requests below: run ptt requests.' --project global --tags 'context,ptt,requests,exec:ptt requests'

# 11. 3ce32c0d-f7e0-437f-99f8-c7f1b040e0bb
om-ctx-add 'for planning principles, see planning below: run ptt planning for scheduling guidance.' --project global --tags 'context,ptt,planning,exec:ptt planning'

# 12. d2cec2fc-1a3e-4c05-9b1b-7360df902e4c
om-ctx-add 'for ai behaviour rules, see behaviour below: run ptt behaviour for agent guidelines.' --project global --tags 'context,ptt,behaviour,exec:ptt behaviour'

# 13. 99a481d8-eb6f-4ed5-a1ad-fa50447509d2
om-ctx-add 'To view tasks in the backlog (someday/maybe list), use ptt backlog for deferred tasks.' --project global --tags 'context,ptt,backlog,exec:ptt backlog'

# 14. 72b9f6fc-17da-415d-bde0-43a2a06cef09
om-ctx-add 'to create or add a new task, use ptt op schema task.create to see the JSON contract, then run with ptt op run task.create --mode apply --input '\''{...}'\''.' --project global --tags 'context,ptt,task,create,add,new,schema,exec:ptt op schema task.create'

# 15. a49ecd96-a717-4281-ae4f-c34ce7e95fe3
om-ctx-add 'Add an event / create an event: use ptt op schema event.create to see the JSON contract, then run with ptt op run event.create --mode apply --input '\''{...}'\''.' --project global --tags 'context,ptt,event,add,create,schema,exec:ptt op schema event.create'

# 16. 7847df46-ef40-41b9-8d74-f6ff621d1aa4
om-ctx-add 'To create a new project, create a markdown file in ~/vault/projects using the project schema.' --project global --tags 'context,ptt,project,create,exec:ptt schema project'

# 17. 8f99308a-88b7-4dd1-bd57-e8c17fc56f90
om-ctx-add 'To update task details (priority, project, etc), use ptt update <name> field=value or ptt op run item.update --mode apply --input '\''{"path":"...","updates":[...]}'\''.' --project global --tags 'context,ptt,update,cli,exec:ptt op schema item.update'

# 18. 82ccb36f-e892-4b5f-b7c4-451924ab8a0c
om-ctx-add 'To mark a task as done and move it to the archive, use ptt archive <name> or ptt op run item.archive.' --project global --tags 'context,ptt,archive,completion,cli,exec:ptt op schema item.archive'

# 19. 2fb7c2e4-9b1c-439f-aaa0-8249aae3d53f
om-ctx-add 'To log a progress entry on a recurring task or habit, use ptt log <name> or ptt op run task.log.' --project global --tags 'context,ptt,log,tracking,cli,exec:ptt op schema task.log'

# 20. 8a314ac0-cee3-4fca-8c58-9609a2dd2e2d
om-ctx-add 'To append a timestamped note to a task'\''s body, use ptt add-note <name> "note text" or ptt op run task.add_note.' --project global --tags 'context,ptt,note,cli,exec:ptt op schema task.add_note'

# 21. 70c00e5f-a999-44bc-8f79-63426beee2b1
om-ctx-add 'To get raw JSON view models for UI integration, use '\`'ptt view today'\`' or '\`'ptt view tasks'\`'.' --project global --tags 'context,ptt,api,json,view,cli'

# 22. 9777acdc-aa5a-4a50-9276-d4fa154b91ee
om-ctx-add 'To open the full task manager TUI with filters, use the command '\`'expo tasks'\`'.' --project global --tags 'context,ptt,tui,manager,expo'

# 23. 8983f1bb-2cdb-48c1-8a37-e0db9131d4ee
om-ctx-add 'To open the interactive daily dashboard TUI, use the command '\`'expo today'\`'.' --project global --tags 'context,ptt,tui,dashboard,expo'

# 24. 743cc88c-38a2-4b96-94b0-dd4376278b70
om-ctx-add 'pt is a shortcut wrapper: pt -> scripts/wrappers/pt.sh which wraps the ptt CLI with common flags.' --project global --tags 'context,pttui,wrapper,cli'

# 25. 02c00552-cfb3-4644-b81c-4d2c380082b3
om-ctx-add 'Add a memory / remember this: om-ctx-add '\''<text>'\'' --project <project> --tags '\''tag1,tag2'\'' (project) or om-ctx-add '\''<text>'\'' --project global --tags '\''tag1,tag2'\'' (global).' --project global --tags 'context,openmemory,om,add,remember,create'

# 26. f4b96637-4461-4342-8b30-a43a01088c4a
om-ctx-add 'How to list or find memories: om-list, om-list --project <name>, om-query '\''<search>'\'', om-stats, om-delete --id <uuid>.' --project global --tags 'context,openmemory,om,list,query,stats,delete'

# 27. d90efaf7-0b1f-43b3-b021-cc216a15fa55
om-ctx-add 'How to use OpenMemory: it semantically matches your prompt to stored knowledge using embeddings. Query with om-query, add with om-ctx-add.' --project global --tags 'context,openmemory,om,use,overview'

# 28. 6479f750-5f30-4b65-b250-16ba9a30a8b7
om-ctx-add 'Quick notes should be appended to scratchpad.md in ~/vault/notes/ for later triage.' --project global --tags 'context,note,capture,quick,scratchpad'

# 29. 87abc2dd-f746-400c-bc5e-28132cc819af
om-ctx-add 'To add items to payday shopping list, edit payday.md in ~/vault/lists/ or append via quick capture.' --project global --tags 'context,payday,add,append,list,shopping'

# 30. 69e70aa5-0380-4b74-a056-fe8ea0ea3292
om-ctx-add 'nix-config is a NixOS flake with overlays for custom packages. Located at ~/nix-config/.' --project global --tags 'context,nixos,flake'

# 31. a4dfbc8f-bcde-482c-8c5b-8f179638bc2f
om-ctx-add 'Use apply_patch for single-file edits and apply_diff for multi-file changes in nix workflow.' --project global --tags 'context,pattern,nix,workflow'

# 32. weekly review workflow: run ptt review for weekly review steps
om-ctx-add 'Weekly review workflow: run ptt review for the full review process.' --project global --tags 'context,ptt,review,weekly,workflow,exec:ptt review'

# 33. list scheduled tasks: run ptt list scheduled to see scheduled tasks
om-ctx-add 'Scheduled tasks: run ptt list scheduled to see tasks with scheduled dates.' --project global --tags 'context,ptt,scheduled,list,tasks,exec:ptt list scheduled'

# 34. list scheduled: run ptt list scheduled and check today's date
om-ctx-add 'Tasks scheduled for today: run ptt list scheduled and check entries for today.' --project global --tags 'context,ptt,today,list,scheduled,exec:ptt list scheduled'

# 35. show task: run ptt show <name> to display task file contents
om-ctx-add 'To show task details and file contents, use ptt show <name>.' --project global --tags 'context,ptt,show,view,task,exec:ptt show'

# 36. complete task: run ptt complete <name> to mark a task complete
om-ctx-add 'To mark a task as complete (different from archive), use ptt complete <name>.' --project global --tags 'context,ptt,complete,done,task'

# 37. budget change workflow
om-ctx-add 'budget change workflow: run ptt context finance, inspect periods+ledger, and verify payday/checkin after approved writes.' --project global --tags 'context,ptt,finance,budget,change,pots,savings_transfers,exec:ptt context finance'

# 38. add monzo pot workflow
om-ctx-add 'add monzo pot workflow: use savings_transfers rows and verify payday pots + summary.' --project global --tags 'context,ptt,finance,monzo,pot,savings_transfers,exec:ptt context finance'

# 39. dotfiles managed via chezmoi
om-ctx-add 'Dotfiles are managed via chezmoi. To edit a dotfile, use `chezmoi edit <file>` (never edit the target directly). After changes, run `chezmoi apply` to deploy. Source of truth: `chezmoi source-path` (typically ~/.local/share/chezmoi).' --project global --tags 'context,dotfiles,chezmoi,edit,apply,workflow'

# 40. zsh config location (XDG)
om-ctx-add 'Zsh configuration lives at ~/.config/zsh (XDG-compliant), not ~/.zshrc. Key files: ~/.config/zsh/.zshrc, ~/.config/zsh/.zshenv, etc. These are managed by chezmoi — use `chezmoi edit ~/.config/zsh/.zshrc` to modify.' --project global --tags 'context,zsh,config,xdg,dotfiles,chezmoi'

# 41. how to add a new OpenMemory entry
om-ctx-add 'To add a new OpenMemory entry: `om-ctx-add '\''<text>'\'' --project global --tags '\''context,<relevant>,<tags>'\''`. After adding, also append the entry to ~/development/memory-layer/scripts/seed_all_memories.sh so it survives reseeds.' --project global --tags 'context,openmemory,add,create,new,memory,meta'

# 42. todoist shopping sync control plane
om-ctx-add 'Todoist shopping sync control plane: run mep sl sync plan --help for contract details, then execute plan -> review -> apply, with rollback from snapshots when needed.' --project global --tags 'context,mep,todoist,shopping,sync,plan,apply,rollback,exec:mep sl sync plan --help'

# 43. todoist shopping preflight
om-ctx-add 'Todoist shopping preflight: run mep sl sync validate --help for strict desired-state checks before planning.' --project global --tags 'context,mep,todoist,shopping,validate,preflight,strict,exec:mep sl sync validate --help'

# 44. todoist shopping failure recovery
om-ctx-add 'Todoist shopping sync failure recovery: run mep sl sync rollback --help and generate a rollback plan from the latest snapshot before any further writes.' --project global --tags 'context,mep,todoist,shopping,recovery,rollback,snapshot,exec:mep sl sync rollback --help'

# 45. recipe import control plane
om-ctx-add 'Recipe import workflow: run mep recipe import-url --help for URL import contract and output shape before ingesting new recipes.' --project global --tags 'context,mep,recipe,import,url,workflow,exec:mep recipe import-url --help'

# 46. recipe memory ingest preflight
om-ctx-add 'Recipe extraction ingest: run mep memory ingest --help for deterministic ingest options and adjudicator toggles.' --project global --tags 'context,mep,recipe,extraction,memory,ingest,exec:mep memory ingest --help'

# 47. recipe memory verification gate
om-ctx-add 'Recipe extraction verification gate: run mep memory verify --help to validate resolution accuracy before shipping changes.' --project global --tags 'context,mep,recipe,extraction,verify,accuracy,exec:mep memory verify --help'

# 48. recipe autolearn promotion
om-ctx-add 'Recipe extraction autolearn workflow: run mep memory autolearn --help to promote repeated unresolved clusters into deterministic aliases.' --project global --tags 'context,mep,recipe,extraction,autolearn,promotion,exec:mep memory autolearn --help'

# 49. recipe composition planning alias
om-ctx-add 'Build one shopping list from multiple recipes: run mep sl sync plan --help and use the plan workflow before apply.' --project global --tags 'context,mep,recipe,composition,shopping,list,merge,exec:mep sl sync plan --help'

# 50. pantry-aware recipe routing alias
om-ctx-add 'Pantry-aware recipe composition: run mep recipe import-url --help to normalize recipe sources before shopping composition.' --project global --tags 'context,mep,recipe,pantry,composition,import,exec:mep recipe import-url --help'

# 51. health blood pressure logging route
om-ctx-add 'Log blood pressure reading workflow: run python3 ~/vault/infrastructure/scripts/log-blood-pressure.py --help for argument contract and dry-run support.' --project global --tags 'context,health,blood-pressure,log,workflow,exec:python3 ~/vault/infrastructure/scripts/log-blood-pressure.py --help'

# 52. health data sync route
om-ctx-add 'Health data sync workflow: run python3 ~/vault/infrastructure/scripts/sync-health-data.py --help to choose sources, date bounds, and dry-run options.' --project global --tags 'context,health,sync,workflow,exec:python3 ~/vault/infrastructure/scripts/sync-health-data.py --help'

# 53. health weekly review generation route
om-ctx-add 'Health weekly review generation: run python3 ~/vault/infrastructure/scripts/generate-weekly-review.py --help for deterministic artifact generation flags.' --project global --tags 'context,health,weekly-review,generate,workflow,exec:python3 ~/vault/infrastructure/scripts/generate-weekly-review.py --help'

# 54. health composite sync+review helper route
om-ctx-add 'Health sync + review helper: run ~/vault/infrastructure/scripts/health-sync-weekly-review.sh --help for plan-safe defaults and apply mode.' --project global --tags 'context,health,weekly-review,sync,composite,helper,exec:~/vault/infrastructure/scripts/health-sync-weekly-review.sh --help'

echo '==> Seed complete. Running stats...'
om-stats --project global
