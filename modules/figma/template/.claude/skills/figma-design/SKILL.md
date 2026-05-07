---
name: figma-design
description: Figma design handoff — token mapping to Tailwind/CSS variables, component identification from Figma patterns, responsive behavior, handoff checklist
---

# Figma Design Handoff

Guidance for translating Figma designs into code for this project.

## Reading Figma Files

When given a Figma URL or frame reference:
1. Use the Figma MCP to inspect the design
2. Identify the component hierarchy before writing any code
3. Note all spacing, color, and typography tokens — map them to Tailwind/CSS variables

## Token Mapping

Always map Figma tokens to project equivalents:

| Figma | Project equivalent |
|-------|-------------------|
| Fill colors | CSS variables (`--color-primary`, etc.) or Tailwind color tokens |
| Text styles | Tailwind typography classes (`text-sm font-medium`, etc.) |
| Spacing | Tailwind spacing scale (`p-4`, `gap-2`, etc.) |
| Border radius | Tailwind radius classes (`rounded-md`, etc.) |
| Shadows | Tailwind shadow classes or CSS variable shadows |

Never hardcode hex values. If a Figma color doesn't map to an existing token, add the CSS variable first.

## Component Identification

Look for these patterns in Figma to inform code structure:
- **Variants** in Figma → `cva` variants in code
- **Auto layout** → Flexbox or Grid (match direction and gap)
- **Instances** of a component → reuse existing shadcn/ui primitives or project components
- **Component sets** → compound component pattern

## Responsive Behavior

Ask about responsive behavior if not shown in the Figma file. Default to mobile-first:
- Check if the design shows both mobile and desktop frames
- Apply base styles for mobile, `md:` and `lg:` overrides for larger breakpoints

## Handoff Checklist

Before marking a design-to-code task complete:
- [ ] All spacing matches Figma (use browser inspector to verify)
- [ ] Colors use CSS variables, not hardcoded hex
- [ ] Typography matches (size, weight, line-height)
- [ ] Interactive states implemented (hover, focus, disabled, loading)
- [ ] Responsive behavior verified at mobile and desktop
- [ ] Accessibility: labels, focus styles, keyboard nav
