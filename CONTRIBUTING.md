# Contributing

This repo is an actively-maintained reference. When you (or another agent on your project) learn something that should be true for every new project, contribute it back.

## What's worth contributing

- **New variants** (e.g. `api-service`, `library`, `cli-tool`, `mobile-app`). Each variant captures the discipline specific to that project shape.
- **Refinements to existing CLAUDE.md sections.** Discipline rules that proved themselves in real projects.
- **New skills to lean on.** As the Claude Code marketplace evolves, the "Skills to lean on" section should evolve with it.
- **Tweaks to UX_CONTRACT.md.** Rules that turned out to be wrong, anti-patterns we missed, examples that didn't translate.
- **Scaffold script improvements.** The PowerShell script is intentionally minimal; PRs that make it more robust (Bash equivalent, better validation, etc.) are welcome.

## How to add a new variant

1. Create `templates/<variant-name>/`.
2. Add a `CLAUDE.md.extension` file with the variant-specific sections. Don't duplicate `_common`'s content — the scaffold script appends this onto the base.
3. Add any variant-specific docs (e.g. `docs/<RUNTIME_CONTRACT>.md` if the variant has runtime discipline beyond what's in `_common`).
4. Update the variant table in `README.md`.
5. Update the `-Type` parameter validation in `scripts/new-project.ps1`.
6. Open a PR with: variant name, what it's for, what skills it adds, how it differs from `_common`.

## How to refine `_common/CLAUDE.md`

The base CLAUDE.md is the most-used file in the template. Changes there ripple to every variant.

- Be **terse**. CLAUDE.md is loaded into every conversation; bytes there are bytes everywhere.
- Be **descriptive** ("describe what is"), not aspirational ("we should…").
- **Cite the lesson**. PR descriptions should say what happened that motivated the change.
- **Don't add layers**. The four-layer memory hierarchy (auto-memory → proposals → plans → git) is the right shape. Resist the urge to add a fifth.

## Voice for the templates themselves

All files in this repo follow the same voice rule as the projects they scaffold:

- Describe what *is*, not what it *isn't*.
- No marketing language.
- No self-congratulation.
- No defensive contrasts.
- Plain, direct.

## Versioning

No SemVer needed. Date-stamp commits and don't break existing usage. New variants are additive; refinements to `_common` are forward-compatible (existing projects can re-pull and merge).

## Code of conduct

Be kind. Disagreements about discipline are productive; gatekeeping isn't. If your variant or refinement is right for your projects, that's enough — even if it doesn't fit mine.
