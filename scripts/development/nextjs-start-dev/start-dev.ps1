# ---
# id: scr.nextjs-start-dev
# type: script
# title: Next.js Development Server Starter
# tags: [nextjs, dev-server, development, automation]
# summary: Smart Next.js dev server starter with dependency check, port management, Node version verification, and auto-browser launch.
# runner: pwsh
# platforms: [windows, macos, linux]
# requires: [node, npm]
# dangerous: false
# vars:
#   - { name: Port, required: false, default: "3000", description: "Port number for dev server" }
#   - { name: OpenBrowser, required: false, default: "false", description: "Automatically open browser" }
#   - { name: Turbo, required: false, default: "false", description: "Use Turbopack for faster builds" }
#   - { name: Hostname, required: false, default: "localhost", description: "Hostname to bind to" }
# examples:
#   - "# Start with defaults (port 3000)"
#   - "./start-dev.ps1"
#   - ""
#   - "# Start on custom port and open browser"
#   - "./start-dev.ps1 -Port 3001 -OpenBrowser"
#   - ""
#   - "# Use Turbopack for faster builds"
#   - "./start-dev.ps1 -Turbo"
#   - ""
#   - "# Bind to 0.0.0.0 for network access"
#   - "./start-dev.ps1 -Hostname 0.0.0.0"
# version: 1
# ---

<#
.SYNOPSIS
    Smart Next.js development server starter with automated checks and setup.

.DESCRIPTION
    Starts Next.js development server with:
    - Automatic dependency installation if missing
    - Port availability checking
    - Node version verification
    - Environment file checking
    - Optional browser auto-launch
    - Turbopack support
    - Clear, colorful output

.PARAMETER Port
    Port number for dev server (default: 3000)

.PARAMETER OpenBrowser
    Automatically open browser after server starts

.PARAMETER Turbo
    Use Turbopack for faster builds (Next.js 13+)

.PARAMETER Hostname
    Hostname to bind to (default: localhost, use 0.0.0.0 for network access)

.PARAMETER SkipChecks
    Skip Node version and environment checks

.EXAMPLE
    ./start-dev.ps1
    Start dev server on default port 3000

.EXAMPLE
    ./start-dev.ps1 -Port 3001 -OpenBrowser
    Start on port 3001 and open browser automatically

.EXAMPLE
    ./start-dev.ps1 -Turbo
    Start with Turbopack for faster builds

.EXAMPLE
    ./start-dev.ps1 -Hostname 0.0.0.0
    Start and allow network access

.NOTES
    Author: Arsenal Scripts
    Version: 1.0
    Requires: Node.js 18+, npm
#>

param(
    [int]$Port = 3000,
    [switch]$OpenBrowser,
    [switch]$Turbo,
    [string]$Hostname = "localhost",
    [switch]$SkipChecks
)

$ErrorActionPreference = "Stop"

# Colors
$script:colors = @{
    Success = "Green"
    Warning = "Yellow"
    Error = "Red"
    Info = "Cyan"
    Muted = "Gray"
}

function Write-StatusMessage {
    param(
        [string]$Message,
        [string]$Type = "Info",
        [string]$Icon = "ℹ️"
    )
    
    $color = $script:colors[$Type]
    Write-Host "$Icon " -NoNewline -ForegroundColor $color
    Write-Host $Message -ForegroundColor $color
}

function Write-Step {
    param([string]$Message)
    Write-Host "`n▶ " -NoNewline -ForegroundColor Cyan
    Write-Host $Message -ForegroundColor White
}

function Write-Success {
    param([string]$Message)
    Write-StatusMessage $Message "Success" "✓"
}

function Write-Warning {
    param([string]$Message)
    Write-StatusMessage $Message "Warning" "⚠"
}

function Write-ErrorMsg {
    param([string]$Message)
    Write-StatusMessage $Message "Error" "✗"
}

function Write-Info {
    param([string]$Message)
    Write-StatusMessage $Message "Info" "ℹ️"
}

# Header
Write-Host "`n" + "="*70 -ForegroundColor Cyan
Write-Host "  🚀 Next.js Development Server Starter" -ForegroundColor Cyan
Write-Host "="*70 -ForegroundColor Cyan
Write-Host ""

# Navigate to script directory
$projectRoot = Split-Path -Parent $PSScriptRoot
if (Test-Path "$projectRoot/package.json") {
    Set-Location $projectRoot
    Write-Success "Project root: $projectRoot"
} else {
    Write-ErrorMsg "No package.json found. Run from Next.js project root."
    exit 1
}

# Check if this is a Next.js project
$packageJson = Get-Content "package.json" -Raw | ConvertFrom-Json
if (-not ($packageJson.dependencies."next" -or $packageJson.devDependencies."next")) {
    Write-ErrorMsg "This doesn't appear to be a Next.js project (no next dependency)"
    exit 1
}

