#!/usr/bin/env bash
set -e

# Interactive Maintenance
om-ctx-add "To update task details (priority, project, etc) interactively, use \`ptt update -i\`." \
  --project global --tags "ptt,update,interactive,cli"

om-ctx-add "To mark a task as done and move it to the archive, use \`ptt archive -i\`." \
  --project global --tags "ptt,archive,completion,cli"

om-ctx-add "To log a progress entry on a recurring task or habit, use \`ptt log -i\`." \
  --project global --tags "ptt,log,tracking,cli"

om-ctx-add "To append a timestamped note to a task's body, use \`ptt add-note -i\`." \
  --project global --tags "ptt,note,context,cli"

# AI Brain & Guidance
om-ctx-add "To read the rules on how the AI agent should behave and make decisions, use \`ptt behaviour\`." \
  --project global --tags "ptt,rules,agent,guidance,cli"

om-ctx-add "To access the core principles for planning and scheduling, use \`ptt planning\`." \
  --project global --tags "ptt,planning,principles,cli"

om-ctx-add "To see standard operating procedures for common requests, use \`ptt requests\`." \
  --project global --tags "ptt,playbook,sop,cli"

# TUI & Visibility
om-ctx-add "To open the interactive daily dashboard TUI, use the command \`expo today\`." \
  --project global --tags "ptt,tui,dashboard,expo"

om-ctx-add "To open the full task manager TUI with filters, use the command \`expo tasks\`." \
  --project global --tags "ptt,tui,manager,expo"

om-ctx-add "To view tasks in the backlog (someday/maybe list), use \`ptt backlog\`." \
  --project global --tags "ptt,backlog,someday,cli"

om-ctx-add "To get raw JSON view models for UI integration, use \`ptt view today\` or \`ptt view tasks\`." \
  --project global --tags "ptt,api,json,view,cli"

echo "Seed complete."
