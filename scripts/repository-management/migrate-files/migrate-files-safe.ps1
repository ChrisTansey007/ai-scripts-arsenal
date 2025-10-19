# ---
# id: scr.repo-migrate-files
# type: script
# title: Safe File Migration Script
# tags: [repo-cleanup, automation, migration, organization]
# summary: Automated file migration with dry-run safety, progress tracking, and rollback support for repository reorganization.
# runner: pwsh
# platforms: [windows, macos, linux]
# requires: [pwsh]
# dangerous: true
# vars:
#   - { name: DryRun, required: false, default: true, description: "Run in preview mode without moving files" }
# examples:
#   - "# Preview migration"
#   - "./migrate-files-safe.ps1"
#   - ""
#   - "# Execute migration"
#   - "./migrate-files-safe.ps1 -DryRun:$false"
#   - ""
#   - "# With custom base directory"
#   - "./migrate-files-safe.ps1 -BaseDir /path/to/repo"
# version: 1
# ---

<#
.SYNOPSIS
    Safe file migration script with dry-run, progress tracking, and rollback support.

.DESCRIPTION
    Migrates files from scattered locations to organized structure with:
    - Dry-run mode by default (safe preview)
    - Source → Destination → Purpose documentation
    - Automatic backup creation
    - Progress tracking and summary
    - Existence checks and error handling
    - Rollback documentation

.PARAMETER DryRun
    Run in preview mode without actually moving files (default: true)

.PARAMETER BaseDir
    Base directory for the repository (default: script location)

.PARAMETER SkipBackup
    Skip automatic backup creation (not recommended)

.EXAMPLE
    ./migrate-files-safe.ps1
    Preview migration without moving files

.EXAMPLE
    ./migrate-files-safe.ps1 -DryRun:$false
    Execute migration after reviewing dry-run

.EXAMPLE
    ./migrate-files-safe.ps1 -BaseDir /path/to/repo
    Run migration in specific directory

.NOTES
    Author: Arsenal Scripts
    Version: 1.0
    Requires: PowerShell 5.1+ or PowerShell Core
#>

param(
    [switch]$DryRun = $true,
    [string]$BaseDir = $PSScriptRoot,
    [switch]$SkipBackup
)

$ErrorActionPreference = "Stop"
$script:moveCount = 0
$script:errorCount = 0
$script:skippedCount = 0
$script:migrations = @()

# Color output functions
function Write-Info($message) {
    Write-Host $message -ForegroundColor Cyan
}

function Write-Success($message) {
    Write-Host $message -ForegroundColor Green
}

function Write-Warning($message) {
    Write-Host $message -ForegroundColor Yellow
}

function Write-Error($message) {
    Write-Host $message -ForegroundColor Red
}

# Main migration function
function Move-File {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Source,
        
        [Parameter(Mandatory=$true)]
        [string]$Destination,
        
        [Parameter(Mandatory=$false)]
        [string]$Purpose = ""
    )
    
    $srcPath = Join-Path $BaseDir $Source
    $dstPath = Join-Path $BaseDir $Destination
    
    # Track migration
    $script:migrations += [PSCustomObject]@{
        Source = $Source
        Destination = $Destination
        Purpose = $Purpose
        Status = "Pending"
    }
    
    # Check if source exists
    if (-not (Test-Path $srcPath)) {
        Write-Warning "  ⚠ Not found: $Source"
        $script:skippedCount++
        $script:migrations[-1].Status = "Skipped"
        return
    }
    
    # Check if destination already exists
    if (Test-Path $dstPath) {
        Write-Warning "  ⚠ Already exists: $Destination"
        $script:skippedCount++
        $script:migrations[-1].Status = "Exists"
        return
    }
    
    # Perform migration
    if ($DryRun) {
        Write-Host "  [DRY RUN] " -NoNewline -ForegroundColor Yellow
        Write-Host "$Source" -NoNewline
        Write-Host " → " -NoNewline -ForegroundColor Gray
        Write-Host "$Destination"
        if ($Purpose) {
            Write-Host "            Purpose: " -NoNewline -ForegroundColor Gray
            Write-Host $Purpose -ForegroundColor DarkGray
        }
        $script:migrations[-1].Status = "Preview"
    } else {
        try {
            # Create destination directory if needed
            $dstDir = Split-Path $dstPath -Parent
            if (-not (Test-Path $dstDir)) {
                New-Item -ItemType Directory -Path $dstDir -Force | Out-Null
            }
            
            # Move the file
            Move-Item -Path $srcPath -Destination $dstPath -Force
            
            Write-Host "  ✓ " -NoNewline -ForegroundColor Green
            Write-Host "$Source" -NoNewline
            Write-Host " → " -NoNewline -ForegroundColor Gray
            Write-Host "$Destination"
            if ($Purpose) {
                Write-Host "    Purpose: " -NoNewline -ForegroundColor Gray
                Write-Host $Purpose -ForegroundColor DarkGray
            }
            
            $script:moveCount++
            $script:migrations[-1].Status = "Success"
            
        } catch {
            Write-Error "  ✗ Failed: $Source - $($_.Exception.Message)"
            $script:errorCount++
            $script:migrations[-1].Status = "Error"
        }
    }
}

