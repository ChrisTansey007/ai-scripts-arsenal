# 🚀 Next.js Development Server Starter

**Smart dev server starter with automated checks, port management, and browser launch.**

**Available in two versions:**
- `start-dev.ps1` - PowerShell (Windows/macOS/Linux)
- `start-dev.sh` - Bash (macOS/Linux)

---

## 🎯 Purpose

A drop-in script for any Next.js project that:
- ✅ **Auto-installs dependencies** if node_modules missing
- ✅ **Verifies Node version** (18+ required)
- ✅ **Checks port availability** and finds alternative if needed
- ✅ **Validates environment** files
- ✅ **Opens browser automatically** (optional)
- ✅ **Supports Turbopack** for faster builds
- ✅ **Network access** option (bind to 0.0.0.0)
- ✅ **Beautiful output** with colors and progress

---

## 🚀 Quick Start

### Installation

**Copy to your Next.js project:**
```bash
# PowerShell version (recommended for Windows)
curl -O https://raw.githubusercontent.com/ChrisTansey007/ai-scripts-arsenal/main/scripts/development/nextjs-start-dev/start-dev.ps1

# Bash version (macOS/Linux)
curl -O https://raw.githubusercontent.com/ChrisTansey007/ai-scripts-arsenal/main/scripts/development/nextjs-start-dev/start-dev.sh
chmod +x start-dev.sh
```

### Basic Usage

**PowerShell:**
```powershell
# Start with defaults
./start-dev.ps1

# Start and open browser
./start-dev.ps1 -OpenBrowser

# Use custom port
./start-dev.ps1 -Port 3001

# Use Turbopack (faster builds)
./start-dev.ps1 -Turbo

# Allow network access
./start-dev.ps1 -Hostname 0.0.0.0
```

**Bash:**
```bash
# Start with defaults
./start-dev.sh

# Start and open browser
./start-dev.sh --open-browser

# Use custom port
./start-dev.sh --port 3001

# Use Turbopack (faster builds)
./start-dev.sh --turbo

# Allow network access
./start-dev.sh --hostname 0.0.0.0
```

---

## 📋 Features

### 1. Automatic Dependency Management

**Problem:** Forgot to run `npm install` after git pull  
**Solution:** Script checks and installs automatically

```powershell
./start-dev.ps1
# Output:
# ⚠ node_modules not found
# ℹ️ Installing dependencies... (this may take a few minutes)
# ✓ Dependencies installed ✓
```

### 2. Port Availability Check

**Problem:** Port 3000 already in use  
**Solution:** Script finds next available port

```powershell
./start-dev.ps1
# Output:
# ⚠ Port 3000 is already in use
# ℹ️ Switching to available port: 3001
# ✓ Port 3001 is available ✓
```

### 3. Node Version Verification

**Problem:** Wrong Node version causes cryptic errors  
**Solution:** Script validates before starting

```powershell
./start-dev.ps1
# Output:
# ✗ Node.js 18+ required. Current version: v16.14.0
# ℹ️ Update Node.js: https://nodejs.org/
```

### 4. Environment File Check

**Problem:** Missing environment variables cause runtime errors  
**Solution:** Script warns if no .env file found

```powershell
./start-dev.ps1
# Output:
# ⚠ No environment file found
# ℹ️ Consider creating .env.local for environment variables
```

### 5. Auto Browser Launch

**Problem:** Manually opening browser after every restart  
**Solution:** Script can open browser automatically

```powershell
./start-dev.ps1 -OpenBrowser
# Opens http://localhost:3000 after 3 seconds
```

### 6. Turbopack Support

**Problem:** Slow compilation times during development  
**Solution:** Use Turbopack for faster builds

```powershell
./start-dev.ps1 -Turbo
# Uses --turbo flag for Next.js 13+
```

### 7. Network Access

**Problem:** Need to test on mobile devices or other computers  
**Solution:** Bind to 0.0.0.0 for network access

