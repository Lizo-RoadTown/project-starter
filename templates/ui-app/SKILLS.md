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

## 1. `ui-ux-pro-max` — 99 UX rules, 161 palettes (community)

What it is: a design-intelligence skill bundling 67 UI styles, 99 UX
guidelines, 161 color palettes, and 57 font pairings. Activates automatically
on UI/UX prompts.

```bash
npm install -g uipro-cli
uipro init --ai claude
```

Source: <https://github.com/nextlevelbuilder/ui-ux-pro-max-skill>

---

## 2. `design-system` — three-tier token architecture (community)

What it is: the primitive → semantic → component token pattern, with
theme-switching support. Multiple community skills exist under this name; the
Triptease one is the easiest to install.

```bash
cd ~/.claude/skills
git clone https://github.com/triptease/claude-skill-design-system design-system
```

Source: <https://github.com/triptease/claude-skill-design-system>

---

## 3. `frontend-design` — Anthropic's official frontend plugin

What it is: Anthropic's official plugin for distinctive frontend code —
typography, layout, animations. Activates on any frontend-creation prompt.

**If you installed Claude Code via the official installer, this is bundled —
no install needed.** Confirm with:

```text
/plugin list
```

If it's not listed, install via the marketplace from inside Claude Code:

```text
/plugin marketplace add anthropics/claude-plugins-official
/plugin install frontend-design
```

Source: <https://claude.com/plugins/frontend-design>

---

## 4. `onboarding-psychologist` — UNVERIFIED, no public install

This skill name is referenced in the template but has no public source. The
IDENTITY-TO-HABIT framework it documents is real (grounded in BJ Fogg's Tiny
Habits and James Clear's identity-based habits) and the variants docs page
covers the framework in detail.

**Two options:**

1. **Skip it** — the framework lives in the docs; you can apply it manually.
2. **Substitute** — install a published onboarding skill instead, then update
   your `CLAUDE.md` to reference it. Two close substitutes:
   - `adamlyttleapps/claude-skill-app-onboarding-questionnaire` —
     <https://github.com/adamlyttleapps/claude-skill-app-onboarding-questionnaire>
   - "Onboard" skill on MCP Market

---

## 5. `UX_CONTRACT.md` — already in your project ✓

This is a file in your project (`docs/UX_CONTRACT.md`), not a skill. Already
copied by the scaffolder. Edit it freely to match your project's actual rules.

---

## Verify install

After installing, open Claude Code in this project and ask:

```text
Which of the skills referenced in CLAUDE.md do you have installed?
```

Claude will check and report. Install any missing ones it flags.
