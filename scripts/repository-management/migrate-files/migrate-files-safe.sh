#!/bin/bash

# ---
# id: scr.repo-migrate-files-bash
# type: script
# title: Safe File Migration Script (Bash)
# tags: [repo-cleanup, automation, migration, organization]
# summary: Automated file migration with dry-run safety, progress tracking, and rollback support for repository reorganization.
# runner: bash
# platforms: [macos, linux]
# requires: [bash]
# dangerous: true
# vars:
#   - { name: DRY_RUN, required: false, default: "true", description: "Run in preview mode without moving files" }
# examples:
#   - "# Preview migration"
#   - "./migrate-files-safe.sh"
#   - ""
#   - "# Execute migration"
#   - "./migrate-files-safe.sh --execute"
#   - ""
#   - "# With custom base directory"
#   - "./migrate-files-safe.sh --base-dir /path/to/repo"
# version: 1
# ---

#
# Safe file migration script with dry-run, progress tracking, and rollback support.
#
# Description:
#   Migrates files from scattered locations to organized structure with:
#   - Dry-run mode by default (safe preview)
#   - Automatic backup creation
#   - Progress tracking and summary
#   - Existence checks and error handling
#   - Rollback documentation
#
# Usage:
#   ./migrate-files-safe.sh              # Preview mode
#   ./migrate-files-safe.sh --execute    # Execute migration
#   ./migrate-files-safe.sh --help       # Show help
#

set -euo pipefail  # Exit on error, undefined vars, pipe failures

# Configuration
DRY_RUN=true
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKIP_BACKUP=false

# Counters
MOVE_COUNT=0
ERROR_COUNT=0
SKIPPED_COUNT=0

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
GRAY='\033[0;90m'
NC='\033[0m' # No Color

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --execute)
            DRY_RUN=false
            shift
            ;;
        --base-dir)
            BASE_DIR="$2"
            shift 2
            ;;
        --skip-backup)
            SKIP_BACKUP=true
            shift
            ;;
        --help)
            cat << EOF
Safe File Migration Script

Usage:
  $0 [OPTIONS]

Options:
  --execute        Execute migration (default: dry-run)
  --base-dir DIR   Set base directory (default: script location)
  --skip-backup    Skip automatic backup (not recommended)
  --help           Show this help message

Examples:
  $0                      # Preview migration
  $0 --execute            # Execute migration
  $0 --base-dir /path     # Custom directory
EOF
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

# Color output functions
info() {
    echo -e "${CYAN}$1${NC}"
}

success() {
    echo -e "${GREEN}$1${NC}"
}

warning() {
    echo -e "${YELLOW}$1${NC}"
}

error() {
    echo -e "${RED}$1${NC}"
}

gray() {
    echo -e "${GRAY}$1${NC}"
}

# Move file function
move_file() {
    local src="$1"
    local dst="$2"
    local purpose="$3"
    
    local src_path="$BASE_DIR/$src"
    local dst_path="$BASE_DIR/$dst"
    
    # Check if source exists
    if [[ ! -f "$src_path" ]]; then
        warning "  ⚠ Not found: $src"
        ((SKIPPED_COUNT++)) || true
        return
    fi
    
    # Check if destination already exists
    if [[ -f "$dst_path" ]]; then
        warning "  ⚠ Already exists: $dst"
        ((SKIPPED_COUNT++)) || true
        return
    fi
    
    # Perform migration
    if $DRY_RUN; then
        echo -n -e "  ${YELLOW}[DRY RUN]${NC} "
        echo -n "$src"
        echo -n -e " ${GRAY}→${NC} "
        echo "$dst"
        if [[ -n "$purpose" ]]; then
            gray "            Purpose: $purpose"
        fi
    else
        # Create destination directory if needed
        local dst_dir
        dst_dir="$(dirname "$dst_path")"
        if [[ ! -d "$dst_dir" ]]; then
            mkdir -p "$dst_dir"
        fi
        
        # Move the file
        if mv "$src_path" "$dst_path" 2>/dev/null; then
            echo -n -e "  ${GREEN}✓${NC} "
            echo -n "$src"
            echo -n -e " ${GRAY}→${NC} "
            echo "$dst"
            if [[ -n "$purpose" ]]; then
                gray "    Purpose: $purpose"
            fi
            ((MOVE_COUNT++)) || true
        else
            error "  ✗ Failed: $src"
            ((ERROR_COUNT++)) || true
        fi
    fi
}