```powershell
./start-dev.ps1 -Hostname 0.0.0.0
# Accessible at http://[your-ip]:3000 from any device on network
```

---

## 🎨 Output Example

```
======================================================================
  🚀 Next.js Development Server Starter
======================================================================

✓ Project root: C:\projects\my-nextjs-app
✓ Next.js project detected

▶ Checking Node.js version...
✓ Node.js v20.10.0 ✓

▶ Checking dependencies...
✓ Dependencies found ✓

▶ Checking environment configuration...
✓ Environment file found: .env.local

▶ Checking port availability...
✓ Port 3000 is available ✓

▶ Preparing dev server...
ℹ️ Using Turbopack for faster builds

Configuration:
  URL:      http://localhost:3000
  Port:     3000
  Hostname: localhost
  Turbopack: Enabled

▶ Starting Next.js dev server...

======================================================================

  ▲ Next.js 14.0.4
  - Local:        http://localhost:3000
  - Experiments (use with caution):
    · turbo

 ✓ Ready in 1.2s
```

---

## 🎯 Use Cases

### Use Case 1: New Developer Onboarding

**Scenario:** New team member clones repository

**Without script:**
```bash
cd project
npm install          # Forgot this step
npm run dev         # Error: node_modules not found
npm install         # Now install
npm run dev         # Works, but manual
```

**With script:**
```powershell
cd project
./start-dev.ps1
# Auto-installs, checks everything, starts server
```

### Use Case 2: After Git Pull

**Scenario:** Team member added new dependency

**Without script:**
```bash
git pull
npm run dev         # Error: Cannot find module 'new-package'
npm install         # Realize need to install
npm run dev         # Works now
```

**With script:**
```powershell
git pull
./start-dev.ps1
# Detects missing deps, installs automatically
```

### Use Case 3: Port Conflicts

**Scenario:** Another dev server running on port 3000

**Without script:**
```bash
npm run dev         # Error: Port 3000 is already in use
lsof -i :3000       # Find process
kill 12345          # Kill it
npm run dev         # Finally works
```

**With script:**
```powershell
./start-dev.ps1
# Automatically finds port 3001 and uses that
```

### Use Case 4: Mobile Testing

**Scenario:** Need to test on physical iPhone

**Without script:**
```bash
npm run dev -- --hostname 0.0.0.0
ifconfig            # Find IP address
# Open http://192.168.1.100:3000 on phone
```

**With script:**
```powershell
./start-dev.ps1 -Hostname 0.0.0.0
# Shows full URL with instructions
```

---

## ⚙️ Configuration

### Parameters (PowerShell)

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `-Port` | int | 3000 | Port number for dev server |
| `-OpenBrowser` | switch | false | Auto-open browser |
| `-Turbo` | switch | false | Use Turbopack |
| `-Hostname` | string | localhost | Bind hostname |
| `-SkipChecks` | switch | false | Skip validation checks |

### Options (Bash)

| Option | Default | Description |
|--------|---------|-------------|
| `--port PORT` | 3000 | Port number for dev server |
| `--open-browser` | false | Auto-open browser |
| `--turbo` | false | Use Turbopack |
| `--hostname HOST` | localhost | Bind hostname |
| `--skip-checks` | false | Skip validation checks |

---

## 🛠️ Advanced Usage

### Combine Multiple Options

```powershell
# PowerShell
./start-dev.ps1 -Port 3001 -OpenBrowser -Turbo

# Bash
./start-dev.sh --port 3001 --open-browser --turbo
```

### Network Access for Team

```powershell
# Start on network-accessible address
./start-dev.ps1 -Hostname 0.0.0.0

# Team members can access at:
# http://your-ip-address:3000
```

### Fast Development Mode

```powershell
# Use Turbopack for fastest possible builds
./start-dev.ps1 -Turbo -OpenBrowser
```

### Skip Checks for Speed

```powershell
# If you know environment is correct
./start-dev.ps1 -SkipChecks
```

---

## 🚨 Troubleshooting

### Issue: Script won't run (PowerShell)

