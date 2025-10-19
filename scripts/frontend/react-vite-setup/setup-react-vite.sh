#!/bin/bash

# ---
# id: scr.react-vite-setup
# type: script
# title: React Vite Monorepo Setup with ESM Fixes
# tags: [react, vite, setup, esm, monorepo, automation]
# summary: Automated React Vite project setup with dependency installation, ESM configuration fixes, and comprehensive validation.
# runner: bash
# platforms: [macos, linux]
# requires: [node, npm]
# dangerous: false
# vars:
#   - { name: PROJECT_PATH, required: true, description: "Project root path" }
#   - { name: DRY_RUN, required: false, default: "false", description: "Preview changes without executing" }
#   - { name: SKIP_INSTALL, required: false, default: "false", description: "Skip npm install steps" }
#   - { name: AUTO_FIX_ESM, required: false, default: "true", description: "Automatically fix ESM config files" }
# examples:
#   - "# Dry run to preview changes"
#   - "./setup-react-vite.sh --project-path /path/to/project --dry-run"
#   - ""
#   - "# Full setup with all steps"
#   - "./setup-react-vite.sh --project-path /path/to/project"
#   - ""
#   - "# Skip npm install (if already done)"
#   - "./setup-react-vite.sh --project-path /path/to/project --skip-install"
# version: 1
# ---

set -euo pipefail

# ==========================================
# CONFIGURATION & DEFAULTS
# ==========================================

PROJECT_PATH=""
DRY_RUN=false
SKIP_INSTALL=false
AUTO_FIX_ESM=true
BACKUP_DIR=".setup-backups-$(date +%Y%m%d-%H%M%S)"

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# ==========================================
# HELPER FUNCTIONS
# ==========================================

print_header() {
    echo ""
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}  $1${NC}"
    echo -e "${BLUE}========================================${NC}"
}

print_step() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

# ==========================================
# PARSE ARGUMENTS
# ==========================================

while [[ $# -gt 0 ]]; do
    case $1 in
        --project-path)
            PROJECT_PATH="$2"
            shift 2
            ;;
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --skip-install)
            SKIP_INSTALL=true
            shift
            ;;
        --no-auto-fix-esm)
            AUTO_FIX_ESM=false
            shift
            ;;
        -h|--help)
            echo "Usage: $0 --project-path <path> [options]"
            echo ""
            echo "Options:"
            echo "  --project-path PATH    Project root directory (required)"
            echo "  --dry-run              Preview changes without executing"
            echo "  --skip-install         Skip npm install steps"
            echo "  --no-auto-fix-esm      Don't automatically fix ESM configs"
            echo "  -h, --help             Show this help message"
            exit 0
            ;;
        *)
            print_error "Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

# Validate required arguments
if [[ -z "$PROJECT_PATH" ]]; then
    print_error "Missing required argument: --project-path"
    echo "Use --help for usage information"
    exit 1
fi

# ==========================================
# MAIN SCRIPT
# ==========================================

print_header "React Vite Setup - Starting"

if [[ "$DRY_RUN" == true ]]; then
    print_warning "DRY RUN MODE - No changes will be made"
fi

# ==========================================
# STEP 1: Validate Environment
# ==========================================

print_header "Step 1/6: Validate Environment"

# Check if project path exists
if [[ ! -d "$PROJECT_PATH" ]]; then
    print_error "Project path does not exist: $PROJECT_PATH"
    exit 1
fi
print_step "Project path exists: $PROJECT_PATH"

# Change to project directory
cd "$PROJECT_PATH" || exit 1
print_step "Changed to project directory"

# Check Node.js version
if ! command -v node &> /dev/null; then
    print_error "Node.js is not installed"
    exit 1
fi

NODE_VERSION=$(node --version)
print_step "Node.js version: $NODE_VERSION"

# Check if Node version is >= 18
NODE_MAJOR=$(echo "$NODE_VERSION" | cut -d'.' -f1 | tr -d 'v')
if [[ $NODE_MAJOR -lt 18 ]]; then
    print_warning "Node.js version should be >= 18.x (current: $NODE_VERSION)"
fi

# Check npm version
if ! command -v npm &> /dev/null; then
    print_error "npm is not installed"
    exit 1
fi

NPM_VERSION=$(npm --version)
print_step "npm version: $NPM_VERSION"

# Check for package.json
if [[ ! -f "package.json" ]]; then
    print_error "No package.json found in project root"
    exit 1
fi
print_step "Found package.json"

# ==========================================
# STEP 2: Install Root Dependencies
# ==========================================

print_header "Step 2/6: Install Root Dependencies"

if [[ "$SKIP_INSTALL" == true ]]; then
    print_warning "Skipping root npm install (--skip-install flag)"
elif [[ "$DRY_RUN" == true ]]; then
    print_info "[DRY RUN] Would run: npm install"
else
    print_info "Running npm install in project root..."
    if npm install; then
        print_step "Root dependencies installed successfully"
    else
        print_error "Failed to install root dependencies"
        exit 1
    fi
fi

# ==========================================
# STEP 3: Detect and Fix ESM Configs
# ==========================================

print_header "Step 3/6: Detect and Fix ESM Configuration"

# Check if package.json has "type": "module"
HAS_TYPE_MODULE=$(grep -c '"type".*:.*"module"' package.json || true)

if [[ $HAS_TYPE_MODULE -eq 0 ]]; then
    print_warning "package.json does not have '\"type\": \"module\"'"
    print_info "Vite projects should use ES modules"
else
    print_step "package.json has '\"type\": \"module\"'"
fi

# List of config files to check/fix
CONFIG_FILES=(
    "vite.config.js"
    "postcss.config.js"
    "tailwind.config.js"
    "vitest.config.js"
    "playwright.config.js"
)

