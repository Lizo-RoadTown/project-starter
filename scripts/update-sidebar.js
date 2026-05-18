// One-shot script to replace the sidebar in every docs page with the new
// flattened structure (UI App and Agent App as top-level sidebar sections,
// each piece as a direct nav link). Run once, then delete or keep for future
// sidebar updates.
//
// Usage:  node scripts/update-sidebar.js
//
// What it does:
//   - For files in site/docs/*.html and site/docs/variants/*.html,
//     locate the <aside class="sidebar" aria-label="Docs navigation">...</aside>
//     block and replace with a new block. The deep version (for
//     site/docs/variants/*) uses ../-prefixed paths.
//   - Adds a tiny inline <script> at the bottom of the sidebar that sets
//     aria-current="page" on the link matching the current URL — so the
//     active-state highlight stays automatic regardless of which page you're on.

const fs   = require('fs');
const path = require('path');

const SHALLOW_INNER = `
    <h4>Start here</h4>
    <ul>
      <li><a href="index.html">Overview</a></li>
      <li><a href="getting-started.html">Getting started</a></li>
    </ul>
    <h4>Concepts</h4>
    <ul>
      <li><a href="what-is.html#claude-code">What is Claude Code?</a></li>
      <li><a href="what-is.html#terminal">What is the terminal?</a></li>
      <li><a href="what-is.html#git">What is git &amp; GitHub?</a></li>
      <li><a href="what-is.html#scaffolding">What is scaffolding?</a></li>
      <li><a href="variants.html">Variants &amp; foundation</a></li>
    </ul>
    <h4>UI App</h4>
    <ul>
      <li><a href="variants/ui-ux-pro-max.html">99-rule design checklist</a></li>
      <li><a href="variants/design-system.html">Design-system structure</a></li>
      <li><a href="variants/ux-contract.html">Your project's UI rulebook</a></li>
      <li><a href="variants/onboarding-psychologist.html">Onboarding playbook</a></li>
      <li><a href="variants/frontend-design.html">Frontend design helper</a></li>
    </ul>
    <h4>Agent App</h4>
    <ul>
      <li><a href="variants/ai-agents-architect.html">Agent architecture guide</a></li>
      <li><a href="variants/agent-orchestrator.html">Multi-agent coordination</a></li>
      <li><a href="variants/ralph-loop.html">Iterative agent loops</a></li>
      <li><a href="variants/agent-memory-systems.html">Memory system design</a></li>
      <li><a href="variants/claude-api.html">Anthropic SDK helper</a></li>
      <li><a href="variants/portable-identity.html">Portable-identity rule</a></li>
    </ul>
    <h4>Use the project</h4>
    <ul>
      <li><a href="next-steps.html">First conversation</a></li>
      <li><a href="glossary.html">Glossary</a></li>
    </ul>
    <h4>Reference</h4>
    <ul>
      <li><a href="../">Demo site</a></li>
      <li><a href="https://github.com/Lizo-RoadTown/project-starter">GitHub repo</a></li>
    </ul>
    <script>
      (function () {
        var hereP = location.pathname.replace(/\\/$/, '/index.html');
        var hereH = location.hash || '';
        document.querySelectorAll('.sidebar a').forEach(function (a) {
          try {
            var u = new URL(a.href);
            var p = u.pathname.replace(/\\/$/, '/index.html');
            if (p === hereP && (u.hash || '') === hereH) {
              a.setAttribute('aria-current', 'page');
            }
          } catch (e) {}
        });
      })();
    </script>
  `;

// Build the deep version by rewriting relative paths.
// In site/docs/variants/*.html, we're one dir deeper. Paths that were
//   - "index.html"          become "../index.html"
//   - "what-is.html#x"      become "../what-is.html#x"
//   - "variants.html"       becomes "../variants.html"
//   - "next-steps.html"     becomes "../next-steps.html"
//   - "glossary.html"       becomes "../glossary.html"
//   - "getting-started.html" becomes "../getting-started.html"
//   - "variants/foo.html"   becomes "foo.html" (already in variants/)
//   - "../"                 becomes "../../"
function toDeep(inner) {
  return inner
    .replace(/href="(index|getting-started|what-is|variants|next-steps|glossary)\.html/g,
             'href="../$1.html')
    .replace(/href="variants\//g, 'href="')
    .replace(/href="\.\.\/"/, 'href="../../"');
}

const DEEP_INNER = toDeep(SHALLOW_INNER);

const SHALLOW_BLOCK = `<aside class="sidebar" aria-label="Docs navigation">${SHALLOW_INNER}</aside>`;
const DEEP_BLOCK    = `<aside class="sidebar" aria-label="Docs navigation">${DEEP_INNER}</aside>`;

const ASIDE_RE = /<aside class="sidebar"[\s\S]*?<\/aside>/m;

const DOCS_DIR = path.resolve(__dirname, '..', 'site', 'docs');
const SHALLOW_FILES = ['index.html', 'getting-started.html', 'what-is.html',
                       'next-steps.html', 'glossary.html', 'variants.html']
                      .map(f => path.join(DOCS_DIR, f));
const DEEP_FILES    = fs.readdirSync(path.join(DOCS_DIR, 'variants'))
                        .filter(f => f.endsWith('.html'))
                        .map(f => path.join(DOCS_DIR, 'variants', f));

let touched = 0;
let skipped = 0;

for (const file of [...SHALLOW_FILES, ...DEEP_FILES]) {
  if (!fs.existsSync(file)) { console.log(`MISS ${file}`); skipped++; continue; }
  const isDeep = file.includes(path.sep + 'variants' + path.sep);
  const block  = isDeep ? DEEP_BLOCK : SHALLOW_BLOCK;
  let content  = fs.readFileSync(file, 'utf8');
  if (!ASIDE_RE.test(content)) { console.log(`SKIP ${file} - no <aside class="sidebar"> found`); skipped++; continue; }
  content = content.replace(ASIDE_RE, block);
  fs.writeFileSync(file, content, 'utf8');
  console.log(`OK   ${path.relative(path.resolve(__dirname, '..'), file)}`);
  touched++;
}

console.log(`\nDone. Updated ${touched} file(s). Skipped ${skipped}.`);
