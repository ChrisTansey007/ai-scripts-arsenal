# 📦 Safe File Migration Script

**Automated file migration with dry-run safety, progress tracking, and rollback support.**

**Available in two versions:**
- `migrate-files-safe.ps1` - PowerShell (Windows/macOS/Linux)
- `migrate-files-safe.sh` - Bash (macOS/Linux)

---

## 🎯 Purpose

Safely migrate scattered files to organized structure during repository reorganization with:
- ✅ **Dry-run by default** - Preview changes before executing
- ✅ **Automatic backups** - Safety net for rollback
- ✅ **Progress tracking** - See what's happening
- ✅ **Purpose documentation** - Know why files move where
- ✅ **Error handling** - Graceful failure recovery
- ✅ **Cross-platform** - PowerShell or Bash

---

## 🚀 Quick Start

### 1. Preview Migration (Safe)

**PowerShell (Windows/macOS/Linux):**
```powershell
# Shows what will happen without moving anything
./migrate-files-safe.ps1
```

**Bash (macOS/Linux):**
```bash
# Shows what will happen without moving anything
./migrate-files-safe.sh
```

### 2. Execute Migration (After Review)

**PowerShell:**
```powershell
# Actually moves files (creates backup first)
./migrate-files-safe.ps1 -DryRun:$false
```

**Bash:**
```bash
# Actually moves files (creates backup first)
./migrate-files-safe.sh --execute
```

---

## 📋 Usage

### Basic Usage

```powershell
# Preview mode (default)
./migrate-files-safe.ps1

# Execute mode
./migrate-files-safe.ps1 -DryRun:$false

# Custom base directory
./migrate-files-safe.ps1 -BaseDir /path/to/repo

# Skip backup (not recommended)
./migrate-files-safe.ps1 -DryRun:$false -SkipBackup
```

### Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `-DryRun` | switch | `$true` | Preview without moving files |
| `-BaseDir` | string | script location | Repository base directory |
| `-SkipBackup` | switch | `$false` | Skip automatic backup |

---

## 🔧 Customization

### 1. Edit File Mappings

Open `migrate-files-safe.ps1` and customize the `Move-File` calls:

```powershell
# Syntax
Move-File "source/path" "destination/path" "Purpose description"

# Examples
Move-File "README.md" "docs/00-CURRENT/README.md" "Main project docs"
Move-File "test.ps1" "scripts/03-TESTING/test-all.ps1" "Test runner"
```

### 2. Organize by Category

**Documentation:**
```powershell
# Current documents
Move-File "README.md" "docs/00-CURRENT/README.md" "Main readme"

# Guides
Move-File "SETUP.md" "docs/01-GUIDES/SETUP.md" "Setup guide"

# Technical docs
Move-File "API.md" "docs/02-TECHNICAL/API.md" "API reference"

# Runbooks
Move-File "DEPLOY.md" "docs/03-RUNBOOKS/DEPLOYMENT.md" "Deploy procedures"
```

**Scripts:**
```powershell
# Startup
Move-File "start.ps1" "scripts/00-STARTUP/start.ps1" "Main startup"

# Development
Move-File "dev.ps1" "scripts/01-DEVELOPMENT/dev.ps1" "Dev server"

# Testing
Move-File "test.ps1" "scripts/03-TESTING/test-all.ps1" "Test runner"

# Deployment
Move-File "deploy.ps1" "scripts/05-DEPLOYMENT/deploy.ps1" "Deploy script"
```

---

## 📊 Output Example

### Dry-Run Output

```
======================================================================
  📦 Safe File Migration Script
======================================================================

⚠  DRY RUN MODE - No files will be moved

📄 DOCUMENTATION

  [DRY RUN] README.md → docs/00-CURRENT/README.md
            Purpose: Main project documentation
  [DRY RUN] SETUP.md → docs/01-GUIDES/SETUP.md
            Purpose: Installation guide
  ⚠ Not found: API.md

📜 SCRIPTS

  [DRY RUN] start.ps1 → scripts/00-STARTUP/start.ps1
            Purpose: Main startup script
  [DRY RUN] test.ps1 → scripts/03-TESTING/test-all.ps1
            Purpose: Test runner

======================================================================
  📊 Migration Summary
======================================================================

Total files to migrate: 4
Skipped (not found): 1

This was a DRY RUN - no files were moved

To execute for real:
  ./migrate-files-safe.ps1 -DryRun:$false

Migration log saved: migration-log-20251019-140530.json
```

### Live Execution Output

