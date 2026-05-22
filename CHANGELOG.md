# Changelog

All notable changes to this repo will be documented here.

Format: [Keep a Changelog 1.1.0](https://keepachangelog.com/en/1.1.0/) ·
Versioning: [Semantic Versioning 2.0.0](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.4.0] — 2026-05-22

This release operationalizes a multi-agent collaboration with the Make_Skills agent via a shared communication document (`docs/assets/2026-05-21-project-starter-recommendations.md`). All v0.4.0 scope was reviewed by the Make_Skills agent before publish; review findings from three parallel subagents (code-reuse, code-quality, efficiency) were applied before any commits.

### Added

- **Memory infrastructure for scaffolded projects:**
  - `templates/_common/scripts/seed-memory.sh` + `seed-memory.ps1` — idempotent, self-healing per-file writers that seed Claude Code's auto-memory directory with typed memory files (`user_*`, `feedback_*`, `project_*`, `reference_*`) and a starter `MEMORY.md` index.
  - Memory architecture section in `templates/_common/CLAUDE.md` documenting the two-layer model (file-protocol everywhere; LanceDB+MCP backbone for `agent-app`).
- **Discipline plugin recommendation:** `templates/_common/CLAUDE.md` now includes a section pointing scaffolded projects at `lizo-skills/make-skills-discipline` (auto-injects PROBE-first behavior, `file:line` citation, dev-vs-runtime distinction, friction-as-memory writing via Claude Code hooks). Recommended in v0.4.0; will become required in v0.4.1 after smoke-test.
- **Decision records (ADRs):** `templates/_common/docs/decisions/` with `README.md` and `TEMPLATE.md`. Sequence-numbered, immutable-once-Accepted, citable by ID.
- **Runbooks:** `templates/_common/docs/runbooks/` with `README.md` explaining the operational-guide pattern.
- **Cross-repo sync tooling:**
  - `scripts/sync-agent-comms.{sh,ps1}` — keeps the shared agent-communication doc in sync between project-starter and Make_Skills checkouts. Derives paths from script location + `.sync-config` (gitignored) or `AGENT_COMMS_REMOTE` env var. Cross-platform `stat`/`date` with BSD/macOS fallbacks. Handles Windows backslash paths correctly.
  - `.sync-config.example` template; `.sync-config` is gitignored.

### Changed

- **`templates/agent-app/SKILLS.md`**: rewritten per a 3-tier structure (Discipline / LLM-app stack / Situational) with namespaced `lizo-skills/*` names. Tier-1 includes a "Memory MCP is built in" callout pointing at the variant's planned LanceDB layer.
- **`templates/ui-app/SKILLS.md`**: rewritten per a 4-tier structure (Discipline / Design + framework / Figma workflow / Public-facing surfaces) with namespaced names.
- **`templates/ui-app/docs/UX_CONTRACT.md`**: replaced the 157-line paraphrase with the full Liz Osborn version from Make_Skills (lifted + generalized agent-specific examples to `<adapt-this>` placeholders). Adds the IDENTITY-TO-HABIT research citations (Volpp & Loewenstein 2020, Stawarz et al. 2015, Sheeran et al. 2020) and a 13-item review checklist.

### Notes

- LanceDB+MCP code scaffolding for `templates/agent-app/platform/` is queued for v0.4.1 — depends on Make_Skills's PR #32 (Phase 1 memory MCP) and PR #33 (Phase 2 sync shim) shipping. Variant currently ships discipline + skills + docs only.
- `templates/ui-app/` code scaffolding (Next.js/Tailwind/React starter) deferred to v0.4.1.

## [0.3.0] — 2026-05-21

## [0.2.0] — 2026-05-21

### Added

- Beginner-friendly docs site at `site/docs/` (multi-page, sidebar nav).
- Variant documentation: hub page + 11 researched detail pages, one per variant piece. Each page has at-a-glance metadata, what-it-does, when-it-triggers, install command, references.
- Marketplace & plugins docs page covering the Claude Code marketplace ecosystem.
- SKILLS.md files in each variant template — copied into scaffolded projects with install commands.
- `scripts/install-skills.ps1` and `scripts/install-skills.sh` — auto-install the shell-installable skills, print `/plugin install` commands for the rest.
- `scripts/update-sidebar.js` — one-shot script to propagate sidebar changes across all docs pages.
- Render Blueprint (`render.yaml`) for one-click deploy of the demo site.
- Illustrative SVG thumbnails (`docs/assets/thumbnail-illustrative.svg`).
- Demo site at `site/` — single-page static showcase + the docs subdirectory.

### Changed

- Main page section order: Hero → Variants → Foundation → Scaffold (was scaffold-first).
- Variant cards bucketed into 3 plain-language categories per variant (was flat 5-item lists).
- Variant pages now live as direct sidebar nav entries (was a single hub with cards).
- Stack section descriptions rewritten from name lists to real plain-language explanations.

## [0.1.0] — initial seed

### Added

- Templates for `_common`, `ui-app`, `agent-app` variants with `CLAUDE.md`, `.mcp.json`, `.gitignore`, `docs/proposals/`, `docs/plans/`, `docs/test-runs/`, `docs/UX_CONTRACT.md`.
- PowerShell scaffolder (`new-project.ps1`).
- Bash scaffolder (`new-project.sh`).
- Docker scaffolder (`Dockerfile`, `docker-compose.yml`).
- README, CONTRIBUTING, LICENSE (Apache 2.0).
- Initial `docs/WALKTHROUGH.md`, `docs/AGENTS.md`, `docs/DOCKER.md`.

[Unreleased]: https://github.com/Lizo-RoadTown/project-starter/compare/v0.4.0...HEAD
[0.4.0]: https://github.com/Lizo-RoadTown/project-starter/releases/tag/v0.4.0
[0.3.0]: https://github.com/Lizo-RoadTown/project-starter/releases/tag/v0.3.0
[0.2.0]: https://github.com/Lizo-RoadTown/project-starter/releases/tag/v0.2.0
[0.1.0]: https://github.com/Lizo-RoadTown/project-starter/releases/tag/v0.1.0