**Cause:** Execution policy restriction

**Solution:**
```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
./start-dev.ps1
```

### Issue: Script won't run (Bash)

**Cause:** Not executable

**Solution:**
```bash
chmod +x start-dev.sh
./start-dev.sh
```

### Issue: Node version error

**Cause:** Node.js < 18

**Solution:**
- Update Node.js: https://nodejs.org/
- Or use nvm: `nvm install 20 && nvm use 20`

### Issue: Port check fails

**Cause:** `Get-NetTCPConnection` not available (non-Windows)

**Solution:** Script will skip port check automatically

### Issue: Can't find available port

**Cause:** Ports 3000-3010 all in use

**Solution:**
```powershell
# Manually specify high port number
./start-dev.ps1 -Port 4000
```

### Issue: Browser doesn't open

**Cause:** No default browser set, or browser opening blocked

**Solution:** Manually open http://localhost:3000

---

## 📝 Customization

### Add to package.json Scripts

```json
{
  "scripts": {
    "dev": "next dev",
    "start:dev": "pwsh ./start-dev.ps1",
    "start:dev:open": "pwsh ./start-dev.ps1 -OpenBrowser"
  }
}
```

Now run with:
```bash
npm run start:dev
npm run start:dev:open
```

### Create Alias (PowerShell)

```powershell
# Add to $PROFILE
function Start-NextDev {
    param([switch]$Open, [int]$Port = 3000)
    & ./start-dev.ps1 -OpenBrowser:$Open -Port $Port
}

# Usage
Start-NextDev
Start-NextDev -Open
Start-NextDev -Port 3001
```

### Create Alias (Bash)

```bash
# Add to ~/.bashrc or ~/.zshrc
alias dev='./start-dev.sh'
alias devo='./start-dev.sh --open-browser'
alias devt='./start-dev.sh --turbo'

# Usage
dev
devo
devt
```

---

## 🔗 Related Arsenal Items

**🔄 Workflow:**
- [Next.js Debug Workflow](https://github.com/ChrisTansey007/ai-workflows-arsenal/blob/main/windsurf/debugging/nextjs-debug-compile.md) - What to do when build fails

**⚙️ Rule:**
- [React Error Rendering](https://github.com/ChrisTansey007/ai-rules-arsenal/blob/main/windsurf/by-framework/react-error-handling.md) - Prevent common React crashes

**💭 Memory:**
- [Next.js App Router Memory](https://github.com/ChrisTansey007/windsurf-memories-arsenal/blob/main/project-types/nextjs-app-router-memory.md) - Complete Next.js project context

**🔗 Example:**
- [Next.js Debugging Example](https://github.com/ChrisTansey007/arsenal-integration-hub/tree/main/examples/nextjs-debugging) - Complete setup example

---

## 💡 Pro Tips

### 1. Always Use This Script
Replace `npm run dev` with this script everywhere:
- Documentation
- Onboarding guides
- README.md

### 2. Commit to Repository
Check this script into version control so team uses it.

### 3. Set as Default
Make it the default way to start dev server in IDE/editor.

### 4. Add to CI/CD
Use in CI for integration tests with specific port.

### 5. Create Shortcuts
Add desktop shortcut or alias for even faster access.

---

## 📊 Benefits

**Before Script:**
- ❌ Manual `npm install` after git pull
- ❌ Port conflicts require manual intervention
- ❌ Wrong Node version causes cryptic errors
- ❌ Forgetting to check .env files
- ❌ Opening browser manually every time

**After Script:**
- ✅ Automatic dependency management
- ✅ Intelligent port handling
- ✅ Clear error messages with solutions
- ✅ Environment validation
- ✅ One command does everything

**Time Saved:**
- New developer setup: 30 minutes → 2 minutes
- After git pull: 5 minutes → 30 seconds
- Port conflicts: 2 minutes → automatic
- Daily development: Countless small frustrations eliminated

---

## 📜 License

MIT License - Use freely in personal or commercial projects.

---

**Happy developing! 🚀**
