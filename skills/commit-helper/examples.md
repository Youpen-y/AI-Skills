# Commit Helper - Examples

Real-world examples of well-structured commit messages.

## Simple Commits

```
feat: add user registration endpoint
```

```
fix: prevent null pointer exception in auth module
```

```
docs: update installation guide for macOS
```

## With Scope

```
feat(auth): implement OAuth2 login flow
```

```
fix(api): handle empty response from user service
```

```
style(ui): align button layout with design specs
```

## With Body

```
feat: add dark mode support

- Add theme toggle in settings
- Implement dark color palette
- Persist theme preference in localStorage
- Update all components to support theming

Closes #42
```

```
fix: resolve memory leak in data fetching

The previous implementation didn't clean up subscribers
when components unmounted, causing memory leaks in long
sessions. Now properly unsubscribing in useEffect cleanup.

Fixes #128
```

```
refactor: simplify state management

Replace Redux with React Context+useReducer for simpler
state management. Reduces bundle size by 45KB and improves
type safety.
```

## Breaking Changes

```
feat: migrate to REST API v2

BREAKING CHANGE: All API endpoints now require authentication.
Update your API calls to include bearer tokens.

See migration guide: docs/api-v2-migration.md
```

```
feat(user): rename username to email

BREAKING CHANGE: The `username` field is renamed to `email`.
All API requests using `username` must be updated.
```

## Common Patterns

### Adding a new feature
```
feat(dashboard): add analytics chart component

Display user activity metrics with interactive charts.
Uses Chart.js for rendering and supports data export.
```

### Fixing a bug
```
fix: correct timezone handling in date picker

Dates were incorrectly displayed in UTC instead of user's
local timezone. Now properly converting using Intl API.
```

### Updating documentation
```
docs: add troubleshooting section to README

Include common issues and solutions for setup problems.
```

### Performance improvement
```
perf: lazy load images in feed

Implement IntersectionObserver for lazy loading, reducing
initial page load time by 40%.
```

### Adding tests
```
test: add integration tests for checkout flow

Cover happy path and error scenarios for payment processing.
```

### Updating dependencies
```
build: upgrade React to v18.3

Includes latest bug fixes and performance improvements.
```

### CI/CD changes
```
ci: add automated deployment to staging

Configure GitHub Actions to deploy to staging environment
on merge to main branch.
```

## Anti-Patterns to Avoid

❌ Bad: `fixed the bug` (missing type, not specific)
✅ Good: `fix: handle empty input validation`

❌ Bad: `Added new feature` (wrong tense, capitalized)
✅ Good: `feat: add user profile page`

❌ Bad: `update` (too vague)
✅ Good: `chore: update dependencies`

❌ Bad: `wip` (unclear)
✅ Good: `WIP: implement OAuth flow` (use with draft PRs)

❌ Bad: `fix bug #123` (include description)
✅ Good: `fix(auth): prevent session hijacking`