# Header
Write-Host "`n" + "="*70 -ForegroundColor Cyan
Write-Info "  📦 Safe File Migration Script"
Write-Host "="*70 -ForegroundColor Cyan
Write-Host ""

if ($DryRun) {
    Write-Warning "⚠  DRY RUN MODE - No files will be moved"
    Write-Host ""
} else {
    Write-Info "🚀 LIVE MODE - Files will be moved"
    Write-Host ""
}

# Create backup if not dry-run and not skipped
if (-not $DryRun -and -not $SkipBackup) {
    Write-Info "📦 Creating backup..."
    $timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
    $backupPath = Join-Path (Split-Path $BaseDir -Parent) "repo-backup-$timestamp"
    
    try {
        Copy-Item -Path $BaseDir -Destination $backupPath -Recurse -Force
        Write-Success "✓ Backup created: $backupPath"
        Write-Host ""
    } catch {
        Write-Error "✗ Backup failed: $($_.Exception.Message)"
        Write-Warning "Aborting migration for safety"
        exit 1
    }
}

# ============================================================================
# DOCUMENTATION MIGRATIONS
# ============================================================================

Write-Info "📄 DOCUMENTATION"
Write-Host ""

# Example mappings - Customize these for your repository
Move-File "README.md" "docs/00-CURRENT/README.md" "Main project documentation"
Move-File "CONTRIBUTING.md" "docs/00-CURRENT/CONTRIBUTING.md" "Contribution guidelines"
Move-File "CHANGELOG.md" "docs/00-CURRENT/CHANGELOG.md" "Version history"

Move-File "SETUP.md" "docs/01-GUIDES/SETUP.md" "Installation and setup guide"
Move-File "GETTING-STARTED.md" "docs/01-GUIDES/GETTING-STARTED.md" "Quick start tutorial"
Move-File "DEPLOYMENT.md" "docs/01-GUIDES/DEPLOYMENT.md" "Deployment instructions"

Move-File "API.md" "docs/02-TECHNICAL/API.md" "API reference documentation"
Move-File "ARCHITECTURE.md" "docs/02-TECHNICAL/ARCHITECTURE.md" "System architecture"
Move-File "DATABASE.md" "docs/02-TECHNICAL/DATABASE.md" "Database schema"

Move-File "RUNBOOK.md" "docs/03-RUNBOOKS/OPERATIONS.md" "Operational procedures"
Move-File "TROUBLESHOOTING.md" "docs/03-RUNBOOKS/TROUBLESHOOTING.md" "Problem resolution"
Move-File "MONITORING.md" "docs/03-RUNBOOKS/MONITORING.md" "System monitoring"

Move-File "ROADMAP.md" "docs/04-PLANNING/ROADMAP.md" "Future plans"
Move-File "REQUIREMENTS.md" "docs/04-PLANNING/REQUIREMENTS.md" "Project requirements"

Move-File "docs-old/" "docs/05-ARCHIVE/legacy-docs/" "Historical documentation"
Move-File "OLD-README.md" "docs/05-ARCHIVE/OLD-README.md" "Previous readme"

# ============================================================================
# SCRIPT MIGRATIONS
# ============================================================================

Write-Host ""
Write-Info "📜 SCRIPTS"
Write-Host ""

# Startup scripts
Move-File "start.ps1" "scripts/00-STARTUP/start.ps1" "Main startup script"
Move-File "start.sh" "scripts/00-STARTUP/start.sh" "Main startup script (bash)"
Move-File "init.ps1" "scripts/00-STARTUP/init.ps1" "Initialization script"
Move-File "setup.ps1" "scripts/00-STARTUP/setup.ps1" "Environment setup"

# Development scripts
Move-File "dev.ps1" "scripts/01-DEVELOPMENT/dev.ps1" "Development server"
Move-File "watch.ps1" "scripts/01-DEVELOPMENT/watch.ps1" "File watcher"
Move-File "format.ps1" "scripts/01-DEVELOPMENT/format.ps1" "Code formatter"
Move-File "lint.ps1" "scripts/01-DEVELOPMENT/lint.ps1" "Code linter"

