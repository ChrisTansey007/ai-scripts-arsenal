# 🚀 React Vite Setup Scripts

**Automated React/Vite project setup with ESM configuration fixes and comprehensive validation.**

**Available in two versions:**
- `setup-react-vite.ps1` - PowerShell (Windows/macOS/Linux)
- `setup-react-vite.sh` - Bash (macOS/Linux)

---

## 🎯 What This Does

This script automates the complete setup process for React/Vite projects, especially in monorepo structures:

1. ✅ **Validates environment** (Node.js, npm, project structure)
2. ✅ **Installs dependencies** (root, app, and test packages)
3. ✅ **Fixes ESM configuration** (converts CommonJS to ES modules)
4. ✅ **Installs Playwright** (browsers and dependencies)
5. ✅ **Verifies setup** (syntax checks, validation)
6. ✅ **Creates backups** (before making changes)

**Time Saved:** 15-20 minutes per project setup

---

## 📋 Prerequisites

### Required
- **Node.js** >= 18.x ([download](https://nodejs.org/))
- **npm** (comes with Node.js)

### Optional
- **Git** (for version control)
- **PowerShell 7+** (for Windows, included in macOS/Linux)

---

## 🚀 Quick Start

### PowerShell (Windows)

```powershell
# Navigate to your project
cd C:\path\to\your\project

# Run the setup script
.\setup-react-vite.ps1 -ProjectPath .

# Or with full path
.\setup-react-vite.ps1 -ProjectPath C:\path\to\your\project
```

### Bash (macOS/Linux)

```bash
# Make script executable (first time only)
chmod +x setup-react-vite.sh

# Navigate to your project
cd /path/to/your/project

# Run the setup script
./setup-react-vite.sh --project-path .

# Or with full path
./setup-react-vite.sh --project-path /path/to/your/project
```

---

## 📖 Usage

### PowerShell Version

```powershell
.\setup-react-vite.ps1 -ProjectPath <path> [options]

# Options:
#   -ProjectPath    Project root directory (required)
#   -DryRun         Preview changes without executing
#   -SkipInstall    Skip npm install steps
#   -NoAutoFixESM   Don't automatically fix ESM configs
```

### Bash Version

```bash
./setup-react-vite.sh --project-path <path> [options]

# Options:
#   --project-path PATH    Project root directory (required)
#   --dry-run              Preview changes without executing
#   --skip-install         Skip npm install steps
#   --no-auto-fix-esm      Don't automatically fix ESM configs
#   -h, --help             Show help message
```

---

## 💡 Common Use Cases

### 1. First-Time Setup (Full)

**Run everything - install all dependencies and fix configs:**

```powershell
# PowerShell
.\setup-react-vite.ps1 -ProjectPath .

# Bash
./setup-react-vite.sh --project-path .
```

### 2. Preview Changes (Dry Run)

**See what would be changed without making actual changes:**

```powershell
# PowerShell
.\setup-react-vite.ps1 -ProjectPath . -DryRun

# Bash
./setup-react-vite.sh --project-path . --dry-run
```

### 3. Fix ESM Only (Skip Install)

**Already installed dependencies, just need ESM fixes:**

```powershell
# PowerShell
.\setup-react-vite.ps1 -ProjectPath . -SkipInstall

# Bash
./setup-react-vite.sh --project-path . --skip-install
```

### 4. Manual ESM Control

**Disable automatic ESM fixes (review changes first):**

```powershell
# PowerShell
.\setup-react-vite.ps1 -ProjectPath . -NoAutoFixESM

# Bash
./setup-react-vite.sh --project-path . --no-auto-fix-esm
```

---

## 🗂️ Project Structure Support

### Standard Vite Project

```
my-project/
├── package.json
├── vite.config.js
├── postcss.config.js
├── tailwind.config.js
├── src/
└── public/
```

**Script will:**
- Install root dependencies
- Fix ESM configs in root
- Verify setup

### Monorepo Structure

```
my-monorepo/
├── package.json
├── apps/
│   └── web/
│       ├── package.json
│       ├── vite.config.js
│       ├── postcss.config.js
│       └── tailwind.config.js
└── test-harness/
    ├── package.json
    └── playwright.config.js
```

**Script will:**
- Install root dependencies
- Install app dependencies (apps/web)
- Install test dependencies (test-harness)
- Install Playwright browsers
- Fix ESM configs in both root and apps/web
- Verify all setups

---

## 🔧 What Gets Fixed

### ESM Configuration Issues

**The Problem:**
```javascript
// ❌ CommonJS syntax (causes "module is not defined" error)
module.exports = {
  plugins: {
    tailwindcss: {},
    autoprefixer: {},
  },
}
```

**The Fix:**
```javascript
// ✅ ES Module syntax (correct for Vite)
export default {
  plugins: {
    tailwindcss: {},
    autoprefixer: {},
  },
}
```

### Affected Files

Script automatically fixes these files if found:

- ✅ `vite.config.js`
- ✅ `postcss.config.js`
- ✅ `tailwind.config.js`
- ✅ `vitest.config.js`
- ✅ `playwright.config.js`
- ✅ `apps/web/vite.config.js` (monorepo)
- ✅ `apps/web/postcss.config.js` (monorepo)
- ✅ `apps/web/tailwind.config.js` (monorepo)

---

## 📊 Output Example

```
========================================
  React Vite Setup - Starting
========================================

========================================
  Step 1/6: Validate Environment
========================================
✓ Project path exists: C:\my-project
✓ Changed to project directory
✓ Node.js version: v20.10.0
✓ npm version: 10.2.3
✓ Found package.json

========================================
  Step 2/6: Install Root Dependencies
========================================
ℹ Running npm install in project root...
✓ Root dependencies installed successfully

========================================
  Step 3/6: Detect and Fix ESM Configuration
========================================
✓ package.json has "type": "module"
✓ Created backup directory: .setup-backups-20251019-113000
⚠ Found CommonJS syntax in postcss.config.js
✓ Converted postcss.config.js to ESM syntax
⚠ Found CommonJS syntax in tailwind.config.js
✓ Converted tailwind.config.js to ESM syntax
✓ Fixed 2 config file(s)
ℹ Backups saved to: .setup-backups-20251019-113000

========================================
  Step 4/6: Install App Dependencies
========================================
ℹ Detected monorepo structure (apps/web)
ℹ Running npm install in apps/web...
✓ App dependencies installed successfully

========================================
  Step 5/6: Install Test Dependencies
========================================
ℹ Running npm install in test-harness...
✓ Test dependencies installed successfully
ℹ Installing Playwright browsers...
✓ Playwright browsers installed successfully

========================================
  Step 6/6: Verification
========================================
ℹ Verifying config files syntax...
✓ vite.config.js syntax is valid
✓ postcss.config.js syntax is valid
✓ tailwind.config.js syntax is valid
✓ All config files passed syntax verification

========================================
  Setup Complete!
========================================
✓ Project setup completed successfully

ℹ To start the dev server:
  cd apps/web && npm run dev

ℹ Backups of modified files saved to: .setup-backups-20251019-113000
ℹ To rollback changes, restore from backup directory

✓ All done! 🚀
```

---

## 🔄 Rollback Changes

If something goes wrong, you can restore from backups:

### PowerShell

```powershell
# List backup directories
Get-ChildItem .setup-backups-*

# Restore a file
Copy-Item .setup-backups-20251019-113000\postcss.config.js.bak postcss.config.js -Force

# Or restore all
Get-ChildItem .setup-backups-20251019-113000\*.bak | ForEach-Object {
    $originalName = $_.Name -replace '\.bak$', ''
    Copy-Item $_.FullName $originalName -Force
}
```

### Bash

```bash
# List backup directories
ls -la .setup-backups-*

# Restore a file
cp .setup-backups-20251019-113000/postcss.config.js.bak postcss.config.js

# Or restore all
for f in .setup-backups-20251019-113000/*.bak; do
    cp "$f" "$(basename "$f" .bak)"
done
```

---

## 🚨 Troubleshooting

### "Node.js is not installed"

**Solution:**
```bash
# Check if Node is in PATH
node --version

# If not found, install from https://nodejs.org/
# Or use nvm:
nvm install 20
nvm use 20
```

### "Project path does not exist"

**Solution:**
```bash
# Use absolute path
.\setup-react-vite.ps1 -ProjectPath C:\full\path\to\project

# Or navigate first
cd C:\path\to\project
.\setup-react-vite.ps1 -ProjectPath .
```

### "No package.json found"

**Solution:**
```bash
# Make sure you're in the project root
ls package.json

# Or create a new Vite project first
npm create vite@latest my-app -- --template react
cd my-app
.\setup-react-vite.ps1 -ProjectPath .
```

### "Failed to install dependencies"

**Solution:**
```bash
# Clear npm cache
npm cache clean --force

# Delete node_modules and package-lock.json
rm -rf node_modules package-lock.json

# Try again
.\setup-react-vite.ps1 -ProjectPath .
```

### "Config file has syntax errors"

**Solution:**
```bash
# Check the file manually
node --check vite.config.js

# Restore from backup if needed
cp .setup-backups-*/vite.config.js.bak vite.config.js

# Or fix manually - ensure using ES module syntax:
# export default { ... }
# NOT: module.exports = { ... }
```

---

## 🎯 Best Practices

### 1. Always Run Dry Run First

```powershell
# Preview changes before applying
.\setup-react-vite.ps1 -ProjectPath . -DryRun
```

### 2. Commit Before Running

```bash
# Save your current state
git add .
git commit -m "Before running setup script"

# Run script
.\setup-react-vite.ps1 -ProjectPath .

# Verify changes
git diff
```

### 3. Review Fixed Files

```bash
# Check what was changed
cat postcss.config.js
cat tailwind.config.js

# Test dev server
npm run dev
```

### 4. Keep Backups

```bash
# Don't delete backup directories immediately
ls .setup-backups-*

# Only delete after verifying everything works
rm -rf .setup-backups-*
```

---

## 🔗 Related Arsenal Items

**⚙️ Rules:**
- [Vite ESM Consistency](https://github.com/ChrisTansey007/ai-rules-arsenal/blob/main/windsurf/by-framework/vite-esm-modules.md) - Complete ESM guide

**💭 Prompts:**
- [Modernize React UI](https://github.com/ChrisTansey007/prompt-arsenal/blob/main/development/ui/modernize-react-ui.md) - UI enhancement guide

**🔗 Example:**
- [React Vite Setup Example](https://github.com/ChrisTansey007/arsenal-integration-hub/tree/main/examples/react-vite-setup) - Complete workflow demo

---

## 📚 Technical Details

### What the Script Does

1. **Environment Validation**
   - Checks Node.js >= 18.x
   - Verifies npm is available
   - Confirms package.json exists

2. **Dependency Installation**
   - Root: `npm install`
   - App (if exists): `cd apps/web && npm install`
   - Tests (if exists): `cd test-harness && npm install`
   - Playwright: `npx playwright install --with-deps`

3. **ESM Configuration**
   - Detects `"type": "module"` in package.json
   - Finds all config files (root + monorepo)
   - Backs up before modifying
   - Converts `module.exports` → `export default`

4. **Verification**
   - Runs `node --check` on all config files
   - Reports syntax errors
   - Confirms setup success

### Exit Codes

- `0` - Success
- `1` - Error (invalid arguments, missing dependencies, failed install, etc.)

---

## 🆘 Getting Help

### Option 1: View Help

```powershell
# PowerShell
Get-Help .\setup-react-vite.ps1 -Full

# Bash
./setup-react-vite.sh --help
```

### Option 2: Check Arsenal

- [Vite ESM Rule](https://github.com/ChrisTansey007/ai-rules-arsenal/blob/main/windsurf/by-framework/vite-esm-modules.md)
- [Arsenal Integration Hub](https://github.com/ChrisTansey007/arsenal-integration-hub)

### Option 3: Common Issues

See **Troubleshooting** section above for common problems and solutions.

---

## ✅ Success Checklist

After running the script, verify:

- [ ] Dev server starts: `npm run dev`
- [ ] No "module is not defined" errors
- [ ] No "require is not defined" errors
- [ ] Build succeeds: `npm run build`
- [ ] Tests run (if applicable): `npm test`
- [ ] All pages load correctly
- [ ] No console errors in browser

---

**Result: React/Vite project fully set up and ready to develop!** 🎉
