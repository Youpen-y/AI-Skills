# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

AI-Skills is a library of modular skills for Claude Code. Each skill provides specialized AI assistance for common development tasks like generating conventional commits, debugging, writing tests, explaining code, designing APIs, writing documentation, adding logging, optimizing performance, and reviewing pull requests. The project also includes GitHub Actions workflows that use these skills for AI-powered PR review and chat.

## Project Structure

```
AI-Skills/
├── skills/                         # Skill definitions
│   ├── commit-helper/             # Conventional Commits generation
│   ├── debug-helper/              # Systematic debugging framework
│   ├── code-explainer/            # Code explanation with visual aids
│   ├── test-generator/            # Unit test generation
│   ├── api-design-helper/         # RESTful API design best practices
│   ├── documentation-helper/      # Technical documentation writing
│   ├── logging-helper/            # Structured logging implementation
│   ├── performance-optimizer/     # Code performance optimization
│   └── pr-review-helper/          # Pull request code reviews
└── .github/workflows/
    ├── ai-pr-review.yml           # Automated PR reviews using GLM-4.7
    └── ai-pr-chat.yml             # AI chat bot for PR comments
```

## Skill Architecture

Each skill follows a standardized structure:

- **SKILL.md** - Core skill definition with YAML frontmatter (name, description) and usage guidelines
- **README.md** - User-facing documentation with examples and integration guides
- **examples.md** (optional) - Real-world usage examples
- **reference.md** (optional) - Detailed specifications and best practices
- **scripts/** (optional) - Executable implementations (e.g., bash scripts)

The YAML frontmatter in SKILL.md is critical for skill discovery:
```yaml
---
name: skill-name
description: When to use this skill. Includes trigger patterns.
---
```

## GitHub Actions Workflows

The project implements two AI-powered workflows using Zhipu's GLM-4.7 model:

### AI PR Review (`.github/workflows/ai-pr-review.yml`)
- Triggers on PR open/update to main
- Fetches PR diff via GitHub API
- Sends to GLM-4.7 with structured prompt for **bold heading** format
- Updates existing bot comment to avoid duplicates

### AI PR Chat Bot (`.github/workflows/ai-pr-chat.yml`)
- Triggers on new PR comments
- Responds only to `/ai` or `@ai` triggers
- Detects "review mode" vs "question mode" from keywords
- Posts concise replies (~10 lines max)

**Required secret**: `ZHIPU_API_KEY` must be configured in repository secrets.

## Adding New Skills

1. Create directory under `/skills/<skill-name>/`
2. Add `SKILL.md` with YAML frontmatter and usage instructions
3. Create comprehensive `README.md`
4. Add optional examples/reference docs as needed
5. Implement executable scripts if applicable

The skill system auto-discovers skills based on the SKILL.md frontmatter. Skills are invoked via natural language patterns or slash commands:

| Skill | Slash Command | Trigger Phrases |
|-------|---------------|-----------------|
| commit-helper | `/commit` | "create commit", "write commit message", "commit these changes" |
| debug-helper | `/debug` | "debug this", "why isn't this working", "help troubleshoot" |
| code-explainer | `/explain` | "how does this work", "what does this code do", "explain this" |
| test-generator | `/test` | "write tests", "add test coverage", "generate tests" |
| api-design-helper | `/api` | "design an API", "create API endpoints", "REST API design" |
| documentation-helper | `/docs` | "help document this", "write documentation", "improve docs" |
| logging-helper | `/log` | "add logging", "implement logging", "log this code" |
| performance-optimizer | `/perf`, `/optimize` | "optimize this", "improve performance", "profile code" |
| pr-review-helper | `/review` | "review this PR", "code review", "review these changes" |

## Commit Standards

This project follows Conventional Commits 1.0.0 strictly:
```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

Types: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`, `revert`

The commit-helper skill includes an interactive bash script at `skills/commit-helper/scripts/commit.sh` for manual use.

## Development Notes

- No build process or dependencies - this is a pure skill/documentation library
- GitHub Actions use Python inline scripts for AI API calls
- The AI workflows format responses specifically with **bold headings** (not # markdown) to match GitHub's rendering
- Bot comments are identified by `github-actions[bot]` username and specific prefixes