# Database scripts
Move-File "migrate.ps1" "scripts/02-DATABASE/migrate.ps1" "Run migrations"
Move-File "seed.ps1" "scripts/02-DATABASE/seed.ps1" "Seed database"
Move-File "backup-db.ps1" "scripts/02-DATABASE/backup.ps1" "Database backup"
Move-File "restore-db.ps1" "scripts/02-DATABASE/restore.ps1" "Database restore"

# Testing scripts
Move-File "test.ps1" "scripts/03-TESTING/test-all.ps1" "Run all tests"
Move-File "test-unit.ps1" "scripts/03-TESTING/test-unit.ps1" "Unit tests"
Move-File "test-integration.ps1" "scripts/03-TESTING/test-integration.ps1" "Integration tests"
Move-File "test-e2e.ps1" "scripts/03-TESTING/test-e2e.ps1" "End-to-end tests"
Move-File "coverage.ps1" "scripts/03-TESTING/coverage.ps1" "Test coverage report"

# Build scripts
Move-File "build.ps1" "scripts/04-BUILD/build.ps1" "Build application"
Move-File "bundle.ps1" "scripts/04-BUILD/bundle.ps1" "Bundle assets"
Move-File "compile.ps1" "scripts/04-BUILD/compile.ps1" "Compile code"
Move-File "package.ps1" "scripts/04-BUILD/package.ps1" "Package for distribution"

# Deployment scripts
Move-File "deploy.ps1" "scripts/05-DEPLOYMENT/deploy.ps1" "Deploy to production"
Move-File "deploy-staging.ps1" "scripts/05-DEPLOYMENT/deploy-staging.ps1" "Deploy to staging"
Move-File "rollback.ps1" "scripts/05-DEPLOYMENT/rollback.ps1" "Rollback deployment"
Move-File "release.ps1" "scripts/05-DEPLOYMENT/release.ps1" "Create release"

# Operations scripts
Move-File "monitor.ps1" "scripts/06-OPERATIONS/monitor.ps1" "System monitoring"
Move-File "logs.ps1" "scripts/06-OPERATIONS/logs.ps1" "View logs"
Move-File "health-check.ps1" "scripts/06-OPERATIONS/health-check.ps1" "Health check"

# Utility scripts
Move-File "clean.ps1" "scripts/07-UTILITIES/clean.ps1" "Clean build artifacts"
Move-File "install-deps.ps1" "scripts/07-UTILITIES/install-deps.ps1" "Install dependencies"
Move-File "update-deps.ps1" "scripts/07-UTILITIES/update-deps.ps1" "Update dependencies"

# Archive old scripts
Move-File "old-scripts/" "scripts/08-ARCHIVE/legacy-scripts/" "Deprecated scripts"

# ============================================================================
# SUMMARY
# ============================================================================

Write-Host ""
Write-Host "="*70 -ForegroundColor Cyan
Write-Info "  📊 Migration Summary"
Write-Host "="*70 -ForegroundColor Cyan
Write-Host ""

if ($DryRun) {
    Write-Info "Total files to migrate: $($script:migrations.Count)"
    Write-Warning "Skipped (not found): $script:skippedCount"
    Write-Host ""
    Write-Warning "This was a DRY RUN - no files were moved"
    Write-Host ""
    Write-Info "To execute for real:"
    Write-Host "  ./migrate-files-safe.ps1 -DryRun:`$false"
} else {
    Write-Success "✓ Successfully moved: $script:moveCount files"
    if ($script:errorCount -gt 0) {
        Write-Error "✗ Errors: $script:errorCount"
    }
    if ($script:skippedCount -gt 0) {
        Write-Warning "⚠ Skipped: $script:skippedCount"
    }
    Write-Host ""
    Write-Success "Migration complete!"
    Write-Host ""
    Write-Info "Next steps:"
    Write-Host "  1. Verify file locations"
    Write-Host "  2. Update import paths"
    Write-Host "  3. Test application"
    Write-Host "  4. Commit changes"
}

Write-Host ""

# Export migration log
$logPath = Join-Path $BaseDir "migration-log-$(Get-Date -Format 'yyyyMMdd-HHmmss').json"
$script:migrations | ConvertTo-Json -Depth 10 | Out-File $logPath
Write-Info "Migration log saved: $logPath"
Write-Host ""

# Rollback instructions
if (-not $DryRun) {
    Write-Info "💡 To rollback if needed:"
    Write-Host "  1. Stop your application"
    if (-not $SkipBackup) {
        Write-Host "  2. Restore from backup: Copy-Item -Path '$backupPath\*' -Destination '$BaseDir' -Recurse -Force"
    }
    Write-Host "  3. Or use git: git checkout HEAD -- ."
    Write-Host "  4. Restart your application"
    Write-Host ""
}

exit 0
