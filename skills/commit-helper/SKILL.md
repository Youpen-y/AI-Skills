---
name: commit-helper
description: Generate well-structured Conventional Commits messages for Git. Use when user wants to commit changes, create commit messages, or improve existing commit messages.
---

# Commit Helper

Generate well-structured [Conventional Commits](https://www.conventionalcommits.org/) messages for Git.

## When to Use

- User wants to create a git commit
- User asks how to write a commit message
- User wants to improve an existing commit message
- User types `/commit` or similar shortcut

## Commit Message Format

Follow Conventional Commits 1.0.0 specification:

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

### Type (required)

| Type | Purpose | Example |
|------|---------|---------|
| `feat` | New feature | feat: add user authentication |
| `fix` | Bug fix | fix: resolve login timeout issue |
| `docs` | Documentation | docs: update README steps |
| `style` | Formatting (no functional change) | style: format with prettier |
| `refactor` | Code refactor | refactor: simplify auth flow |
| `perf` | Performance | perf: cache database queries |
| `test` | Tests | test: add unit tests for user module |
| `build` | Build system/dependencies | build: upgrade webpack to v5 |
| `ci` | CI configuration | ci: add github actions workflow |
| `chore` | Other changes | chore: update .gitignore |
| `revert` | Revert commit | revert: feat(user): remove password field |

### Scope (optional)

Module affected by the change, in parentheses:
- `feat(auth): add OAuth2 support`
- `fix(api): handle null response`
- `docs(readme): add setup instructions`

### Description (required)

- Use present tense, imperative mood ("add" not "added" or "adds")
- Don't capitalize first letter
- Don't end with period
- Keep concise (< 72 characters)

### Body (optional)

Detailed explanation of changes:
- **what**: What was changed
- **why**: Why the change was made
- **how**: How it was implemented

### Footer (optional)

- Reference issues: `Closes #123`
- Breaking changes: `BREAKING CHANGE: API endpoint changed`

## Workflow

1. **Analyze changes**: Run `git diff` to see what changed
2. **Choose type**: Select appropriate type based on change nature
3. **Add scope**: Include scope if change affects specific module
4. **Write description**: Concise summary of changes
5. **Add body**: Include details for complex changes
6. **Generate commit**: Use generated message with `git commit`

## Examples

See `examples.md` for real-world examples.

---

**Need more?** See `reference.md` for full specification.
