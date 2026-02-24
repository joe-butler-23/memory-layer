# AGENTS.md - Memory Layer Contributor Guide

This file defines how agents should work in `~/development/memory-layer`.

## Mission

Provide reliable, policy-governed executable-memory behavior for AI clients.

Primary assets:
- memory seed source (`scripts/seed_all_memories.sh`)
- command policy (`config/command-policy.json`)
- documentation of behavior (`README.md`)

## Source of Truth

1. `scripts/seed_all_memories.sh` defines canonical global memory entries.
2. `config/command-policy.json` defines auto-exec allow/block semantics.
3. Client hook implementations live in `~/development/ai/hooks/*` and must stay aligned.

## Exec Mode Contract

- `exec_mode_default` in policy sets baseline mode.
- `OM_EXEC_MODE` overrides per session/client.
- Valid modes: `safe`, `plan`, `permissive`.
- `blocked_patterns` always win.

## Working Rules

1. Keep policy and seed changes synchronized (do not update one without checking the other).
2. If adding/removing `exec:` commands, update:
   - `scripts/seed_all_memories.sh`
   - `config/command-policy.json`
   - `~/development/ptt/docs/context/router-spec.toml` memory command list
3. Keep docs current in the same change.
4. Prefer deterministic, auditable command surfaces (`ptt op schema`, `ptt op run` flows).

## PTT Binary Freshness

Many memory commands execute `ptt` via PATH. If new commands are missing from PATH
(for example `ptt doctor`), refresh the installed binary or use repo-local fallback.

```bash
cargo install --path ~/development/ptt/crates/ptt-cli --force
# or:
cargo run --manifest-path ~/development/ptt/Cargo.toml --bin ptt -- <args>
```

## Verify

```bash
jq empty config/command-policy.json
bash -n scripts/seed_all_memories.sh

# Cross-repo parity (recommended)
cargo run --manifest-path ~/development/ptt/Cargo.toml --bin ptt -- doctor
```

## Skill References

Cross-domain memory behavior guidance lives in:

- `~/development/ai/tooling/skills/memory/SKILL.md`
- `~/development/ai/tooling/skills/clai/SKILL.md`
