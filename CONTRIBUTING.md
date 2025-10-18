# Contributing to AI Scripts Arsenal

Thank you for considering contributing to AI Scripts Arsenal! This project aims to provide high-quality, AI-friendly automation scripts for common developer workflows.

## 🎯 What We're Looking For

- **New automation scripts** for common workflows
- **Additional language implementations** (PowerShell, Bash, Python)
- **Bug fixes and improvements** to existing scripts
- **Documentation enhancements**
- **Real-world usage examples**
- **Test cases** for existing scripts

## 📋 Script Submission Guidelines

### Script Quality Standards

Every script should:

✅ **Be cross-platform** - Provide PowerShell AND Bash versions (minimum)  
✅ **Be idempotent** - Safe to run multiple times  
✅ **Have verbose output** - Clear status messages with emojis  
✅ **Handle errors gracefully** - Catch failures and suggest solutions  
✅ **Be configurable** - Use config files or environment variables  
✅ **Be documented** - Complete README following our template  
✅ **Include metadata** - YAML file for AI agent consumption  

### Directory Structure

Each script must follow this structure:

```
scripts/category/script-name/
├── README.md              # Complete documentation
├── metadata.yml           # AI-friendly metadata
├── script.ps1            # PowerShell implementation
├── script.sh             # Bash implementation
├── script.py             # Python (if applicable)
├── config.example.json   # Configuration template
├── .env.example          # Environment variables
└── tests/                # Test cases
    └── test.sh
```

### README Template

Use this structure for script README:

```markdown
# Script Name

## Purpose
[One-line description]

## Use Case
[When to use this script]

## Prerequisites
- Tool 1 (version)
- Tool 2 (version)

## Usage
[bash
./script.sh [arguments]
```

## Arguments
- `--arg1`: Description

## AI Agent Instructions
When to use: ...
How to customize: ...

## Examples
[Real-world scenarios]

## Error Handling
[Common errors and solutions]

## Integration
Can be combined with: [other scripts]
```

### Metadata Template

```yaml
name: "Script Name"
version: "1.0.0"
category: "category-name"
description: "Brief description"
platforms: [windows, macos, linux]
languages: [powershell, bash, python]
prerequisites:
  required:
    - name: "tool-name"
      version: ">= 1.0"
ai_usage:
  when_to_use:
    - "Trigger condition 1"
  inputs:
    - name: "input_name"
      required: true
  outputs:
    - "output description"
estimated_time: "X minutes"
complexity: "simple|medium|complex"
tags: [tag1, tag2]
```

## 🔧 Development Process

### 1. Fork the Repository

```bash
gh repo fork ChrisTansey007/ai-scripts-arsenal --clone
cd ai-scripts-arsenal
```

### 2. Create a Feature Branch

```bash
git checkout -b feature/your-script-name
```

### 3. Develop Your Script

1. Create the directory structure
2. Write PowerShell and Bash versions
3. Create README.md
4. Create metadata.yml
5. Add config templates if needed
6. Write tests

### 4. Test Your Script

```bash
# Test PowerShell version
pwsh scripts/category/your-script/script.ps1

# Test Bash version
bash scripts/category/your-script/script.sh

# Run tests
bash scripts/category/your-script/tests/test.sh
```

### 5. Submit a Pull Request

```bash
git add .
git commit -m "Add [script-name] for [purpose]"
git push origin feature/your-script-name
gh pr create --title "Add [script-name]" --body "Description of what this script does"
```

## 📝 PR Description Template

```markdown
## What does this script do?
[Brief description]

## Category
- [ ] Repository Management
- [ ] Project Initialization
- [ ] Code Quality
- [ ] Deployment
- [ ] Database
- [ ] Utilities
- [ ] Other: [specify]

## Checklist
- [ ] PowerShell implementation
- [ ] Bash implementation  
- [ ] Python implementation (if applicable)
- [ ] README.md with complete documentation
- [ ] metadata.yml file
- [ ] config.example.json (if needed)
- [ ] Tests included
- [ ] Tested on Windows
- [ ] Tested on macOS/Linux
- [ ] Idempotent (safe to run multiple times)
- [ ] Error handling implemented
- [ ] Verbose output with status messages

## Real-world use case
[Describe when/why you use this script]

## Example usage
\`\`\`bash
./script.sh --example
\`\`\`
```

## 🎨 Code Style Guidelines

### PowerShell
- Use `PascalCase` for variables
- Include parameter validation
- Use `Write-Host` with colors for output
- Exit with code 0 (success) or 1 (failure)

```powershell
param(
    [Parameter(Mandatory=$true)]
    [string]$ProjectName
)

Write-Host "✅ Success message" -ForegroundColor Green
Write-Host "⚠️  Warning message" -ForegroundColor Yellow
Write-Host "❌ Error message" -ForegroundColor Red
```

### Bash
- Use `snake_case` for variables
- Include shebang: `#!/bin/bash`
- Use ANSI colors for output
- Exit with code 0 (success) or 1 (failure)

```bash
#!/bin/bash

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}✅ Success message${NC}"
echo -e "${YELLOW}⚠️  Warning message${NC}"
echo -e "${RED}❌ Error message${NC}"
```

### Python
- Follow PEP 8
- Use type hints
- Include docstrings
- Use click or argparse for CLI

```python
#!/usr/bin/env python3
"""
Script description here.
"""

import sys

def main():
    try:
        # Do work
        print("✅ Success")
        sys.exit(0)
    except Exception as e:
        print(f"❌ Error: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()
```

## 🚫 What NOT to Submit

- Scripts that only work on one platform (must support at least 2)
- Hard-coded credentials or API keys
- Scripts without documentation
- Scripts that modify system files without user confirmation
- Malicious or destructive scripts
- Scripts duplicating existing functionality (unless significantly improved)

## 🏷️ Categories

Submit scripts under one of these categories:

- **repository-management** - Git, GitHub, forking, branching
- **project-initialization** - Bootstrapping new projects
- **code-quality** - Linting, testing, security, formatting
- **deployment** - Docker, cloud platforms, CI/CD
- **database** - Migrations, backups, seeding
- **utilities** - General-purpose tools

If your script doesn't fit, propose a new category!

## 🤝 Community Guidelines

- Be respectful and constructive
- Help others in discussions
- Share real-world use cases
- Provide feedback on PRs
- Report bugs with clear reproduction steps

## 📖 Resources

- [Script Template](./templates/script-template/)
- [AI Instructions Guide](./docs/ai-agent-integration.md)
- [Development Guide](./docs/script-development-guide.md)

## 🎉 Recognition

Contributors will be:
- Listed in script metadata
- Credited in release notes
- Featured in README (top contributors)

## 📜 License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

**Questions?** Open an issue or reach out to [@ChrisTansey007](https://github.com/ChrisTansey007)

**Let's build the best automation toolkit together!** 🚀