Write-Success "Next.js project detected"

# Node version check
if (-not $SkipChecks) {
    Write-Step "Checking Node.js version..."
    
    try {
        $nodeVersion = node --version
        if ($nodeVersion -match "v(\d+)\.(\d+)\.(\d+)") {
            $major = [int]$matches[1]
            $minor = [int]$matches[2]
            
            if ($major -lt 18) {
                Write-ErrorMsg "Node.js 18+ required. Current version: $nodeVersion"
                Write-Info "Update Node.js: https://nodejs.org/"
                exit 1
            }
            
            Write-Success "Node.js $nodeVersion ✓"
        }
    } catch {
        Write-ErrorMsg "Node.js not found. Install from https://nodejs.org/"
        exit 1
    }
}

# Check for dependencies
Write-Step "Checking dependencies..."

if (-not (Test-Path "node_modules")) {
    Write-Warning "node_modules not found"
    Write-Info "Installing dependencies... (this may take a few minutes)"
    
    try {
        npm install --loglevel=error
        Write-Success "Dependencies installed ✓"
    } catch {
        Write-ErrorMsg "Failed to install dependencies"
        Write-Info "Try running: npm install"
        exit 1
    }
} else {
    Write-Success "Dependencies found ✓"
}

# Check for environment files
if (-not $SkipChecks) {
    Write-Step "Checking environment configuration..."
    
    $envFiles = @(".env.local", ".env.development.local", ".env")
    $foundEnv = $false
    
    foreach ($envFile in $envFiles) {
        if (Test-Path $envFile) {
            Write-Success "Environment file found: $envFile"
            $foundEnv = $true
            break
        }
    }
    
    if (-not $foundEnv) {
        Write-Warning "No environment file found"
        Write-Info "Consider creating .env.local for environment variables"
    }
}

# Check if port is available
Write-Step "Checking port availability..."

try {
    $portInUse = Get-NetTCPConnection -LocalPort $Port -State Listen -ErrorAction SilentlyContinue
    
    if ($portInUse) {
        Write-Warning "Port $Port is already in use"
        
        # Try to find next available port
        $newPort = $Port
        $maxAttempts = 10
        $attempts = 0
        
        while ($portInUse -and $attempts -lt $maxAttempts) {
            $newPort++
            $attempts++
            $portInUse = Get-NetTCPConnection -LocalPort $newPort -State Listen -ErrorAction SilentlyContinue
        }
        
        if (-not $portInUse) {
            Write-Info "Switching to available port: $newPort"
            $Port = $newPort
        } else {
            Write-ErrorMsg "Could not find available port"
            Write-Info "Stop the process using port $Port or specify different port with -Port parameter"
            exit 1
        }
    } else {
        Write-Success "Port $Port is available ✓"
    }
} catch {
    # On non-Windows or if command fails, skip port check
    Write-Info "Port check skipped (not available on this platform)"
}

# Build dev server command
Write-Step "Preparing dev server..."

$devCommand = "npm run dev"
$devArgs = @()

# Add port if not default
if ($Port -ne 3000) {
    $devArgs += "--port $Port"
}

# Add hostname if not default
if ($Hostname -ne "localhost") {
    $devArgs += "--hostname $Hostname"
}

# Add turbo flag
if ($Turbo) {
    $devArgs += "--turbo"
    Write-Info "Using Turbopack for faster builds"
}

# Combine arguments
if ($devArgs.Count -gt 0) {
    $devCommand += " -- " + ($devArgs -join " ")
}

# Display configuration
Write-Host ""
Write-Host "Configuration:" -ForegroundColor White
Write-Host "  URL:      " -NoNewline -ForegroundColor Gray
Write-Host "http://$Hostname:$Port" -ForegroundColor Cyan
Write-Host "  Port:     " -NoNewline -ForegroundColor Gray
Write-Host $Port -ForegroundColor White
Write-Host "  Hostname: " -NoNewline -ForegroundColor Gray
Write-Host $Hostname -ForegroundColor White
if ($Turbo) {
    Write-Host "  Turbopack:" -NoNewline -ForegroundColor Gray
    Write-Host " Enabled" -ForegroundColor Green
}
Write-Host ""

# Start server
Write-Step "Starting Next.js dev server..."
Write-Host ""
Write-Host "="*70 -ForegroundColor Gray
Write-Host ""

# Open browser if requested
if ($OpenBrowser) {
    Start-Job -ScriptBlock {
        param($url)
        Start-Sleep -Seconds 3
        Start-Process $url
    } -ArgumentList "http://$Hostname:$Port" | Out-Null
    
    Write-Info "Browser will open automatically in 3 seconds..."
}

# Execute dev command
try {
    Invoke-Expression $devCommand
} catch {
    Write-Host ""
    Write-ErrorMsg "Dev server crashed"
    Write-Info "Error: $($_.Exception.Message)"
    exit 1
}
