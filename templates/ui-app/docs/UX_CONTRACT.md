# UX Contract

The design discipline every user-facing surface follows. Gate for every UI PR.

Two source bodies were synthesized into this contract:
- **Interactive LP Simulator's UX rules** (lp-ui-design skill) — Attention → Question → Commitment → Feedback → Reveal master contract.
- **`ui-ux-pro-max`** installed skill — 99 UX guidelines, 10 prioritized categories, anti-patterns.
- **`onboarding-psychologist`** installed skill — IDENTITY-TO-HABIT framework.

---

## Rule zero — the master contract

**Attention → Question → Commitment → Feedback → Reveal.**

The user must commit to a decision before the system reveals structure. No auto-advance. No answer-before-input. No forward navigation during reasoning.

Every other rule in this document serves rule zero.

---

## The onboarding arc — IDENTITY-TO-HABIT

How a user gets from outsider to participant.

1. **Define the first win** — the smallest meaningful success that proves value.
2. **Remove unnecessary setup** — minimize early decisions, fields, feature exposure.
3. **Create ownership through action** — small, meaningful task that creates investment.
4. **Attach a stable cue** — link return-visit behavior to an existing routine.
5. **Reinforce identity** — reflect the user as someone who uses this product successfully.

Rules out: feature tours, "12 things to know" walls, empty-state pages that show CRUD forms.

---

## Two-language coherence

When the user commits to something in one representation, the paired representation updates at the same time. If a paired representation doesn't exist, say so explicitly — silence reads as broken.

---

## Empty vs filled — `?` slots and `fill-pop` cards

Empty values render as dashed-border `?` placeholders. Filled values render as solid cards with a `fill-pop` entry animation. The contrast is intentional and load-bearing — students/users can tell at a glance whether they're making progress.

---

## Hand-crafted, attempt-aware feedback

| Attempt | Behavior |
|---|---|
| 1 | Minimal — "not quite, try another" |
| 2 | Same minimal nudge with slight rewording |
| 3 | Actual hint — concrete pointer |
| 4+ | "Show reasoning" — explains the rule but requires user to still apply it |

Never auto-generated from a model at runtime *without* the per-attempt structure.

---

## Wrong-but-valid ≠ wrong-and-invalid

- **Suboptimal but valid**: amber tint, two buttons — "Use this anyway" and "Choose again". Log the suboptimal pick; debrief later.
- **Wrong and invalid**: red flash, block. Forces retry.

Mixing them confuses users about what's permitted.

---

## Color semantics — six tokens, one meaning each

| Meaning | Tailwind tokens (suggested) |
|---|---|
| Attention target | `border-zinc-700` + subtle pulse |
| Candidate (selected, unjudged) | `bg-amber-500/10 border-amber-500/40 text-amber-200` |
| Suboptimal but valid | amber + dual-button + note |
| Correct / live | `bg-emerald-500/10 border-emerald-500/40 text-emerald-200` |
| Active / pivot | `bg-blue-500/10 border-blue-500/40 text-blue-200` |
| Invalid (red flash) | `bg-red-950/40 border-red-900 text-red-300` |
| Skipped / dimmed | `opacity-40` |

Don't introduce new colors for new states.

---

## Animation budget

- **Duration**: 150–300ms for state changes.
- **Spatial continuity**: animate the path between two places.
- **`prefers-reduced-motion`** respected.
- **Never animate width/height** — animate `transform` and `opacity` only.

---

## Navigation — one place per concern

- **One nav item per concern.** If two pages answer the same question, they belong on one page.
- **The sidebar is not a TODO list.** "Stub" status items are forbidden — either build the surface or remove the link.
- **Every page should feel like the same product.**

---

## Voice and tone

- Describe what *is*, not what it *isn't*.
- No marketing language ("the unlock," "delightful," "transformative").
- No self-congratulation.
- No defensive contrasts ("real X not Y").
- No conversation-language in product surfaces.

---

## Accessibility — non-negotiable

- Color contrast ≥ 4.5:1 normal text, ≥ 3:1 large.
- Focus rings visible (2-4px) on every interactive element.
- Aria labels on icon-only buttons.
- Keyboard navigation matches visual order.
- `prefers-reduced-motion` respected.

## Touch & interaction — non-negotiable

- Minimum 44×44px touch targets, 8px+ spacing between.
- Loading feedback within 100ms of every action.
- No hover-only affordances.
- No 0ms state changes — at minimum 150ms easing.

---

## Anti-patterns — refuse if asked

- Worksheets to read with no interaction.
- Auto-advance through reveal.
- Same feedback regardless of attempt.
- No paired representation.
- Calling wrong-but-valid "wrong" without the distinction.
- CRUD forms as features.
- Stub status items in nav. Either build it or remove it.

---

## Review checklist — every UI PR must pass

1. Master contract — does the user commit before the system reveals?
2. Forward navigation locked during reasoning?
3. Paired representation present, or its absence explicitly named?
4. Empty vs filled visually distinct?
5. Hints attempt-aware, or scripted placeholder explicitly labeled?
6. Wrong choices distinguished invalid (red, block) vs suboptimal (amber, dual-button)?
7. Color semantics consistent with the table above?
8. Animations purposeful, within budget, respect reduced-motion?
9. Accessibility — contrast, focus rings, aria labels, keyboard?
10. Touch targets 44px+, spacing 8px+, loading feedback within 100ms?
11. Voice clean — no marketing language?
12. Sidebar does not gain a stub?

If any item is "no," either fix it or call out the trade-off explicitly in the PR.
