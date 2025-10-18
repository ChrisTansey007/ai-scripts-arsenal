# Launch Repository Script

## Purpose
Automate the complete process of initializing a Git repository, creating it on GitHub, and pushing your code - all in one command.

## Use Case
Use this script when you:
- Have a local project ready to publish to GitHub
- Want to skip manual repository creation
- Need to automate repository setup in CI/CD pipelines
- Are setting up multiple repositories quickly

## Prerequisites

### Required
- **Git** >= 2.0 - [Install Git](https://git-scm.com/downloads)

### Optional (Highly Recommended)
- **GitHub CLI** >= 2.0 - [Install GitHub CLI](https://cli.github.com/)
  - Without GitHub CLI, you'll get manual instructions
  - With GitHub CLI, everything is fully automated

## Platforms
- ✅ Windows (PowerShell)
- ✅ macOS (Bash)
- ✅ Linux (Bash)

## Usage

### PowerShell (Windows)
```powershell
.\launch.ps1
```

### Bash (macOS/Linux)
```bash
./launch.sh
```

The script will:
1. Check for Git and GitHub CLI
2. Initialize Git repository
3. Add all files
4. Create initial commit
5. Ask for repository visibility (public/private)
6. Create GitHub repository
7. Push to GitHub
8. Provide repository URL

## Arguments
No command-line arguments required - the script is interactive and prompts for needed information.

## AI Agent Instructions

### When to Use This Script
- User says "create a new GitHub repository"
- User wants to "push project to GitHub"
- User needs to "initialize and publish repository"
- After generating a new project structure
- When setting up a fresh codebase

### Prerequisites Check
Before running, verify:
1. Current directory contains the project to publish
2. Git is installed (`git --version`)
3. GitHub CLI is installed (optional but recommended)
4. User is authenticated with GitHub CLI (`gh auth status`)

### Expected Behavior
- **Exit Code 0**: Success - repository created and pushed
- **Exit Code 1**: Failure - check error messages for details

### Input Required
The script will prompt for:
- Repository visibility (public or private)

### Outputs
- Repository URL (e.g., `https://github.com/username/repo-name`)
- Git remote status
- Success confirmation message

## How to Customize

The script reads these values from the repository folder:
- **Repository name**: Derived from folder name
- **Description**: Hardcoded in script (can be modified)

To customize:
1. Edit the script file
2. Modify the `$repoDescription` or `REPO_DESCRIPTION` variable
3. Change the commit message template if desired

## Examples

### Example 1: Launch a New React Project
```bash
cd my-react-app
../ai-scripts-arsenal/scripts/repository-management/launch-repo/launch.sh
# Choose: 1 (Public)
# Result: Repository created at https://github.com/yourusername/my-react-app
```

### Example 2: Launch a Private Project
```powershell
cd my-private-project
..\ai-scripts-arsenal\scripts\repository-management\launch-repo\launch.ps1
# Choose: 2 (Private)
# Result: Private repository created and code pushed
```

### Example 3: Manual Setup (No GitHub CLI)
```bash
cd my-project
./launch.sh
# Script will:
# 1. Initialize Git locally
# 2. Create initial commit
# 3. Provide manual instructions to create repo on GitHub
# 4. Give you exact commands to run
```

## Error Handling

### Common Errors

**"Git is not installed"**
```
❌ Git is not installed. Please install git first.
```
**Solution:** Install Git from https://git-scm.com/downloads

**"GitHub CLI not found"**
```
⚠️  GitHub CLI not found. Will provide manual instructions.
```
**Solution:** Install GitHub CLI from https://cli.github.com or follow manual instructions

**"remote already exists"**
```
fatal: remote origin already exists
```
**Solution:** Remove existing remote
```bash
git remote remove origin
# Then run the script again
```

**"failed to push"**
```
error: failed to push some refs
```
**Solution:** Pull first, then push
```bash
git pull origin main --rebase
git push -u origin main
```

## Integration

### Can Be Combined With

**After this script:**
- [vercel-deploy](../../deployment/vercel-deploy/) - Deploy to Vercel
- [netlify-deploy](../../deployment/netlify-deploy/) - Deploy to Netlify
- [github-actions-ci](../../devops/github-actions-ci/) - Setup CI/CD

**Before this script:**
- [react-typescript-tailwind](../../project-initialization/react-typescript-tailwind/) - Create React project
- [python-fastapi](../../project-initialization/python-fastapi/) - Create FastAPI project

### Workflow Example
```bash
# 1. Create new React project
../ai-scripts-arsenal/scripts/project-initialization/react-typescript-tailwind/setup.sh

# 2. Launch to GitHub
../ai-scripts-arsenal/scripts/repository-management/launch-repo/launch.sh

# 3. Deploy to Vercel
../ai-scripts-arsenal/scripts/deployment/vercel-deploy/deploy.sh
```

## Technical Details

### What the Script Does

**Initialization Phase:**
1. Checks if Git is installed
2. Checks if GitHub CLI is installed
3. Validates current directory

**Git Setup Phase:**
4. Runs `git init` (if not already initialized)
5. Runs `git add .`
6. Creates detailed initial commit

**GitHub Creation Phase:**
7. Prompts for repository visibility
8. Runs `gh repo create` with appropriate flags
9. Sets up `origin` remote

**Push Phase:**
10. Sets main branch with `git branch -M main`
11. Pushes to GitHub with `git push -u origin main`
12. Displays repository URL

### Script Components

**PowerShell Version (launch.ps1):**
- Uses `Test-Path` for file checks
- Uses `Get-Command` to check for tools
- Uses `gh` CLI for GitHub operations
- Colored output with `Write-Host -ForegroundColor`

**Bash Version (launch.sh):**
- Uses `command -v` to check for tools
- Uses `gh` CLI for GitHub operations
- ANSI color codes for output
- POSIX-compliant for maximum compatibility

## Security Considerations

**What This Script Does:**
- ✅ Creates public or private repositories (you choose)
- ✅ Pushes all files in current directory
- ✅ Uses GitHub authentication (via gh CLI)

**Important Notes:**
- ⚠️ Review files before running (script pushes everything)
- ⚠️ Check `.gitignore` is properly configured
- ⚠️ Ensure no sensitive data (API keys, passwords) in files
- ⚠️ Private repos require GitHub paid plan or free plan limits

## Troubleshooting

### Script won't run (PowerShell)
**Error:** "execution of scripts is disabled"
**Solution:**
```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
.\launch.ps1
```

### Script won't run (Bash)
**Error:** "Permission denied"
**Solution:**
```bash
chmod +x launch.sh
./launch.sh
```

### GitHub CLI authentication fails
**Solution:**
```bash
gh auth login
# Follow the prompts to authenticate
```

### Git user not configured
**Error:** "Please tell me who you are"
**Solution:**
```bash
git config --global user.email "you@example.com"
git config --global user.name "Your Name"
```

## Performance

**Estimated Time:** 1-2 minutes
- With GitHub CLI: ~30 seconds
- Without GitHub CLI (manual): ~2 minutes

**Network Requirements:**
- Internet connection required
- GitHub API access needed

## Version History

- **v1.0.0** - Initial release
  - PowerShell and Bash implementations
  - GitHub CLI integration
  - Manual fallback mode

## Credits

Based on community best practices:
- GitHub's official CLI documentation
- DevOps automation patterns
- Community feedback from [prompt-arsenal](https://github.com/ChrisTansey007/prompt-arsenal)

## Related Documentation

- [GitHub CLI Documentation](https://cli.github.com/manual/)
- [Git Documentation](https://git-scm.com/doc)
- [GitHub Repository Creation](https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-new-repository)

---

**Questions?** Open an issue or check the [main README](../../../README.md)

**Part of [ai-scripts-arsenal](https://github.com/ChrisTansey007/ai-scripts-arsenal)**
