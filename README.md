# AI-Skills

**[English](README.md) | [中文](README.zh-CN.md)**

A comprehensive library of modular skills for [Claude Code](https://claude.ai/code). Each skill provides specialized AI assistance for common development tasks.

## Features

AI-Skills includes 9 specialized skills covering the entire development lifecycle:

| Skill | Description | Trigger With |
|-------|-------------|--------------|
| **commit-helper** | Generate Conventional Commits messages | "create commit", "write commit message" |
| **debug-helper** | Systematic debugging framework | "debug this", "help troubleshoot" |
| **code-explainer** | Explain code with visual aids | "explain this code", "how does this work" |
| **test-generator** | Generate unit tests | "write tests", "add test coverage" |
| **api-design-helper** | Design RESTful APIs | "design an API", "create API endpoints" |
| **documentation-helper** | Write technical documentation | "help document this", "write docs" |
| **logging-helper** | Add structured logging | "add logging", "implement logging" |
| **performance-optimizer** | Optimize code performance | "optimize this", "improve performance" |
| **pr-review-helper** | Conduct PR code reviews | "review this PR", "code review" |

## Quick Start

### Installation

Clone this repository:

```bash
git clone https://github.com/Youpen-y/AI-Skills.git
cd AI-Skills
```

Copy skills to your project:

```bash
# Copy all skills to your project
cp -r skills/* /path/to/your-project/.claude/skills/

# Or copy specific skill
cp -r skills/commit-helper /path/to/your-project/.claude/skills/
```

Copy skills globally (for all projects):

```bash
# Linux/macOS
mkdir -p ~/.claude/skills
cp -r skills/* ~/.claude/skills/

# Windows
mkdir %USERPROFILE%\.claude\skills
xcopy /E /I skills\* %USERPROFILE%\.claude\skills\
```

### Using Skills

Skills are automatically discovered by Claude Code through the `SKILL.md` frontmatter. Simply use natural language or slash commands:

```bash
# Example: Create a commit
claude "commit these changes"

# Example: Debug an issue
claude "debug this error"

# Example: Write tests
claude "write tests for auth.js"
```

## Project Structure

```
AI-Skills/
├── skills/                         # Skill definitions
│   ├── commit-helper/             # Conventional Commits
│   ├── debug-helper/              # Debugging framework
│   ├── code-explainer/            # Code explanation
│   ├── test-generator/            # Test generation
│   ├── api-design-helper/         # API design
│   ├── documentation-helper/      # Documentation
│   ├── logging-helper/            # Logging
│   ├── performance-optimizer/     # Performance
│   └── pr-review-helper/          # PR reviews
└── .github/workflows/
    ├── ai-pr-review.yml           # AI PR Review
    └── ai-pr-chat.yml             # AI PR Chat Bot
```

## GitHub Actions Integration

The project includes two AI-powered workflows using Zhipu's GLM-4.7 model:

### AI PR Review

Automated code reviews that trigger on PR creation/update:

- Fetches PR diff via GitHub API
- Sends to GLM-4.7 for analysis
- Posts review with structured feedback
- Updates existing bot comments to avoid duplicates

**Setup:** Add `ZHIPU_API_KEY` to your repository secrets.

### AI PR Chat Bot

Interactive AI assistant for PR comments:

- Triggered by `/ai` or `@ai` mentions
- Detects "review mode" vs "question mode"
- Provides concise, focused responses
- Supports follow-up questions

## Skill Architecture

Each skill follows a standardized structure:

```
skill-name/
├── SKILL.md           # Core skill definition (required)
├── README.md          # User documentation (required)
├── examples.md        # Real-world examples (optional)
├── reference.md       # Detailed specifications (optional)
└── scripts/           # Executable implementations (optional)
```

### SKILL.md Format

```yaml
---
name: skill-name
description: When to use this skill. Includes trigger patterns.
---

# Skill Name

Usage instructions and guidelines...
```

## Contributing

Contributions are welcome! To add a new skill:

1. Create a directory under `/skills/<skill-name>/`
2. Add `SKILL.md` with YAML frontmatter
3. Create a comprehensive `README.md`
4. Optionally add `examples.md` and `reference.md`
5. Follow the existing skill structure

### Commit Standards

This project follows [Conventional Commits 1.0.0](https://www.conventionalcommits.org/):

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

Types: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`, `revert`

## License

MIT

## Acknowledgments

Built for [Claude Code](https://claude.ai/code) by Anthropic.

AI workflows powered by [Zhipu AI](https://open.bigmodel.cn/) GLM-4.7 model.
