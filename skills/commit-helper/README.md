# Commit Helper Skill

> Generate well-structured [Conventional Commits](https://www.conventionalcommits.org/) messages for Git.

## Overview

This skill helps you write consistent, semantic commit messages following the Conventional Commits specification. Well-structured commit messages improve:
- **Code review efficiency** - Clear context for reviewers
- **Changelog generation** - Automated release notes
- **Semantic versioning** - Automatic version bumps
- **Git history** - Searchable and meaningful log

## Quick Start

### As a Claude Code Skill

When using Claude Code, simply ask for help with commits:

```
I want to commit these changes
```

```
Help me write a commit message for adding user authentication
```

```
Create a commit message for the bug fix in the login module
```

Claude will use this skill to generate properly formatted commits.

### Using the Script

Run the interactive commit helper:

```bash
./skills/commit-helper/scripts/commit.sh
```

### Manual Reference

See the files in this directory:
- **SKILL.md** - Main skill documentation
- **examples.md** - Real-world commit examples
- **reference.md** - Full specification and best practices

## Structure

```
commit-helper/
├── SKILL.md           # Main skill file (required)
├── examples.md        # Usage examples
├── reference.md       # Detailed reference
├── README.md          # This file
└── scripts/
    └── commit.sh      # Interactive helper script
```

## Commit Format

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

### Example

```
feat(auth): add OAuth2 login flow

Implement OAuth2 authentication with Google and GitHub
providers. Includes token refresh logic and error handling.

Closes #42
```

## Integration

### With Commitlint

Add to `commitlint.config.js`:

```js
module.exports = {
  extends: ['@commitlint/config-conventional'],
  rules: {
    'type-enum': [2, 'always', [
      'feat', 'fix', 'docs', 'style', 'refactor',
      'perf', 'test', 'build', 'ci', 'chore', 'revert'
    ]]
  }
};
```

### With Husky

```bash
npx husky add .husky/commit-msg 'npx commitlint --edit $1'
```

## License

MIT
