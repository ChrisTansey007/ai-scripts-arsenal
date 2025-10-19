# ---
# id: scr.react-vite-setup-ps
# type: script
# title: React Vite Monorepo Setup with ESM Fixes (PowerShell)
# tags: [react, vite, setup, esm, monorepo, automation, windows]
# summary: Automated React Vite project setup with dependency installation, ESM configuration fixes, and comprehensive validation for Windows.
# runner: pwsh
# platforms: [windows, macos, linux]
# requires: [node, npm]
# dangerous: false
# vars:
#   - { name: ProjectPath, required: true, description: "Project root path" }
#   - { name: DryRun, required: false, default: "false", description: "Preview changes without executing" }
#   - { name: SkipInstall, required: false, default: "false", description: "Skip npm install steps" }
#   - { name: AutoFixESM, required: false, default: "true", description: "Automatically fix ESM config files" }
# examples:
#   - "# Dry run to preview changes"
#   - "./setup-react-vite.ps1 -ProjectPath C:\path\to\project -DryRun"
#   - ""
#   - "# Full setup with all steps"
#   - "./setup-react-vite.ps1 -ProjectPath C:\path\to\project"
#   - ""
#   - "# Skip npm install (if already done)"
#   - "./setup-react-vite.ps1 -ProjectPath C:\path\to\project -SkipInstall"
# version: 1
# ---

[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [string]$ProjectPath,
    
    [Parameter(Mandatory=$false)]
    [switch]$DryRun,
    
    [Parameter(Mandatory=$false)]
    [switch]$SkipInstall,
    
    [Parameter(Mandatory=$false)]
    [switch]$NoAutoFixESM
)

# ==========================================
# CONFIGURATION & DEFAULTS
# ==========================================

$ErrorActionPreference = "Stop"
$BackupDir = ".setup-backups-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
$AutoFixESM = -not $NoAutoFixESM

# ==========================================
# HELPER FUNCTIONS
# ==========================================

function Write-Header {
    param([string]$Message)
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Blue
    Write-Host "  $Message" -ForegroundColor Blue
    Write-Host "========================================" -ForegroundColor Blue
}

function Write-Step {
    param([string]$Message)
    Write-Host "✓ $Message" -ForegroundColor Green
}

function Write-Warning-Custom {
    param([string]$Message)
    Write-Host "⚠ $Message" -ForegroundColor Yellow
}

function Write-Error-Custom {
    param([string]$Message)
    Write-Host "✗ $Message" -ForegroundColor Red
}

function Write-Info {
    param([string]$Message)
    Write-Host "ℹ $Message" -ForegroundColor Cyan
}

# ==========================================
# MAIN SCRIPT
# ==========================================

Write-Header "React Vite Setup - Starting"

if ($DryRun) {
    Write-Warning-Custom "DRY RUN MODE - No changes will be made"
}

# ==========================================
# STEP 1: Validate Environment
# ==========================================

Write-Header "Step 1/6: Validate Environment"

# Check if project path exists
if (-not (Test-Path $ProjectPath)) {
    Write-Error-Custom "Project path does not exist: $ProjectPath"
    exit 1
}
Write-Step "Project path exists: $ProjectPath"

# Change to project directory
try {
    Set-Location $ProjectPath
    Write-Step "Changed to project directory"
} catch {
    Write-Error-Custom "Failed to change to project directory: $_"
    exit 1
}

# Check Node.js version
try {
    $NodeVersion = node --version
    Write-Step "Node.js version: $NodeVersion"
    
    # Check if Node version is >= 18
    $NodeMajor = [int]($NodeVersion -replace 'v(\d+)\..*', '$1')
    if ($NodeMajor -lt 18) {
        Write-Warning-Custom "Node.js version should be >= 18.x (current: $NodeVersion)"
    }
} catch {
    Write-Error-Custom "Node.js is not installed or not in PATH"
    exit 1
}

# Check npm version
try {
    $NpmVersion = npm --version
    Write-Step "npm version: $NpmVersion"
} catch {
    Write-Error-Custom "npm is not installed or not in PATH"
    exit 1
}

# Check for package.json
if (-not (Test-Path "package.json")) {
    Write-Error-Custom "No package.json found in project root"
    exit 1
}
Write-Step "Found package.json"

# ==========================================
# STEP 2: Install Root Dependencies
# ==========================================

Write-Header "Step 2/6: Install Root Dependencies"

if ($SkipInstall) {
    Write-Warning-Custom "Skipping root npm install (SkipInstall flag)"
} elseif ($DryRun) {
    Write-Info "[DRY RUN] Would run: npm install"
} else {
    Write-Info "Running npm install in project root..."
    try {
        npm install
        Write-Step "Root dependencies installed successfully"
    } catch {
        Write-Error-Custom "Failed to install root dependencies: $_"
        exit 1
    }
}

# ==========================================
# STEP 3: Detect and Fix ESM Configs
# ==========================================

Write-Header "Step 3/6: Detect and Fix ESM Configuration"

# Check if package.json has "type": "module"
$PackageJson = Get-Content "package.json" -Raw
$HasTypeModule = $PackageJson -match '"type"\s*:\s*"module"'

if (-not $HasTypeModule) {
    Write-Warning-Custom "package.json does not have '`"type`": `"module`"'"
    Write-Info "Vite projects should use ES modules"
} else {
    Write-Step "package.json has '`"type`": `"module`"'"
}

# List of config files to check/fix
$ConfigFiles = @(
    "vite.config.js",
    "postcss.config.js",
    "tailwind.config.js",
    "vitest.config.js",
    "playwright.config.js"
)

