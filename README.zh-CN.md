# AI-Skills

**[English](README.md) | [中文](README.zh-CN.md)**

一个为 [Claude Code](https://claude.ai/code) 打造的模块化技能库。每个技能为常见开发任务提供专业的 AI 辅助。

## 特性

AI-Skills 包含 9 个专业技能，覆盖完整开发生命周期：

| 技能 | 描述 | 触发方式 |
|------|------|---------|
| **commit-helper** | 生成符合规范的提交信息 | "创建提交"、"编写提交信息" |
| **debug-helper** | 系统化调试框架 | "调试这个"、"帮助排查" |
| **code-explainer** | 可视化代码解释 | "解释这段代码"、"这是如何工作的" |
| **test-generator** | 生成单元测试 | "编写测试"、"添加测试覆盖" |
| **api-design-helper** | 设计 RESTful API | "设计 API"、"创建 API 端点" |
| **documentation-helper** | 编写技术文档 | "帮助编写文档"、"写文档" |
| **logging-helper** | 添加结构化日志 | "添加日志"、"实现日志记录" |
| **performance-optimizer** | 优化代码性能 | "优化这个"、"提升性能" |
| **pr-review-helper** | 进行 PR 代码审查 | "审查这个 PR"、"代码审查" |

## 快速开始

### 安装

克隆此仓库：

```bash
git clone https://github.com/Youpen-y/AI-Skills.git
cd AI-Skills
```

复制技能到您的项目：

```bash
# 复制所有技能到您的项目
cp -r skills/* /path/to/your-project/.claude/skills/

# 或复制特定技能
cp -r skills/commit-helper /path/to/your-project/.claude/skills/
```

全局复制技能（所有项目可用）：

```bash
# Linux/macOS
mkdir -p ~/.claude/skills
cp -r skills/* ~/.claude/skills/

# Windows
mkdir %USERPROFILE%\.claude\skills
xcopy /E /I skills\* %USERPROFILE%\.claude\skills\
```

### 使用技能

Claude Code 通过 `SKILL.md` 中的前置元数据自动发现技能。只需使用自然语言或斜杠命令：

```bash
# 示例：创建提交
claude "提交这些更改"

# 示例：调试错误
claude "调试这个错误"

# 示例：编写测试
claude "为 auth.js 编写测试"
```

## 项目结构

```
AI-Skills/
├── skills/                         # 技能定义
│   ├── commit-helper/             # 约定式提交
│   ├── debug-helper/              # 调试框架
│   ├── code-explainer/            # 代码解释
│   ├── test-generator/            # 测试生成
│   ├── api-design-helper/         # API 设计
│   ├── documentation-helper/      # 文档编写
│   ├── logging-helper/            # 日志记录
│   ├── performance-optimizer/     # 性能优化
│   └── pr-review-helper/          # PR 审查
└── .github/workflows/
    ├── ai-pr-review.yml           # AI PR 审查
    └── ai-pr-chat.yml             # AI PR 聊天机器人
```

## GitHub Actions 集成

项目包含两个基于智谱 GLM-4.7 模型的 AI 工作流：

### AI PR 审查

在 PR 创建/更新时自动进行代码审查：

- 通过 GitHub API 获取 PR 差异
- 发送到 GLM-4.7 进行分析
- 发布结构化反馈的审查意见
- 更新现有机器人评论以避免重复

**配置：** 将 `ZHIPU_API_KEY` 添加到仓库密钥中。

### AI PR 聊天机器人

用于 PR 评论的交互式 AI 助手：

- 通过 `/ai` 或 `@ai` 提及触发
- 自动检测"审查模式"和"问题模式"
- 提供简洁、专注的回复
- 支持后续追问

## 技能架构

每个技能遵循标准化结构：

```
skill-name/
├── SKILL.md           # 核心技能定义（必需）
├── README.md          # 用户文档（必需）
├── examples.md        # 实际示例（可选）
├── reference.md       # 详细规范（可选）
└── scripts/           # 可执行实现（可选）
```

### SKILL.md 格式

```yaml
---
name: skill-name
description: 何时使用此技能，包括触发模式。
---

# 技能名称

使用指南和说明...
```

## 贡献

欢迎贡献！添加新技能：

1. 在 `/skills/<skill-name>/` 下创建目录
2. 添加包含 YAML 前置元数据的 `SKILL.md`
3. 创建全面的 `README.md`
4. 可选添加 `examples.md` 和 `reference.md`
5. 遵循现有技能结构

### 提交规范

本项目遵循 [Conventional Commits 1.0.0](https://www.conventionalcommits.org/zh-hans/)：

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

类型：`feat`、`fix`、`docs`、`style`、`refactor`、`perf`、`test`、`build`、`ci`、`chore`、`revert`

## 许可证

MIT

## 致谢

为 Anthropic 的 [Claude Code](https://claude.ai/code) 构建。

AI 工作流由 [智谱 AI](https://open.bigmodel.cn/) GLM-4.7 模型驱动。
