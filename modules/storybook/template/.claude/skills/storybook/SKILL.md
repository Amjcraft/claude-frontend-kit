---
name: storybook
description: Storybook story authoring — CSF3 format, typed meta, argTypes for controls, story naming conventions, what to cover per component
---

# Storybook

Guidance for writing and maintaining Storybook stories in this project.

## File Location

Stories are colocated with components:
```
src/components/ui/button/
├── button.tsx
├── button.stories.tsx   ← here
├── button.test.tsx
└── index.ts
```

## Story Format

Use the Component Story Format (CSF3) with typed meta:

```tsx
import type { Meta, StoryObj } from "@storybook/react"
import { Button } from "./button"

const meta = {
  title: "UI/Button",
  component: Button,
  parameters: {
    layout: "centered",
  },
  tags: ["autodocs"],
  argTypes: {
    variant: {
      control: "select",
      options: ["default", "destructive", "outline", "ghost", "link"],
    },
    size: {
      control: "select",
      options: ["sm", "md", "lg", "icon"],
    },
  },
} satisfies Meta<typeof Button>

export default meta
type Story = StoryObj<typeof meta>

export const Default: Story = {
  args: {
    children: "Button",
    variant: "default",
    size: "md",
  },
}

export const Destructive: Story = {
  args: {
    children: "Delete",
    variant: "destructive",
  },
}

export const Disabled: Story = {
  args: {
    children: "Disabled",
    disabled: true,
  },
}
```

## Story Naming Convention

- **Title format**: `"{Category}/{ComponentName}"` — e.g., `"UI/Button"`, `"Forms/TextInput"`, `"Features/Auth/LoginForm"`
- **Story names**: PascalCase, describe the state or variant — `Default`, `WithIcon`, `LoadingState`, `ErrorState`

## What to Cover

Every component should have stories for:
- [ ] Default state
- [ ] Each major variant (from cva variants)
- [ ] Each size variation
- [ ] Interactive states: hover (handled by Storybook), focus, disabled, loading
- [ ] Edge cases: long text, empty state, max content

## Args and Controls

- Define `argTypes` for all variant/size props so Storybook generates controls
- Use realistic content in `args` — avoid "Lorem ipsum" and placeholder strings
- For async components, use `loaders` or `parameters.msw` for mock data

## Running Storybook

```bash
# Start dev server
pnpm storybook

# Build static Storybook
pnpm build-storybook
```