```
======================================================================
  📦 Safe File Migration Script
======================================================================

🚀 LIVE MODE - Files will be moved

📦 Creating backup...
✓ Backup created: ../repo-backup-20251019-140530

📄 DOCUMENTATION

  ✓ README.md → docs/00-CURRENT/README.md
    Purpose: Main project documentation
  ✓ SETUP.md → docs/01-GUIDES/SETUP.md
    Purpose: Installation guide

📜 SCRIPTS

  ✓ start.ps1 → scripts/00-STARTUP/start.ps1
    Purpose: Main startup script

======================================================================
  📊 Migration Summary
======================================================================

✓ Successfully moved: 3 files
⚠ Skipped: 1

Migration complete!

Next steps:
  1. Verify file locations
  2. Update import paths
  3. Test application
  4. Commit changes

Migration log saved: migration-log-20251019-140530.json

💡 To rollback if needed:
  1. Stop your application
  2. Restore from backup: Copy-Item -Path '../repo-backup-20251019-140530\*' -Destination '.' -Recurse -Force
  3. Or use git: git checkout HEAD -- .
  4. Restart your application
```

---

## 🛡️ Safety Features

### 1. Dry-Run by Default
Script runs in preview mode unless explicitly told otherwise.

### 2. Automatic Backup
Creates timestamped backup before moving any files.

### 3. Existence Checks
Verifies source files exist and destinations don't.

### 4. Progress Tracking
Shows each file as it's processed.

### 5. Error Handling
Catches and reports errors without stopping migration.

### 6. Migration Log
Saves JSON log of all operations for audit trail.

### 7. Rollback Instructions
Provides clear steps to undo changes.

---

## 🔄 Rollback Procedure

### If Something Goes Wrong

**Method 1: Restore from Backup**
```powershell
# Stop application first
Stop-Process -Name "your-app" -Force

# Restore from backup
$backupPath = "../repo-backup-20251019-140530"
Copy-Item -Path "$backupPath\*" -Destination . -Recurse -Force

# Restart application
./start.ps1
```

**Method 2: Use Git**
```bash
# Discard all changes
git checkout HEAD -- .

# Or reset to specific commit
git reset --hard HEAD~1
```

---

## 📝 Migration Log

The script creates a JSON log file with all migration details:

**`migration-log-20251019-140530.json`**
```json
[
  {
    "Source": "README.md",
    "Destination": "docs/00-CURRENT/README.md",
    "Purpose": "Main project documentation",
    "Status": "Success"
  },
  {
    "Source": "API.md",
    "Destination": "docs/02-TECHNICAL/API.md",
    "Purpose": "API reference",
    "Status": "Skipped"
  }
]
```

**Use for:**
- Audit trail
- Verifying migrations
- Debugging issues
- Documentation

---

## 🎯 Best Practices

### 1. Always Dry-Run First
```powershell
# Preview
./migrate-files-safe.ps1

# Review output carefully
# Then execute
./migrate-files-safe.ps1 -DryRun:$false
```

### 2. Test on a Branch
```bash
git checkout -b refactor/repo-organization
./migrate-files-safe.ps1 -DryRun:$false
# Test everything
git commit -m "refactor: reorganize repository"
```

### 3. Document Your Mappings
```powershell
# ✅ Good - clear purpose
Move-File "api-test.js" "scripts/03-TESTING/api/api-test.js" "Tests API endpoints"

# ❌ Bad - no context
Move-File "api-test.js" "scripts/03-TESTING/api-test.js" ""
```

### 4. Keep Backups
Don't use `-SkipBackup` unless you have git committed.

### 5. Verify After Migration
```powershell
# Check file counts
(Get-ChildItem -Recurse -File).Count

# Look for orphaned files
Get-ChildItem -File -Depth 0

# Test application
./scripts/00-STARTUP/start.ps1
```

---

## 🔗 Related Arsenal Items

**🔄 Workflow:**
- [Repository File Organization](https://github.com/ChrisTansey007/ai-workflows-arsenal/blob/main/windsurf/project-organization/repo-organize-files.md) - Complete 3-phase process using this script

**⚙️ Rule:**
- [Repository Organization Principles](https://github.com/ChrisTansey007/ai-rules-arsenal/blob/main/windsurf/organization/repo-org-principles.md) - Principles this script implements

**🔗 Example:**
- [Repository Organization Example](https://github.com/ChrisTansey007/arsenal-integration-hub/tree/main/examples/repo-organization) - See this script in action

---

## 🆘 Troubleshooting

### Issue: "File not found" warnings

**Cause:** Source file doesn't exist  
**Solution:** Remove or comment out that migration, or fix the path

### Issue: "Already exists" warnings

**Cause:** Destination file already present  
**Solution:** Manually resolve conflict or delete destination

### Issue: Permission denied errors

**Cause:** Files in use or insufficient permissions  
**Solution:** Close applications, run as administrator

### Issue: Script won't execute

**Cause:** PowerShell execution policy  
**Solution:**
```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
./migrate-files-safe.ps1
```

---

## 📈 Success Metrics

After using this script:
- ✅ 0 files lost (backups saved you)
- ✅ Clear audit trail (migration log)
- ✅ Quick rollback if needed (< 5 minutes)
- ✅ Team confident in structure
- ✅ 80% reduction in search time

---

## 🤝 Contributing

Improvements welcome:
- Additional safety checks
- Bash version for Linux/macOS
- Support for more file types
- Better error messages
- Performance optimizations

---

## 📜 License

MIT License - Use freely in personal or commercial projects.

---

**Safe migrations make happy teams!** 🎉
