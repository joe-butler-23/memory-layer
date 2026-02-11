  Memory Audit

  Issue 1: Backtick instructional memories use -i (human/interactive) form

  These 5 memories instruct the AI to use -i (interactive picker), which requires a TTY — useless for machine agents:
  Memory: update task
  Current (human): ptt update -i
  Should be (machine): ptt update <name> field=value or ptt op run item.update --mode apply --input
    '{"path":"...","updates":[...]}'
  ────────────────────────────────────────
  Memory: archive/complete
  Current (human): ptt archive -i
  Should be (machine): ptt archive <name> or ptt op run item.archive
  ────────────────────────────────────────
  Memory: log progress
  Current (human): ptt log -i
  Should be (machine): ptt log <name> or ptt op run task.log
  ────────────────────────────────────────
  Memory: add note
  Current (human): ptt add-note -i
  Should be (machine): ptt add-note <name> "note text" or ptt op run task.add_note
  ────────────────────────────────────────
  Memory: JSON view
  Current (human): ptt view today/ptt view tasks
  Should be (machine): These are already machine-friendly (JSON output) — fine as-is
  The first 4 should drop -i and use the non-interactive form (pass task name directly). The ptt op path is even better
   for automation but more verbose.

  Issue 2: Task/event/project create memories use ptt schema (template display) instead of actual create commands
  ┌────────────────┬─────────────────────────┬──────────────────────────────────────────────────────┐
  │     Memory     │    Current exec tag     │                   Better exec tag                    │
  ├────────────────┼─────────────────────────┼──────────────────────────────────────────────────────┤
  │ task create    │ exec:ptt schema task    │ exec:ptt op schema task.create                       │
  ├────────────────┼─────────────────────────┼──────────────────────────────────────────────────────┤
  │ event create   │ exec:ptt schema event   │ exec:ptt op schema event.create                      │
  ├────────────────┼─────────────────────────┼──────────────────────────────────────────────────────┤
  │ project create │ exec:ptt schema project │ No ptt op equivalent — ptt schema project is correct │
  └────────────────┴─────────────────────────┴──────────────────────────────────────────────────────┘
  The ptt schema task shows a YAML template the AI has to manually write to a file. ptt op schema task.create shows the
   JSON contract the AI can feed to ptt op run task.create --mode apply --input '{...}' — fully deterministic, no file
  creation needed.

  Issue 3: Missing ptt commands with no memory coverage
  ┌───────────────────────┬───────────────────────────────────────────┬────────────────────────────────────────┐
  │        Command        │               What it does                │            Worth a memory?             │
  ├───────────────────────┼───────────────────────────────────────────┼────────────────────────────────────────┤
  │ ptt review            │ Weekly review workflow                    │ Yes — natural intent ("weekly review") │
  ├───────────────────────┼───────────────────────────────────────────┼────────────────────────────────────────┤
  │ ptt list scheduled    │ Scheduled tasks                           │ Yes — "what's scheduled?"              │
  ├───────────────────────┼───────────────────────────────────────────┼────────────────────────────────────────┤
  │ ptt list today        │ Tasks scheduled today                     │ Yes — alias for "what's on today"      │
  ├───────────────────────┼───────────────────────────────────────────┼────────────────────────────────────────┤
  │ ptt notes             │ List non-task notes                       │ Maybe — lower frequency                │
  ├───────────────────────┼───────────────────────────────────────────┼────────────────────────────────────────┤
  │ ptt show <name>       │ Display task file contents                │ Yes — "show me task X"                 │
  ├───────────────────────┼───────────────────────────────────────────┼────────────────────────────────────────┤
  │ ptt complete <name>   │ Complete an item (different from archive) │ Yes — distinct from archive            │
  ├───────────────────────┼───────────────────────────────────────────┼────────────────────────────────────────┤
  │ ptt reschedule <name> │ Reschedule task/event                     │ Yes — "reschedule X to Monday"         │
  ├───────────────────────┼───────────────────────────────────────────┼────────────────────────────────────────┤
  │ ptt context           │ Quickstart/paths/topics                   │ No — dev-oriented, not user intent     │
  ├───────────────────────┼───────────────────────────────────────────┼────────────────────────────────────────┤
  │ ptt op list           │ List machine operations                   │ No — meta/dev command                  │
  ├───────────────────────┼───────────────────────────────────────────┼────────────────────────────────────────┤
  │ ptt create            │ Direct task creation (flags)              │ No — covered by schema/op memory       │
  ├───────────────────────┼───────────────────────────────────────────┼────────────────────────────────────────┤
  │ ptt event create      │ Direct event creation                     │ No — covered by schema/op memory       │
  └───────────────────────┴───────────────────────────────────────────┴────────────────────────────────────────┘
  Issue 4: The ptt completion memory is ambiguous

  The current memory text says "to mark a task complete" but ptt completion outputs a reference document (completion
  workflow steps). The actual command to complete a task is ptt complete <name>. These are different things and could
  cause the AI to exec the wrong one.

  ---
  Summary of recommended changes

  Fix (4): Rewrite backtick memories #17-20 to use non-interactive forms
  Fix (3): Change task/event create exec tags from ptt schema to ptt op schema
  Fix (1): Clarify the completion memory text to avoid confusion with ptt complete
  Add (5): review, list scheduled, list today, show, reschedule, complete
  Total after: 36 memories (31 current - 0 removed + 5 added)