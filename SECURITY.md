# Security Policy

## Scope

This repo is a project scaffolder + docs site + skill installer scripts. "Security" here means:

- **Scaffolder scripts** that could be tricked into writing or executing dangerous content
- **Install scripts** that pull from third-party sources (npm, git clone) and could install malicious versions
- **Template files** that, when scaffolded, ship insecure defaults to a user's new project
- **Docs site** that could host malicious links or be vulnerable to XSS (unlikely — it's static)

## Supported versions

| Version | Supported |
|---|---|
| Latest tagged release | Yes |
| `main` branch HEAD | Best-effort |
| Anything older than the previous minor release | No — please upgrade |

## Reporting a vulnerability

**Please do not open public GitHub issues for security problems.**

Report privately by either:

1. **GitHub Security Advisories** — preferred. Go to the repo's **Security** tab → **Report a vulnerability**. Liz will see it; the report stays private until a fix is published.
2. **Email** — to Liz at the address in the maintainer block of the README. Subject line `[security] <short description>`.

## What to include

- Which file(s) and which version(s) are affected
- The exact unsafe behavior
- A concrete scenario where this becomes a real harm
- Suggested fix if you have one

## Response timeline

- **Within 72 hours:** acknowledgement that the report was received
- **Within 14 days:** triage decision (confirmed / not-a-vulnerability / needs-more-info), with reasoning
- **Within 30 days:** fix released for confirmed vulnerabilities, OR a public statement explaining why a fix isn't possible

## Disclosure

By default, vulnerabilities are disclosed publicly when a fix ships, with credit to the reporter (unless the reporter asks to stay anonymous). The disclosure happens in the [CHANGELOG](CHANGELOG.md) under a "Security" subsection of the release.

## Out of scope

- Issues in Claude Code itself — report to Anthropic at [anthropic.com/security](https://www.anthropic.com/security)
- Issues in other Agent Skills clients (Cursor, Gemini CLI, etc.) — report to that client's maintainer
- Issues in the upstream skills this project references (the actual skill implementations live in their own repos — see [docs/AGENTS.md](docs/AGENTS.md) for source URLs)
- Issues in transitive dependencies pulled in by the install-skills scripts — report upstream and let us know

## Maintainer

[Liz Osborn](https://github.com/Lizo-RoadTown)
