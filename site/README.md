# Demo site

Single-page static site for project-starter. Visual language inherits from
[`docs/assets/thumbnail-illustrative.svg`](../docs/assets/thumbnail-illustrative.svg) —
deep navy background, amber seed, cyan / violet branch accents, organic forms.

## Preview locally

No build step. Three options:

```bash
# 1. Just open the file:
#    Double-click site/index.html, or:
open site/index.html        # macOS
start site/index.html       # Windows
xdg-open site/index.html    # Linux

# 2. Serve it (better — relative links work cleanly):
python3 -m http.server --directory site 8000
# then visit http://localhost:8000

# 3. With any other static server you already use:
npx serve site
```

## Deploy to Render

The repo ships a [`render.yaml`](../render.yaml) Blueprint. To deploy:

1. Push this repo to GitHub (if you haven't already).
2. In the Render dashboard: **New +** → **Blueprint** → connect this repo.
3. Render reads `render.yaml`, creates the static site, builds, and deploys.
4. Every push to `main` auto-deploys. PRs get preview URLs.

Static sites on Render are free and CDN-served globally.

### Manual setup (no Blueprint)

If you'd rather configure by hand:

| Field | Value |
|---|---|
| Type | Static Site |
| Build Command | *(leave empty)* |
| Publish Directory | `site` |

That's the entire config.

## Files

| File | Role |
|---|---|
| [index.html](index.html) | Single-page site. Inline CSS + inline simplified hero illustration. |
| [assets/thumbnail.svg](assets/thumbnail.svg) | Full illustrative thumbnail (also used as `og:image`). |
| [assets/favicon.svg](assets/favicon.svg) | 64×64 mark — seed + trunk + two branches. |

## Design system (inline in `index.html`)

Quick reference for anyone extending:

| Token | Value | Used for |
|---|---|---|
| `--bg-0` / `--bg-1` / `--bg-2` | `#06091a` / `#0b1220` / `#0f1a30` | Background ramp |
| `--surface` | `#0f1a30` | Card backgrounds |
| `--border` / `--border-soft` | `#334155` / `#1e293b` | Card outlines, dividers |
| `--text` / `--text-muted` / `--text-dim` / `--text-faint` | `#f1f5f9` / `#cbd5e1` / `#94a3b8` / `#64748b` | Text hierarchy |
| `--cyan` | `#7dd3fc` | `ui-app` accent |
| `--violet` | `#a78bfa` | `agent-app` accent |
| `--amber` / `--amber-deep` | `#fbbf24` / `#f59e0b` | Seed glow, highlights |
| `--mono` | `ui-monospace, Menlo, …` | Headings + code |
| `--sans` | `system-ui, …` | Body |

Motion respects `prefers-reduced-motion`. Hover transitions are 180-200ms.
Focus rings are visible (`outline: 2px solid var(--cyan)`).
