# Skills to install for this {{PROJECT_NAME}} project

Your `CLAUDE.md` references skills and plugins that aren't installed by default
on a fresh machine. Install them with the commands below — skills install at
the user level (`~/.claude/skills/`), so this is **one-time per computer**.
Future projects on this machine reuse them.

If you skip an install, Claude will still work — it'll just tell you the skill
isn't available when it tries to reach for it, and you can install it then.

For more on what each skill does, see
[`docs/AGENTS.md`](https://github.com/Lizo-RoadTown/project-starter/blob/main/docs/AGENTS.md)
and the per-piece docs at
[the project-starter docs site](https://github.com/Lizo-RoadTown/project-starter#docs).

---

## 1. `claude-api` — Anthropic's official SDK helper

What it is: Anthropic's official skill providing Claude with up-to-date
reference for the Messages API, Managed Agents, caching, tool use, streaming,
batching, and model migration. Auto-loads when your code imports the SDK.

**If you installed Claude Code via the official installer, this is bundled —
no install needed.** Confirm with:

```text
/plugin list
```

If it's not listed, install via the marketplace from inside Claude Code:

```text
/plugin marketplace add anthropics/skills
/plugin install claude-api@anthropic-agent-skills
```

Or via the standalone CLI:

```bash
npx skills add https://github.com/anthropics/skills --skill claude-api
```

Source: <https://github.com/anthropics/skills/tree/main/skills/claude-api>

---

## 2. `ralph-loop` — Anthropic's official iterative-loop plugin

What it is: a Stop hook that re-feeds the prompt across iterations until
Claude emits a completion-promise tag. Lets you turn a one-shot prompt into
multi-iteration agentic work.

Install via the Claude Code marketplace:

```text
/plugin marketplace add anthropics/claude-plugins-official
/plugin install ralph-loop
```

Then invoke with:

```text
/ralph-loop "<your prompt>" --max-iterations 10 --completion-promise "<promise>COMPLETE</promise>"
```

Source: <https://claude.com/plugins/ralph-loop>

---

## 3. `agent-memory-systems` — CoALA framework, vector stores (community)

What it is: documents the CoALA framework (semantic, episodic, procedural
memory), vector-store selection (Pinecone, Qdrant, Weaviate, ChromaDB,
pgvector, LanceDB), chunking strategies, async memory consolidation, and
decay.

Manual install:

```bash
cd ~/.claude/skills
git clone https://github.com/sickn33/antigravity-awesome-skills
# Symlink or copy the agent-memory-systems skill into ~/.claude/skills/
ln -s "$(pwd)/antigravity-awesome-skills/plugins/antigravity-awesome-skills-claude/skills/agent-memory-systems" .
```

Source:
<https://github.com/sickn33/antigravity-awesome-skills/blob/main/plugins/antigravity-awesome-skills-claude/skills/agent-memory-systems/SKILL.md>

---

## 4. `agent-orchestrator` — multi-agent coordination patterns (community)

What it is: documents the three coordination primitives (Handoff, Assign,
send_message) and three orchestration shapes (supervisor/worker, peer-to-peer,
orchestrator-led).

The closest verified public package is `muratcankoylan`'s `multi-agent-patterns`
in the Context-Engineering skill pack:

```text
/plugin marketplace add muratcankoylan/Agent-Skills-for-Context-Engineering
/plugin install multi-agent-patterns@context-engineering
```

Alternative (if you want a Python reference implementation rather than a
Claude skill): AWS's CLI Agent Orchestrator:

```bash
pip install cli-agent-orchestrator
```

Source: <https://github.com/awslabs/cli-agent-orchestrator>

---

## 5. `ai-agents-architect` — architectural guidance (community, slug-ambiguous)

What it is: a decision framework for agent architecture — ReAct vs.
Plan-and-Execute, single vs. multi-agent, when to introduce an orchestrator.

The exact slug doesn't have a single canonical public package; the patterns
it documents are best learned from Anthropic's authoritative guide on the
same material:

- **Anthropic — Building Effective Agents:**
  <https://www.anthropic.com/research/building-effective-agents>

Closest community skill: `mcpmarket.com/tools/skills/ai-agent-systems-architect`.

If you don't install a specific skill, the patterns are covered in the docs
site's `ai-agents-architect.html` page.

---

## 6. `portable-identity` — already in your CLAUDE.md ✓

This isn't a skill — it's a design discipline documented in your project's
`CLAUDE.md`. Already in place. No install needed.

The rule: keep user data (memory, skills, integrations) decoupled from the
underlying LLM so you can swap models without losing what your app knows
about its users.

---

## Verify install

After installing, open Claude Code in this project and ask:

```text
Which of the skills referenced in CLAUDE.md do you have installed?
```

Claude will check and report. Install any missing ones it flags.
