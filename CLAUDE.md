# Working in project-starter

Project context for Claude Code. Loaded into every session opened in this repo.

## What this repo is

The day-1 project scaffolder for projects worked on with Claude Code. Ships variant templates under `templates/` (currently `_common`, `ui-app`, `agent-app`) that scaffolded projects inherit from. Each variant captures lessons learned about keeping token usage low, accuracy high, and architecture decisions visible across sessions.

**Critical**: edits to `templates/_common/CLAUDE.md` PROPAGATE to every future project scaffolded from this repo. Treat that file as a template-the-template surface — changes there become the default text in every new spawn.

## Discipline plugin (required)

```text
/plugin marketplace add Lizo-RoadTown/claude-skills-marketplace
/plugin install loom-discipline@lizo-loom
```

PROBE before asserting (cite file:line). Distinguish dev-tooling from runtime. Save corrections as feedback memory immediately.

## Canonical patterns (operator's patterns library)

The canonical home for reusable agents + skills + tools is the `liz-patterns` plugin:

```text
/plugin install liz-patterns@lizo-skills
```

This makes the following available **by name in every project**, with one canonical implementation:

- **Agents** (invoke via `Agent({subagent_type: "liz-patterns:<name>", ...})`):
  `infrastructure-mapping`, `next-actions-planning`, `lessons-learned`, `orchestration-cataloging`, `eval-deep-research`, `web-app-scaffold`, `agentic-upskilling`
- **Skills** (invoke via Skill tool with `liz-patterns:<name>`):
  `agentic-skill-design`, `deep-research-pattern`, `design-evaluation`, `documentation`, `document-parsing`, `layered-explanation`, `open-source-documentation`, `proposal-authoring`

**Do not scaffold per-project copies of these patterns.** The whole point of the plugin is one canonical home, available everywhere via reference. If `install-skills.sh` or `install-skills.ps1` ever start copying these into spawned projects' local `skills/` directories, that's a Pillar-1 violation — the canonical-patterns text in `templates/_common/CLAUDE.md` already directs spawned projects at the plugin.

Per [tapestry/MANIFESTO.md Pillar 1](https://github.com/Lizo-RoadTown/tapestry/blob/main/MANIFESTO.md): every reusable pattern has ONE name, ONE home, available everywhere via reference, not copy.

## How the template propagates

When `scripts/install-skills.{sh,ps1}` runs after a `web-app` or `agent-app` scaffold, it installs Claude Code marketplace skills at the USER level (`~/.claude/skills/`) — NOT into the project's local directory. This is the right shape: skills available globally, no per-project copies.

The CLAUDE.md template at `templates/_common/CLAUDE.md` is the source-of-truth for what every scaffolded project's CLAUDE.md says about canonical patterns. Keep it aligned with the liz-patterns plugin's current contents.

## Tone

No marketing voice. Describe what *is*, not what it *isn't*. Plain, direct, descriptive.
