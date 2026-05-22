# Changelog

All notable changes to this repo will be documented here.

Format: [Keep a Changelog 1.1.0](https://keepachangelog.com/en/1.1.0/) ·
Versioning: [Semantic Versioning 2.0.0](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- OSS hygiene files (CODE_OF_CONDUCT, SECURITY, CHANGELOG, CODEOWNERS, CITATION.cff, .github/ issue + PR templates)
- GitHub Actions CI for markdown lint, JSON validation, HTML validation
- Compatibility badges on every variant piece page (Claude Code only vs Agent Skills compatible)
- New docs page: "Other Agent Skills clients" — covers using the portable subset with Cursor, Gemini CLI, OpenCode, etc.
- Bifurcated site hero: "Claude Code path" vs "Other clients path" decision card

### Changed

- `onboarding-psychologist` and `ai-agents-architect` now have public install paths (via the new [Lizo-RoadTown/claude-skills-marketplace](https://github.com/Lizo-RoadTown/claude-skills-marketplace) repo). Status pills updated from "unverified" to Lizo-RoadTown attribution with real `/plugin install` commands.
- `install-skills.ps1/.sh` extended to register the `lizo-skills` marketplace and print its `/plugin install` commands.
- `marketplace-and-plugins.html` updated to include the `Lizo-RoadTown/claude-skills-marketplace` marketplace in the per-variant install tables.

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

[Unreleased]: https://github.com/Lizo-RoadTown/project-starter/compare/v0.2.0...HEAD
[0.2.0]: https://github.com/Lizo-RoadTown/project-starter/releases/tag/v0.2.0
[0.1.0]: https://github.com/Lizo-RoadTown/project-starter/releases/tag/v0.1.0
