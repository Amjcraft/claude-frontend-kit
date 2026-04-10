---
description: React component patterns — compound components, cva variants for style/size, forwardRef for native element wrappers, hook extraction rules, cn() for class merging, prop drilling limits (max 2 levels)
---

# Component Patterns

Guidance for building React components in this project.

## Compound Components

Prefer compound components over deeply nested props for complex UI. Use a static property pattern:

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

Card.Footer = function CardFooter({ children }: { children: React.ReactNode }) {
  return <div className="flex items-center p-6 pt-0">{children}</div>
}
```

## Variants with cva

Use `class-variance-authority` for all component variants. Never use boolean props for style variations:

```tsx
// ✅ Do this
const buttonVariants = cva(
  "inline-flex items-center justify-center rounded-md text-sm font-medium transition-colors focus-visible:outline-none focus-visible:ring-2 disabled:pointer-events-none disabled:opacity-50",
  {
    variants: {
      variant: {
        default: "bg-primary text-primary-foreground hover:bg-primary/90",
        destructive: "bg-destructive text-destructive-foreground hover:bg-destructive/90",
        outline: "border border-input bg-background hover:bg-accent",
        ghost: "hover:bg-accent hover:text-accent-foreground",
        link: "text-primary underline-offset-4 hover:underline",
      },
      size: {
        sm: "h-9 px-3",
        md: "h-10 px-4 py-2",
        lg: "h-11 px-8",
        icon: "h-10 w-10",
      },
    },
    defaultVariants: {
      variant: "default",
      size: "md",
    },
  }
)

// ❌ Not this
type ButtonProps = { isPrimary?: boolean; isDestructive?: boolean; isSmall?: boolean }
```

## forwardRef

Always use `forwardRef` for components that wrap native elements, so they can accept refs from parent components:

```tsx
const Input = React.forwardRef<HTMLInputElement, React.ComponentProps<"input">>(
  ({ className, ...props }, ref) => {
    return (
      <input
        ref={ref}
        className={cn("flex h-10 w-full rounded-md border...", className)}
        {...props}
      />
    )
  }
)
Input.displayName = "Input"
```

## Hook Extraction

Extract to a custom hook when any of these apply:
- State logic exceeds ~20 lines in the component
- The same logic is needed in 2+ places
- Side effects are involved (data fetching, subscriptions, timers)

```tsx
// ✅ Extract complex state logic
function useDisclosure(defaultOpen = false) {
  const [isOpen, setIsOpen] = useState(defaultOpen)
  const open = useCallback(() => setIsOpen(true), [])
  const close = useCallback(() => setIsOpen(false), [])
  const toggle = useCallback(() => setIsOpen((v) => !v), [])
  return { isOpen, open, close, toggle }
}
```

## Prop Drilling

No prop drilling past 2 levels. Options:
1. **Composition** — pass components as children or slots
2. **Context** — for genuinely shared state within a subtree
3. **Lift state** — if siblings need the same data

## Size Limit

Components should not exceed 200 lines. When approaching that:
1. Extract sections into sub-components
2. Extract logic into hooks
3. Split into compound components

## cn() for Classes

Always use `cn()` for conditional or merged class names:

```tsx
import { cn } from "@/lib/utils"

// ✅
<div className={cn("base-class", isActive && "active-class", className)} />

// ❌
<div className={`base-class ${isActive ? "active-class" : ""} ${className}`} />
```
