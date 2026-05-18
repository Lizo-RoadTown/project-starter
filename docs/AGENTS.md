# Agents, MCP servers, and skills — what's in the templates

Every project scaffolded from this repo ships with three layers of agent capability. This doc says what each layer is, what it costs, and when to lean on it.

## Layer 1 — MCP servers (pinned in `.mcp.json`)

MCP (Model Context Protocol) servers extend Claude Code with new tools. The three pinned in `templates/_common/.mcp.json` get connected every session in the scaffolded project.

| Server | What it does | When it pays off | Cost |
|---|---|---|---|
| **Serena** | LSP-backed semantic code retrieval. Find symbol, find references, get definitions — without reading whole files. | Any non-trivial codebase. The single biggest in-session token saver for code work. | First call boots the language server (~2-5s). After that, sub-second. |
| **Context7** | Up-to-date library / framework / API docs. Beats training-data recall, especially for fast-moving libraries (Next.js, Tailwind, Prisma). | Anytime you're consulting docs for a library, framework, SDK, CLI tool, or cloud service. | Network roundtrip per query. |
| **GitHub** | Read/write GitHub via MCP — issues, PRs, repo metadata. | When work spans GitHub state — pulling issue context, posting PR review comments. | OAuth on first use. |

These are project-pinned (in `.mcp.json` at the repo root) rather than user-pinned (in `~/.claude/settings.json`) so that the project's expectations travel with the repo. A new collaborator clones, opens Claude Code, gets the same agent capabilities.

### When NOT to use an MCP server

- **Don't reach for Context7 for general programming concepts** — it's for library/API/CLI questions. Algorithm questions, language features, design patterns: just answer directly.
- **Don't use the GitHub MCP for routine git ops** — use `gh` CLI from Bash. The MCP server is for *structured* GitHub data (issues, reviews, PR metadata), not for replacing `git push`.

## Layer 2 — Claude Code skills (referenced in `CLAUDE.md`)

Skills are markdown files installed at the user level (`~/.claude/skills/`) that get auto-loaded based on triggers. The scaffolded `CLAUDE.md` tells future Claude Code sessions which ones to reach for.

### Base skills (every variant)

| Skill | When |
|---|---|
| `concise-planning` | Any non-trivial task. Produces atomic checklist (Approach / Scope / Action Items / Validation) with ≤1-2 clarifying questions. |
| `architecture-decision-records` | Architectural choices — paired with `docs/proposals/`. |
| `claude-md-management` | Periodically audit + improve `CLAUDE.md`. Has a quality rubric. |
| `code-reviewer` / `code-review-excellence` | Before merging. |
| `pr-review-toolkit` | Strengthens PR descriptions and review flow. |
| `feature-dev` | New feature workflow. |
| `code-refactoring-refactor-clean` | Refactor patterns. |
| `context-management-context-save` / `context-restore` | Mid-session hand-off. |
| `context-compression` | When the conversation is getting long. |
| `audit-context-building` | Review what's loaded if something feels off. |
| `skill-creator` | Build project-specific skills as the project evolves. |
| `session-report` | End-of-session summaries. |
| `cc-skill-coding-standards` | Universal coding standards reference. |

### `ui-app`-specific

| Skill | When |
|---|---|
| `ui-ux-pro-max` | Any UI structure / visual design / interaction decision. 99 UX guidelines, 161 color palettes, anti-patterns. |
| `design-system` | Three-layer token architecture (primitive → semantic → component). |
| `design` | Brand identity, design tokens, UI styling. |
| `onboarding-psychologist` | First-use flows. IDENTITY-TO-HABIT arc backed by behavioral research. |
| `frontend-design` (official plugin) | Frontend design companion. |
| `cc-skill-frontend-patterns` | Frontend code patterns. |

### `agent-app`-specific

| Skill | When |
|---|---|
| `ai-agents-architect` | Designing agent architecture — single agent, multi-agent, orchestration patterns. |
| `agent-memory-systems` | Designing the memory layer (LanceDB / vector store / structured DB). |
| `agent-orchestrator` | Multi-agent coordination patterns. |
| `ralph-loop` (official plugin) | Iterative agent loops (paired with `/loop`). |
| `claude-api` (official skill) | Building agentic apps with the Anthropic SDK. Triggers on `anthropic` / `@anthropic-ai/sdk` imports. |

### How to install a skill

Skills come from the Claude Code marketplace. The user-level install is one-time per machine:

```
/skill install <skill-name>
```

The scaffolded `CLAUDE.md` *references* skills but doesn't install them. If a session reaches for one that isn't installed, Claude Code will say so — install it then.

## Layer 3 — Built-in harness capabilities (always available, no install)

These are part of Claude Code itself. The scaffolded `CLAUDE.md` flags them so sessions remember to use them:

| Capability | When |
|---|---|
| `EnterPlanMode` | Designing before coding. Locks tools to read-only while you draft an approach. |
| `TodoWrite` | Multi-step tasks. Tracks in-flight progress; exactly one item in_progress at a time. |
| `Agent` tool with `Explore` subagent | Delegated code search / repo exploration when ≥3 queries would be needed. Protects the main context window. |
| `Agent` tool with `general-purpose` subagent | Open-ended multi-step research delegated off-thread. |
| `WebFetch` / `WebSearch` | One-off doc lookups when Context7 doesn't cover the source. |

## How the three layers fit together

```
┌─────────────────────────────────────────────────┐
│  Built-in (always there): plan mode, todos,     │
│  Explore agent, web fetch                       │
├─────────────────────────────────────────────────┤
│  Skills (referenced in CLAUDE.md, installed     │
│  at user level): concise-planning, code-reviewer,│
│  ui-ux-pro-max, claude-api, etc.                │
├─────────────────────────────────────────────────┤
│  MCP servers (pinned in .mcp.json, auto-loaded  │
│  per project): Serena, Context7, GitHub         │
├─────────────────────────────────────────────────┤
│  Auto-memory (at ~/.claude/projects/<name>/):   │
│  user role, feedback, project facts, references │
└─────────────────────────────────────────────────┘
```

- **Auto-memory** is the persistence backbone — what's true across sessions.
- **MCP servers** are the project-pinned tools — what every collaborator gets.
- **Skills** are the user-pinned playbooks — what *you* reach for when the task fits.
- **Built-ins** are always there as fallback.

The `CLAUDE.md` template's job is to make sure agents know which layer to reach for at which moment, so they don't reinvent.

## Adding or removing capabilities

| Want to… | Change… |
|---|---|
| Add a new MCP server (e.g. Linear, Notion) every new project should have | `templates/_common/.mcp.json` |
| Drop one of the pinned MCP servers | `templates/_common/.mcp.json` and the reference in `templates/_common/CLAUDE.md` |
| Add a new skill recommendation for all projects | `templates/_common/CLAUDE.md` → "Skills to lean on" section |
| Add a skill recommendation only for UI projects | `templates/ui-app/CLAUDE.md.extension` |
| Add a skill recommendation only for agent projects | `templates/agent-app/CLAUDE.md.extension` |
| Create a new variant with its own agent stack | See [CONTRIBUTING.md](../CONTRIBUTING.md) → "How to add a new variant" |