# Check for apps/web directory (monorepo structure)
if [[ -d "apps/web" ]]; then
    print_info "Detected monorepo structure (apps/web)"
    
    # Add app-specific config files
    for file in "${CONFIG_FILES[@]}"; do
        if [[ -f "apps/web/$file" ]]; then
            CONFIG_FILES+=("apps/web/$file")
        fi
    done
fi

# Create backup directory
if [[ "$DRY_RUN" == false ]] && [[ "$AUTO_FIX_ESM" == true ]]; then
    mkdir -p "$BACKUP_DIR"
    print_step "Created backup directory: $BACKUP_DIR"
fi

# Check and fix each config file
FIXED_COUNT=0
for config_file in "${CONFIG_FILES[@]}"; do
    if [[ -f "$config_file" ]]; then
        # Check if file uses module.exports
        if grep -q "module\.exports" "$config_file"; then
            print_warning "Found CommonJS syntax in $config_file"
            
            if [[ "$AUTO_FIX_ESM" == true ]]; then
                if [[ "$DRY_RUN" == true ]]; then
                    print_info "[DRY RUN] Would convert $config_file to ESM syntax"
                else
                    # Backup original file
                    cp "$config_file" "$BACKUP_DIR/$(basename "$config_file").bak"
                    
                    # Convert module.exports to export default
                    sed -i.tmp 's/module\.exports\s*=/export default/g' "$config_file"
                    rm -f "${config_file}.tmp"
                    
                    print_step "Converted $config_file to ESM syntax"
                    FIXED_COUNT=$((FIXED_COUNT + 1))
                fi
            else
                print_info "Auto-fix disabled. Manually convert to ESM or use --no-auto-fix-esm"
            fi
        else
            print_step "$config_file already uses ESM syntax (or not found)"
        fi
    fi
done

if [[ $FIXED_COUNT -gt 0 ]]; then
    print_step "Fixed $FIXED_COUNT config file(s)"
    print_info "Backups saved to: $BACKUP_DIR"
fi

# ==========================================
# STEP 4: Install App Dependencies
# ==========================================

print_header "Step 4/6: Install App Dependencies"

if [[ -d "apps/web" ]]; then
    cd "apps/web" || exit 1
    
    if [[ "$SKIP_INSTALL" == true ]]; then
        print_warning "Skipping app npm install (--skip-install flag)"
    elif [[ "$DRY_RUN" == true ]]; then
        print_info "[DRY RUN] Would run: npm install in apps/web"
    else
        print_info "Running npm install in apps/web..."
        if npm install; then
            print_step "App dependencies installed successfully"
        else
            print_error "Failed to install app dependencies"
            exit 1
        fi
    fi
    
    cd - > /dev/null || exit 1
else
    print_info "No apps/web directory found, skipping app install"
fi

# ==========================================
# STEP 5: Install Test Dependencies
# ==========================================

print_header "Step 5/6: Install Test Dependencies"

if [[ -d "test-harness" ]]; then
    cd "test-harness" || exit 1
    
    if [[ "$SKIP_INSTALL" == true ]]; then
        print_warning "Skipping test harness install (--skip-install flag)"
    elif [[ "$DRY_RUN" == true ]]; then
        print_info "[DRY RUN] Would run: npm install in test-harness"
        print_info "[DRY RUN] Would run: npx playwright install --with-deps"
    else
        print_info "Running npm install in test-harness..."
        if npm install; then
            print_step "Test dependencies installed successfully"
        else
            print_error "Failed to install test dependencies"
            exit 1
        fi
        
        # Install Playwright browsers
        if command -v npx &> /dev/null; then
            print_info "Installing Playwright browsers..."
            if npx playwright install --with-deps; then
                print_step "Playwright browsers installed successfully"
            else
                print_warning "Failed to install Playwright browsers (non-critical)"
            fi
        fi
    fi
    
    cd - > /dev/null || exit 1
else
    print_info "No test-harness directory found, skipping test install"
fi

# ==========================================
# STEP 6: Verification
# ==========================================

print_header "Step 6/6: Verification"

if [[ "$DRY_RUN" == true ]]; then
    print_info "[DRY RUN] Skipping verification"
else
    # Verify Node.js can parse config files
    print_info "Verifying config files syntax..."
    
    VERIFICATION_PASSED=true
    for config_file in "${CONFIG_FILES[@]}"; do
        if [[ -f "$config_file" ]]; then
            if node --check "$config_file" 2>/dev/null; then
                print_step "$config_file syntax is valid"
            else
                print_error "$config_file has syntax errors"
                VERIFICATION_PASSED=false
            fi
        fi
    done
    
    if [[ "$VERIFICATION_PASSED" == true ]]; then
        print_step "All config files passed syntax verification"
    else
        print_warning "Some config files have errors, please review"
    fi
fi

# ==========================================
# COMPLETION SUMMARY
# ==========================================

print_header "Setup Complete!"

if [[ "$DRY_RUN" == true ]]; then
    print_info "This was a DRY RUN - no changes were made"
    print_info "Run without --dry-run to apply changes"
else
    print_step "Project setup completed successfully"
    
    if [[ -d "apps/web" ]]; then
        echo ""
        print_info "To start the dev server:"
        echo -e "  ${BLUE}cd apps/web && npm run dev${NC}"
    else
        echo ""
        print_info "To start the dev server:"
        echo -e "  ${BLUE}npm run dev${NC}"
    fi
    
    if [[ $FIXED_COUNT -gt 0 ]]; then
        echo ""
        print_info "Backups of modified files saved to: $BACKUP_DIR"
        print_info "To rollback changes, restore from backup directory"
    fi
fi

echo ""
print_step "All done! 🚀"
