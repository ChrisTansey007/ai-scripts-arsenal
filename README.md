# 🤖 AI Scripts Arsenal

**Your comprehensive toolkit of AI-friendly automation scripts for common developer workflows**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Scripts](https://img.shields.io/badge/Scripts-4%20(15%2B%20Planned)-blue.svg)]()
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

### ✅ Available Now (4 Scripts)

#### Repository Management
- **[launch-repo](./scripts/repository-management/launch-repo/)** - Initialize git, create GitHub repo, push automatically
  - `launch.sh` - Bash version (macOS/Linux)
  - `launch.ps1` - PowerShell version (Windows)
- **[migrate-files](./scripts/repository-management/migrate-files/)** - Safe file migration with dry-run, backup, and rollback
  - `migrate-files-safe.ps1` - PowerShell version with full safety features
  - `migrate-files-safe.sh` - Bash version with full safety features

#### Development
- **[nextjs-start-dev](./scripts/development/nextjs-start-dev/)** - Smart Next.js dev server starter with auto-checks
  - `start-dev.ps1` - PowerShell version with port management and Node verification
  - `start-dev.sh` - Bash version with auto-dependency install

### 🚧 Coming Soon (15+ Planned)

We're actively building a comprehensive script library! Contributions welcome.

**Planned Categories:**

**🏭️ Project Initialization:**
- 🚧 React + TypeScript + Tailwind scaffold
- 🚧 FastAPI production-ready bootstrap
- 🚧 Next.js full-stack starter
- 🚧 Express + TypeScript API boilerplate

**✨ Code Quality:**
- 🚧 ESLint + Prettier + Airbnb setup
- 🚧 Pre-commit hooks automation
- 🚧 Test coverage reporting
- 🚧 Security audit scanner

**🚀 Deployment:**
- 🚧 Docker build & push
- 🚧 Vercel deploy automation
- 🚧 Netlify deploy automation
- 🚧 AWS deploy (S3, Lambda)

**🗄️ Database:**
- 🚧 Migration runner
- 🚧 Backup & restore
- 🚧 Seed data loader

**🛠️ Utilities:**
- 🚧 API testing with Newman
- 🚧 Dependency updater
- 🚧 Log analyzer
- 🚧 Bulk file renamer

**Want to contribute?** See [CONTRIBUTING.md](CONTRIBUTING.md) or [open an issue](https://github.com/ChrisTansey007/ai-scripts-arsenal/issues) to request a script!

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

## 🔗 Related Arsenal Projects

**🤖 ai-scripts-arsenal** ⭐ YOU ARE HERE  
Automation scripts for repository setup and management

**💭 [windsurf-memories-arsenal](https://github.com/ChrisTansey007/windsurf-memories-arsenal)**  
Project context and standards that Cascade remembers

**⚙️ [ai-rules-arsenal](https://github.com/ChrisTansey007/ai-rules-arsenal)**  
Framework-specific development rules and patterns

**🔄 [ai-workflows-arsenal](https://github.com/ChrisTansey007/ai-workflows-arsenal)**  
Multi-step automation workflows for common tasks

**📝 [prompt-arsenal](https://github.com/ChrisTansey007/prompt-arsenal)**  
Reusable prompts and AI agent configurations

**🔗 [arsenal-integration-hub](https://github.com/ChrisTansey007/arsenal-integration-hub)**  
Complete examples showing how to use all Arsenal tools together  
→ **See our scripts in action:** [Setup Script](https://github.com/ChrisTansey007/arsenal-integration-hub/blob/main/scripts/setup-project.sh)

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