# Check for apps/web directory (monorepo structure)
if (Test-Path "apps/web") {
    Write-Info "Detected monorepo structure (apps/web)"
    
    # Add app-specific config files
    foreach ($file in @("vite.config.js", "postcss.config.js", "tailwind.config.js")) {
        $appConfigPath = "apps/web/$file"
        if (Test-Path $appConfigPath) {
            $ConfigFiles += $appConfigPath
        }
    }
}

# Create backup directory
if (-not $DryRun -and $AutoFixESM) {
    New-Item -ItemType Directory -Path $BackupDir -Force | Out-Null
    Write-Step "Created backup directory: $BackupDir"
}

# Check and fix each config file
$FixedCount = 0
foreach ($configFile in $ConfigFiles) {
    if (Test-Path $configFile) {
        $content = Get-Content $configFile -Raw
        
        # Check if file uses module.exports
        if ($content -match 'module\.exports') {
            Write-Warning-Custom "Found CommonJS syntax in $configFile"
            
            if ($AutoFixESM) {
                if ($DryRun) {
                    Write-Info "[DRY RUN] Would convert $configFile to ESM syntax"
                } else {
                    # Backup original file
                    $backupFileName = Split-Path $configFile -Leaf
                    Copy-Item $configFile -Destination "$BackupDir/$backupFileName.bak"
                    
                    # Convert module.exports to export default
                    $newContent = $content -replace 'module\.exports\s*=', 'export default'
                    Set-Content -Path $configFile -Value $newContent -NoNewline
                    
                    Write-Step "Converted $configFile to ESM syntax"
                    $FixedCount++
                }
            } else {
                Write-Info "Auto-fix disabled. Manually convert to ESM or use -NoAutoFixESM"
            }
        } else {
            Write-Step "$configFile already uses ESM syntax"
        }
    }
}

if ($FixedCount -gt 0) {
    Write-Step "Fixed $FixedCount config file(s)"
    Write-Info "Backups saved to: $BackupDir"
}

# ==========================================
# STEP 4: Install App Dependencies
# ==========================================

Write-Header "Step 4/6: Install App Dependencies"

if (Test-Path "apps/web") {
    Push-Location "apps/web"
    
    if ($SkipInstall) {
        Write-Warning-Custom "Skipping app npm install (SkipInstall flag)"
    } elseif ($DryRun) {
        Write-Info "[DRY RUN] Would run: npm install in apps/web"
    } else {
        Write-Info "Running npm install in apps/web..."
        try {
            npm install
            Write-Step "App dependencies installed successfully"
        } catch {
            Write-Error-Custom "Failed to install app dependencies: $_"
            Pop-Location
            exit 1
        }
    }
    
    Pop-Location
} else {
    Write-Info "No apps/web directory found, skipping app install"
}

# ==========================================
# STEP 5: Install Test Dependencies
# ==========================================

Write-Header "Step 5/6: Install Test Dependencies"

if (Test-Path "test-harness") {
    Push-Location "test-harness"
    
    if ($SkipInstall) {
        Write-Warning-Custom "Skipping test harness install (SkipInstall flag)"
    } elseif ($DryRun) {
        Write-Info "[DRY RUN] Would run: npm install in test-harness"
        Write-Info "[DRY RUN] Would run: npx playwright install --with-deps"
    } else {
        Write-Info "Running npm install in test-harness..."
        try {
            npm install
            Write-Step "Test dependencies installed successfully"
        } catch {
            Write-Error-Custom "Failed to install test dependencies: $_"
            Pop-Location
            exit 1
        }
        
        # Install Playwright browsers
        Write-Info "Installing Playwright browsers..."
        try {
            npx playwright install --with-deps
            Write-Step "Playwright browsers installed successfully"
        } catch {
            Write-Warning-Custom "Failed to install Playwright browsers (non-critical)"
        }
    }
    
    Pop-Location
} else {
    Write-Info "No test-harness directory found, skipping test install"
}

# ==========================================
# STEP 6: Verification
# ==========================================

Write-Header "Step 6/6: Verification"

if ($DryRun) {
    Write-Info "[DRY RUN] Skipping verification"
} else {
    Write-Info "Verifying config files syntax..."
    
    $VerificationPassed = $true
    foreach ($configFile in $ConfigFiles) {
        if (Test-Path $configFile) {
            try {
                node --check $configFile 2>$null
                Write-Step "$configFile syntax is valid"
            } catch {
                Write-Error-Custom "$configFile has syntax errors"
                $VerificationPassed = $false
            }
        }
    }
    
    if ($VerificationPassed) {
        Write-Step "All config files passed syntax verification"
    } else {
        Write-Warning-Custom "Some config files have errors, please review"
    }
}

# ==========================================
# COMPLETION SUMMARY
# ==========================================

Write-Header "Setup Complete!"

if ($DryRun) {
    Write-Info "This was a DRY RUN - no changes were made"
    Write-Info "Run without -DryRun to apply changes"
} else {
    Write-Step "Project setup completed successfully"
    
    Write-Host ""
    if (Test-Path "apps/web") {
        Write-Info "To start the dev server:"
        Write-Host "  cd apps/web; npm run dev" -ForegroundColor Blue
    } else {
        Write-Info "To start the dev server:"
        Write-Host "  npm run dev" -ForegroundColor Blue
    }
    
    if ($FixedCount -gt 0) {
        Write-Host ""
        Write-Info "Backups of modified files saved to: $BackupDir"
        Write-Info "To rollback changes, restore from backup directory"
    }
}

Write-Host ""
Write-Step "All done! 🚀"
