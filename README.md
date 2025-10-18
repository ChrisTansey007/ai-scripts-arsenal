# 🤖 AI Scripts Arsenal

**Your comprehensive toolkit of AI-friendly automation scripts for common developer workflows**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Scripts](https://img.shields.io/badge/Scripts-15+-blue.svg)]()
[![Cross-Platform](https://img.shields.io/badge/Platform-Win%20%7C%20Mac%20%7C%20Linux-green.svg)]()
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)

**Companion repository to [prompt-arsenal](https://github.com/ChrisTansey007/prompt-arsenal)**

Created and maintained by [Chris Creates with AI](https://chriscreateswithai.com)

---

## 🎯 What is This?

AI Scripts Arsenal provides **ready-to-run automation scripts** that:

- ✅ **AI agents can understand and execute** - Clear documentation, predictable behavior
- ✅ **Work cross-platform** - PowerShell, Bash, Python implementations
- ✅ **Automate common workflows** - Repository management, deployment, testing, database ops
- ✅ **Chain together seamlessly** - Build complex workflows from simple scripts
- ✅ **Are production-tested** - Based on community best practices and real-world usage

---

## 🔗 The Arsenal Ecosystem

**How They Work Together:**

### [prompt-arsenal](https://github.com/ChrisTansey007/prompt-arsenal) → **WHAT to build**
- System prompts for AI agents
- Code generation templates
- Best practices and patterns

### ai-scripts-arsenal → **HOW to execute it**
- Automation scripts
- Workflow orchestration
- Infrastructure code

**Example Flow:**
1. Use **prompt-arsenal** to generate a "Python FastAPI project" prompt
2. AI generates the project structure
3. Use **ai-scripts-arsenal** to run `python-fastapi-setup.sh`
4. Result: Fully initialized, tested, and deployable project in minutes

---

## 📚 Available Scripts

### 🗂️ Repository Management
- **[launch-repo](./scripts/repository-management/launch-repo/)** - Initialize git, create GitHub repo, push automatically
- **[fork-sync](./scripts/repository-management/fork-sync/)** - Sync fork with upstream repository
- **[branch-manager](./scripts/repository-management/branch-manager/)** - Create branches with naming conventions

### 🏗️ Project Initialization
- **[react-typescript-tailwind](./scripts/project-initialization/react-typescript-tailwind/)** - Scaffold React + TypeScript + Tailwind project
- **[python-fastapi](./scripts/project-initialization/python-fastapi/)** - Bootstrap production-ready FastAPI project
- **[nextjs-starter](./scripts/project-initialization/nextjs-starter/)** - Next.js full-stack starter with TypeScript
- **[express-typescript](./scripts/project-initialization/express-typescript/)** - Express + TypeScript API boilerplate

### ✨ Code Quality
- **[eslint-prettier-setup](./scripts/code-quality/eslint-prettier-setup/)** - Configure ESLint + Prettier + Airbnb style
- **[pre-commit-hooks](./scripts/code-quality/pre-commit-hooks/)** - Setup automated pre-commit hooks
- **[test-coverage](./scripts/code-quality/test-coverage/)** - Run tests with coverage reports
- **[security-audit](./scripts/code-quality/security-audit/)** - Scan for vulnerabilities

### 🚀 Deployment
- **[docker-build-push](./scripts/deployment/docker-build-push/)** - Build and push Docker images
- **[vercel-deploy](./scripts/deployment/vercel-deploy/)** - Deploy to Vercel with one command
- **[netlify-deploy](./scripts/deployment/netlify-deploy/)** - Deploy to Netlify automatically
- **[aws-deploy](./scripts/deployment/aws-deploy/)** - Deploy to AWS (S3, Lambda, etc.)

### 🗄️ Database
- **[migration-runner](./scripts/database/migration-runner/)** - Run database migrations (Knex, Alembic, etc.)
- **[backup-restore](./scripts/database/backup-restore/)** - Backup and restore databases
- **[seed-data](./scripts/database/seed-data/)** - Populate database with seed data

### 🛠️ Utilities
- **[newman-api-tester](./scripts/utilities/newman-api-tester/)** - Run API tests with Newman (Postman CLI)
- **[dependency-updater](./scripts/utilities/dependency-updater/)** - Update all dependencies to latest versions
- **[log-analyzer](./scripts/utilities/log-analyzer/)** - Parse and analyze log files
- **[bulk-rename](./scripts/utilities/bulk-rename/)** - Batch rename files with patterns

---

## 🚀 Quick Start

### 1. Clone the Repository

```bash
git clone https://github.com/ChrisTansey007/ai-scripts-arsenal.git
cd ai-scripts-arsenal
```

### 2. Choose a Script

Browse `scripts/` by category and find what you need.

### 3. Read the Documentation

Each script has its own README with:
- Purpose and use cases
- Prerequisites
- Usage examples
- Configuration options
- AI agent instructions

### 4. Run the Script

```bash
# Bash
./scripts/category/script-name/script.sh

# PowerShell
.\scripts\category\script-name\script.ps1

# Python
python scripts/category/script-name/script.py
```

---

## 💡 Example: Launch a New Repository

```bash
# Navigate to your project directory
cd my-new-project

# Run the launch script
../ai-scripts-arsenal/scripts/repository-management/launch-repo/launch.sh

# Follow the prompts to:
# - Initialize git
# - Create GitHub repository
# - Push your code
# - Set up remote tracking
```

**Result:** Your project is on GitHub in under 2 minutes! 🎉

---

## 🎯 Script Features

Every script in this arsenal follows best practices:

### ✅ Idempotent
Safe to run multiple times - checks if work is already done

```bash
if [ -f ".initialized" ]; then
    echo "✅ Already initialized, skipping..."
    exit 0
fi
```

### ✅ Verbose Output
Clear status messages with emojis for easy parsing

```bash
echo "🔍 Checking prerequisites..."
echo "✅ Git found (version 2.39.0)"
echo "⚠️  Node.js not found, installing..."
```

### ✅ Error Handling
Graceful failures with actionable suggestions

```python
try:
    execute_command()
except CommandError as e:
    print(f"❌ Failed: {e}")
    print("💡 Try: run with --verbose for details")
    sys.exit(1)
```

### ✅ Configurable
JSON/YAML config files for customization

```json
{
  "project_name": "my-project",
  "framework": "nextjs",
  "deploy_target": "vercel"
}
```

---

## 🤖 AI Agent Integration

These scripts are designed to be AI-friendly:

### Metadata Files
Each script includes `metadata.yml`:

```yaml
name: "Launch Repository"
category: "repository-management"
ai_usage:
  when_to_use:
    - "User wants to create new GitHub repository"
  inputs:
    - name: "repo_name"
      required: true
  outputs:
    - "GitHub repository URL"
```

### Clear Documentation
README format optimized for AI parsing:
- **Purpose** - One-line summary
- **When to Use** - Triggers for AI agents
- **Prerequisites** - Required tools
- **Examples** - Real-world usage
- **Integration** - How to chain with other scripts

### Predictable Behavior
- Exit code 0 = success
- Exit code 1 = failure
- JSON output for structured results

---

## 📋 Script Categories

| Category | Scripts | Purpose |
|----------|---------|---------|
| **Repository Management** | 3 | Git, GitHub, forking, branching |
| **Project Initialization** | 4 | Bootstrap new projects |
| **Code Quality** | 4 | Linting, testing, security |
| **Deployment** | 4 | Docker, Vercel, Netlify, AWS |
| **Database** | 3 | Migrations, backups, seeding |
| **Utilities** | 4 | Testing, updating, analyzing |

**Total:** 22 scripts across 6 categories

---

## 🏗️ Repository Structure

```
ai-scripts-arsenal/
├── scripts/
│   ├── repository-management/
│   ├── project-initialization/
│   ├── code-quality/
│   ├── deployment/
│   ├── database/
│   └── utilities/
├── templates/
│   ├── script-template/
│   └── ai-instructions.md
├── docs/
│   ├── getting-started.md
│   ├── script-development-guide.md
│   └── ai-agent-integration.md
├── README.md
├── CONTRIBUTING.md
└── LICENSE
```

---

## 🤝 Contributing

We welcome contributions! See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

**What we're looking for:**
- New automation scripts
- Additional language implementations (PowerShell, Bash, Python)
- Bug fixes and improvements
- Documentation enhancements
- Real-world usage examples

---

## 📚 Resources

- **Documentation:** [docs/](./docs/)
- **Script Templates:** [templates/](./templates/)
- **Sister Project:** [prompt-arsenal](https://github.com/ChrisTansey007/prompt-arsenal)
- **Website:** [chriscreateswithai.com](https://chriscreateswithai.com)

---

## 🏷️ Topics

`automation` `scripts` `devops` `ci-cd` `github` `deployment` `docker` `python` `bash` `powershell` `ai-friendly` `workflow-automation`

---

## 📖 Inspiration & Sources

This collection is built on proven patterns from:
- Community scripts (GitHub, Medium, DEV.to)
- Production DevOps workflows
- Open-source automation tools
- AI agent best practices

Key references documented in [ai-scripts-arsenal-research-summary.md](./docs/research-summary.md)

---

## 📜 License

MIT License - see [LICENSE](LICENSE) for details

---

## 🌟 Show Your Support

If this helps your workflow:
- ⭐ Star this repository
- 🔱 Fork and customize
- 🤝 Contribute scripts
- 📢 Share with others

---

**Built with ❤️ for developers and AI agents alike**

**Let's automate all the things!** 🚀
