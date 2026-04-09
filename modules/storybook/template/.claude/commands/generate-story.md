Generate a Storybook story file for the component at $ARGUMENTS.

Before writing:
1. Read the component file to understand its props, variants, and behavior
2. Check if a story file already exists

Generate: `{component-path}/{component-name}.stories.tsx`

Requirements:
- CSF3 format with typed `Meta` and `StoryObj`
- `title` follows `"{Category}/{ComponentName}"` convention
- `tags: ["autodocs"]` for auto-generated docs page
- `argTypes` defined for all variant and size props (use `control: "select"`)
- Stories for: Default, each major variant, disabled state, any loading/error states
- Realistic content in args — no "Lorem ipsum"

After generating:
- List all stories created and what state each represents
- Note any props that couldn't be covered without additional setup (async data, context providers, etc.)
