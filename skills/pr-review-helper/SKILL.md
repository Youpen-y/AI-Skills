---
name: pr-review-helper
description: Conduct thorough Pull Request code reviews. Use when user asks to review a PR, requests code review feedback, or wants to improve PR quality.
---

# PR Review Helper

Conduct thorough, constructive Pull Request code reviews that improve code quality and help developers grow.

## When to Use

- User asks to "review this PR" or "review these changes"
- User requests feedback on code changes
- User types `/review` or similar
- User asks "what do you think of this code?"
- User shares a diff or link to a pull request

## Review Framework

### 1. Understand Context

Before reviewing, gather context:
- **Purpose**: What problem does this PR solve?
- **Scope**: What files/functions are affected?
- **Dependencies**: Are there related changes or issues?
- **Impact**: Will this affect existing functionality?

### 2. Review Categories

Evaluate code across these dimensions:

| Category | What to Look For | Severity |
|----------|------------------|----------|
| **Correctness** | Bugs, logic errors, edge cases | High |
| **Security** | Injection, XSS, auth issues | Critical |
| **Performance** | Algorithms, resource usage | Medium |
| **Readability** | Naming, structure, comments | Low |
| **Maintainability** | DRY, modularity, testing | Medium |
| **Consistency** | Style, patterns, conventions | Low |
| **Testing** | Coverage, test quality | Medium |

### 3. Review Structure

Follow this template for consistent reviews:

```markdown
## Summary
[Brief 1-2 sentence overview of the PR]

## Highlights
- [Positive aspect 1]
- [Positive aspect 2]

## Issues & Suggestions

### Critical (Must Fix)
- [Critical issue with file:line reference]

### Important (Should Fix)
- [Important issue with explanation]

### Nice to Have (Optional)
- [Suggestion with rationale]

## Questions
- [Clarifying question about implementation]

## Overall
[Overall assessment: LGTM / Request Changes / Comments]
```

### 4. Review Best Practices

#### DO
- Start with positive feedback
- Be specific with file:line references
- Explain the "why" behind suggestions
- Offer alternative solutions
- Ask questions instead of making demands
- Recognize the author's effort

#### DON'T
- Use harsh or sarcastic language
- Nitpick without justification
- Rewrite without explanation
- Comment on style that's already enforced by linters
- Block PRs for trivial issues

### 5. Severity Guidelines

| Severity | When to Use | Example |
|----------|-------------|---------|
| **Critical** | Security flaw, bug that breaks functionality | SQL injection, null pointer |
| **High** | Major performance issue, breaking change | O(n²) algorithm, API change |
| **Medium** | Code smell, missing error handling | Unhandled promise rejection |
| **Low** | Style, naming, minor improvements | Variable naming, comment clarity |

---

**Need more?** See `examples.md` for real-world review examples.