# Header
echo ""
echo "======================================================================"
info "  📦 Safe File Migration Script (Bash)"
echo "======================================================================"
echo ""

if $DRY_RUN; then
    warning "⚠  DRY RUN MODE - No files will be moved"
    echo ""
else
    info "🚀 LIVE MODE - Files will be moved"
    echo ""
fi

# Create backup if not dry-run and not skipped
if ! $DRY_RUN && ! $SKIP_BACKUP; then
    info "📦 Creating backup..."
    TIMESTAMP=$(date +%Y%m%d-%H%M%S)
    BACKUP_PATH="$(dirname "$BASE_DIR")/repo-backup-$TIMESTAMP"
    
    if cp -r "$BASE_DIR" "$BACKUP_PATH" 2>/dev/null; then
        success "✓ Backup created: $BACKUP_PATH"
        echo ""
    else
        error "✗ Backup failed"
        warning "Aborting migration for safety"
        exit 1
    fi
fi

# ============================================================================
# DOCUMENTATION MIGRATIONS
# ============================================================================

info "📄 DOCUMENTATION"
echo ""

# Example mappings - Customize these for your repository
move_file "README.md" "docs/00-CURRENT/README.md" "Main project documentation"
move_file "CONTRIBUTING.md" "docs/00-CURRENT/CONTRIBUTING.md" "Contribution guidelines"
move_file "CHANGELOG.md" "docs/00-CURRENT/CHANGELOG.md" "Version history"

move_file "SETUP.md" "docs/01-GUIDES/SETUP.md" "Installation and setup guide"
move_file "GETTING-STARTED.md" "docs/01-GUIDES/GETTING-STARTED.md" "Quick start tutorial"
move_file "DEPLOYMENT.md" "docs/01-GUIDES/DEPLOYMENT.md" "Deployment instructions"

move_file "API.md" "docs/02-TECHNICAL/API.md" "API reference documentation"
move_file "ARCHITECTURE.md" "docs/02-TECHNICAL/ARCHITECTURE.md" "System architecture"
move_file "DATABASE.md" "docs/02-TECHNICAL/DATABASE.md" "Database schema"

move_file "RUNBOOK.md" "docs/03-RUNBOOKS/OPERATIONS.md" "Operational procedures"
move_file "TROUBLESHOOTING.md" "docs/03-RUNBOOKS/TROUBLESHOOTING.md" "Problem resolution"
move_file "MONITORING.md" "docs/03-RUNBOOKS/MONITORING.md" "System monitoring"

move_file "ROADMAP.md" "docs/04-PLANNING/ROADMAP.md" "Future plans"
move_file "REQUIREMENTS.md" "docs/04-PLANNING/REQUIREMENTS.md" "Project requirements"

move_file "OLD-README.md" "docs/05-ARCHIVE/OLD-README.md" "Previous readme"

# ============================================================================
# SCRIPT MIGRATIONS
# ============================================================================

echo ""
info "📜 SCRIPTS"
echo ""

# Startup scripts
move_file "start.sh" "scripts/00-STARTUP/start.sh" "Main startup script"
move_file "init.sh" "scripts/00-STARTUP/init.sh" "Initialization script"
move_file "setup.sh" "scripts/00-STARTUP/setup.sh" "Environment setup"

# Development scripts
move_file "dev.sh" "scripts/01-DEVELOPMENT/dev.sh" "Development server"
move_file "watch.sh" "scripts/01-DEVELOPMENT/watch.sh" "File watcher"
move_file "format.sh" "scripts/01-DEVELOPMENT/format.sh" "Code formatter"
move_file "lint.sh" "scripts/01-DEVELOPMENT/lint.sh" "Code linter"

# Database scripts
move_file "migrate.sh" "scripts/02-DATABASE/migrate.sh" "Run migrations"
move_file "seed.sh" "scripts/02-DATABASE/seed.sh" "Seed database"
move_file "backup-db.sh" "scripts/02-DATABASE/backup.sh" "Database backup"
move_file "restore-db.sh" "scripts/02-DATABASE/restore.sh" "Database restore"

