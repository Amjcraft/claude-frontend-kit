---
name: component-patterns
description: React component patterns — compound components, cva variants for style/size, forwardRef for native element wrappers, hook extraction rules, cn() for class merging, prop drilling limits (max 2 levels)
---

# Component Patterns

## Compound Components

Use the static property pattern for complex UI that would otherwise require deeply nested props:

```tsx
function Card({ children }: { children: React.ReactNode }) {
  return <div className="rounded-lg border bg-card">{children}</div>
}

Card.Header = function CardHeader({ children }: { children: React.ReactNode }) {
  return <div className="flex items-center p-6 pb-0">{children}</div>
}

Card.Body = function CardBody({ children }: { children: React.ReactNode }) {
  return <div className="p-6">{children}</div>
}
```

## Variants with cva

Use `class-variance-authority` for all component variants. **Never use boolean props for style variations** (`isPrimary`, `isSmall`, etc.):

```tsx
const buttonVariants = cva("inline-flex items-center ...", {
  variants: {
    variant: {
      default: "bg-primary text-primary-foreground",
      destructive: "bg-destructive text-destructive-foreground",
      outline: "border border-input bg-background",
      ghost: "hover:bg-accent",
      link: "text-primary underline-offset-4 hover:underline",
    },
    size: { sm: "h-9 px-3", md: "h-10 px-4 py-2", lg: "h-11 px-8", icon: "h-10 w-10" },
  },
  defaultVariants: { variant: "default", size: "md" },
})
```

## forwardRef

Always use `forwardRef` for components that wrap native elements. Always set `displayName`:

```tsx
const Input = React.forwardRef<HTMLInputElement, React.ComponentProps<"input">>(
  ({ className, ...props }, ref) => (
    <input ref={ref} className={cn("flex h-10 w-full rounded-md border...", className)} {...props} />
  )
)
Input.displayName = "Input"
```

## Hook Extraction

Extract to a custom hook when any of these apply:
- State logic exceeds ~20 lines in the component
- The same logic is needed in 2+ places
- Side effects are involved (data fetching, subscriptions, timers)

## Prop Drilling

No prop drilling past 2 levels. Use composition (children/slots), context, or lift state.

## Size Limit

Components must not exceed 200 lines. When approaching that: extract sub-components, extract hooks, or split into compound components.

## cn() for Classes

Always use `cn()` for conditional or merged class names:

```tsx
import { cn } from "@/lib/utils"

// ✅
<div className={cn("base-class", isActive && "active-class", className)} />

// ❌
<div className={`base-class ${isActive ? "active-class" : ""} ${className}`} />
```
