# PR Review Helper Skill

> Conduct thorough, constructive Pull Request code reviews that improve code quality and help developers grow.

## Overview

This skill provides a structured framework for reviewing Pull Requests. It helps deliver feedback that is:
- **Comprehensive** - Covers security, correctness, performance, and maintainability
- **Constructive** - Actionable suggestions with explanations
- **Kind** - Respectful feedback that helps developers grow
- **Efficient** - Focused on what matters most

## Quick Start

Simply ask for a code review:

```
Review this PR
```

```
What do you think of these changes?
```

```
Can you review the code in src/auth.ts?
```

## Review Framework

| Dimension | Focus | Priority |
|-----------|-------|----------|
| **Correctness** | Bugs, logic errors, edge cases | High |
| **Security** | Injection, XSS, authentication | Critical |
| **Performance** | Algorithms, resource usage | Medium |
| **Readability** | Naming, structure, comments | Low |
| **Maintainability** | DRY, modularity, testing | Medium |
| **Consistency** | Style, patterns, conventions | Low |
| **Testing** | Coverage, test quality | Medium |

## Review Output Format

```markdown
## Summary
[Brief overview]

## :white_check_mark: Strengths
- Positive aspects

## :bug: Issues
**Critical / High / Medium / Low** priority items

## :thinking: Questions
- Clarifying questions

## Overall Assessment
LGTM / Approve with changes / Request changes
```

## Structure

```
pr-review-helper/
├── SKILL.md           # Main skill file
├── examples.md        # Real-world review examples
├── reference.md       # Detailed reference
└── README.md          # This file
```

## License

MIT