# Testing scripts
move_file "test.sh" "scripts/03-TESTING/test-all.sh" "Run all tests"
move_file "test-unit.sh" "scripts/03-TESTING/test-unit.sh" "Unit tests"
move_file "test-integration.sh" "scripts/03-TESTING/test-integration.sh" "Integration tests"
move_file "test-e2e.sh" "scripts/03-TESTING/test-e2e.sh" "End-to-end tests"
move_file "coverage.sh" "scripts/03-TESTING/coverage.sh" "Test coverage report"

# Build scripts
move_file "build.sh" "scripts/04-BUILD/build.sh" "Build application"
move_file "bundle.sh" "scripts/04-BUILD/bundle.sh" "Bundle assets"
move_file "compile.sh" "scripts/04-BUILD/compile.sh" "Compile code"
move_file "package.sh" "scripts/04-BUILD/package.sh" "Package for distribution"

# Deployment scripts
move_file "deploy.sh" "scripts/05-DEPLOYMENT/deploy.sh" "Deploy to production"
move_file "deploy-staging.sh" "scripts/05-DEPLOYMENT/deploy-staging.sh" "Deploy to staging"
move_file "rollback.sh" "scripts/05-DEPLOYMENT/rollback.sh" "Rollback deployment"
move_file "release.sh" "scripts/05-DEPLOYMENT/release.sh" "Create release"

# Operations scripts
move_file "monitor.sh" "scripts/06-OPERATIONS/monitor.sh" "System monitoring"
move_file "logs.sh" "scripts/06-OPERATIONS/logs.sh" "View logs"
move_file "health-check.sh" "scripts/06-OPERATIONS/health-check.sh" "Health check"

# Utility scripts
move_file "clean.sh" "scripts/07-UTILITIES/clean.sh" "Clean build artifacts"
move_file "install-deps.sh" "scripts/07-UTILITIES/install-deps.sh" "Install dependencies"
move_file "update-deps.sh" "scripts/07-UTILITIES/update-deps.sh" "Update dependencies"

# ============================================================================
# SUMMARY
# ============================================================================

echo ""
echo "======================================================================"
info "  📊 Migration Summary"
echo "======================================================================"
echo ""

if $DRY_RUN; then
    info "Total files to migrate: $(find "$BASE_DIR" -maxdepth 1 -type f | wc -l)"
    warning "Skipped (not found): $SKIPPED_COUNT"
    echo ""
    warning "This was a DRY RUN - no files were moved"
    echo ""
    info "To execute for real:"
    echo "  $0 --execute"
else
    success "✓ Successfully moved: $MOVE_COUNT files"
    if [[ $ERROR_COUNT -gt 0 ]]; then
        error "✗ Errors: $ERROR_COUNT"
    fi
    if [[ $SKIPPED_COUNT -gt 0 ]]; then
        warning "⚠ Skipped: $SKIPPED_COUNT"
    fi
    echo ""
    success "Migration complete!"
    echo ""
    info "Next steps:"
    echo "  1. Verify file locations"
    echo "  2. Update import paths"
    echo "  3. Test application"
    echo "  4. Commit changes"
fi

echo ""

# Export migration log
LOG_PATH="$BASE_DIR/migration-log-$(date +%Y%m%d-%H%M%S).txt"
echo "Migration completed at $(date)" > "$LOG_PATH"
echo "Dry run: $DRY_RUN" >> "$LOG_PATH"
echo "Files moved: $MOVE_COUNT" >> "$LOG_PATH"
echo "Errors: $ERROR_COUNT" >> "$LOG_PATH"
echo "Skipped: $SKIPPED_COUNT" >> "$LOG_PATH"
info "Migration log saved: $LOG_PATH"
echo ""

# Rollback instructions
if ! $DRY_RUN; then
    info "💡 To rollback if needed:"
    echo "  1. Stop your application"
    if ! $SKIP_BACKUP; then
        echo "  2. Restore from backup: cp -r $BACKUP_PATH/* $BASE_DIR/"
    fi
    echo "  3. Or use git: git checkout HEAD -- ."
    echo "  4. Restart your application"
    echo ""
fi

exit 0
