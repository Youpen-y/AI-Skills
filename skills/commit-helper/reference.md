# Commit Helper - Reference

Detailed reference for Conventional Commits specification and best practices.

## Conventional Commits Specification

Based on [Conventional Commits 1.0.0](https://www.conventionalcommits.org/).

### Structure

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

### Grammar (ABNF)

```abnf
<type> := "feat" | "fix" | "docs" | "style" | "refactor" | "perf" | "test" | "build" | "ci" | "chore" | "revert"
<scope> := [a-zA-Z0-9_-]+
<description> := [^\n]+
<body> := [^\n]+([^\n]+\n)*
<footer> := [^\n]+([^\n]+\n)*
```

## Type Definitions

| Type | Icon | Definition | Semantic Versioning |
|------|------|------------|---------------------|
| `feat` | ✨ | New feature | MINOR |
| `fix` | 🐛 | Bug fix | PATCH |
| `docs` | 📝 | Documentation only | NONE |
| `style` | 💄 | Code style (formatting, etc.) | NONE |
| `refactor` | ♻️ | Code refactor | NONE |
| `perf` | ⚡ | Performance improvement | PATCH |
| `test` | ✅ | Adding/updating tests | NONE |
| `build` | 📦 | Build system/dependencies | NONE |
| `ci` | 👷 | CI/CD configuration | NONE |
| `chore` | 🔧 | Other changes | NONE |
| `revert` | ↩️ | Revert previous commit | NONE |

## Scope Guidelines

Scopes should be:
- **Short**: Use 2-10 characters
- **Meaningful**: Reflect module or component name
- **Consistent**: Use same scope for related changes

### Common Scopes

```
auth, api, ui, db, config, logger, util, helper
models, views, controllers, services, routes
```

### Monorepo Scopes

```
package:module
feat(@packages/core): add export function
fix(@packages/ui): fix button alignment
```

## Description Guidelines

- Use **imperative mood**: "add" not "added" or "adds"
- Use **present tense**: "fix" not "fixed" or "fixes"
- Use **lowercase**: First letter should be lowercase
- **No period** at the end
- **Under 72 characters** for the first line
- Focus on **what** and **why**, not **how**

## Body Guidelines

- Wrap at **72 characters**
- Use **multiple paragraphs** for complex changes
- Explain **what** was changed and **why**
- Include **migration notes** for breaking changes

## Footer Guidelines

### Breaking Changes

Must start with `BREAKING CHANGE:` followed by description:

```
feat: remove deprecated API

BREAKING CHANGE: The old API endpoint has been removed.
Use /api/v2/ instead. See migration guide.
```

### Issue References

Common formats:
- `Closes #123`
- `Fixes #456`
- `Resolves #789`
- `Refs #321`

Multiple issues:
- `Closes #123, #456, #789`

### Co-authorship

For multiple contributors:
```
feat: add OAuth support

Co-Authored-By: Jane Doe <jane@example.com>
Co-Authored-By: John Smith <john@example.com>
```

## Semantic Versioning

Conventional Commits map to SemVer:

| Commit Type | Release |
|-------------|---------|
| `feat` | MINOR (1.x.0 → 1.x+1.0) |
| `fix` | PATCH (1.0.x → 1.0.x+1) |
| `BREAKING CHANGE` | MAJOR (x.0.0 → x+1.0.0) |
| Others | NONE |

## Tools Integration

### Commitlint

Validate commits with `@commitlint/config-conventional`:

```bash
npm install -D @commitlint/cli @commitlint/config-conventional
```

Configuration (`commitlint.config.js`):
```js
module.exports = {
  extends: ['@commitlint/config-conventional'],
  rules: {
    'type-enum': [2, 'always', [
      'feat', 'fix', 'docs', 'style', 'refactor',
      'perf', 'test', 'build', 'ci', 'chore', 'revert'
    ]],
    'scope-case': [2, 'always', 'kebab-case'],
    'subject-case': [2, 'always', 'lower-case'],
    'subject-max-length': [2, 'always', 72],
    'body-max-line-length': [2, 'always', 72],
  }
};
```

### Commitizen

Interactive commit helper:

```bash
npm install -D commitizen cz-conventional-changelog
```

```json
{
  "scripts": {
    "commit": "git-cz"
  },
  "config": {
    "commitizen": {
      "path": "cz-conventional-changelog"
    }
  }
}
```

### Semantic Release

Automated versioning and publishing:

```bash
npm install -D semantic-release
```

## Best Practices

### DO ✓
- Be specific and concise
- Use consistent types
- Reference related issues
- Document breaking changes
- Write in English (for open source)
- Keep subject line under 72 chars

### DON'T ✗
- Use vague descriptions like "update" or "fix"
- Mix multiple changes in one commit
- Write commit messages in past tense
- Include sensitive information
- Use ALL CAPS
- Put period at end of subject

## Git Hooks

### Husky + Commitlint

```bash
npm install -D husky @commitlint/cli
npx husky install
npx husky add .husky/commit-msg 'npx --no -- commitlint --edit $1'
```

### Pre-commit Hook

```bash
#!/bin/sh
. "$(dirname "$0")/_/husky.sh"

npx commitlint --edit $1
```

## Resources

- [Conventional Commits](https://www.conventionalcommits.org/)
- [Angular Commit Convention](https://github.com/angular/angular/blob/master/CONTRIBUTING.md#commit)
- [Commitlint](https://commitlint.js.org/)
- [Semantic Release](https://semantic-release.gitbook.io/)
- [How to Write a Git Commit Message](https://chris.beams.io/posts/git-commit/)
