#!/bin/bash

# ---
# id: scr.nextjs-start-dev-bash
# type: script
# title: Next.js Development Server Starter (Bash)
# tags: [nextjs, dev-server, development, automation]
# summary: Smart Next.js dev server starter with dependency check, port management, Node version verification, and auto-browser launch.
# runner: bash
# platforms: [macos, linux]
# requires: [node, npm]
# dangerous: false
# vars:
#   - { name: PORT, required: false, default: "3000", description: "Port number for dev server" }
#   - { name: OPEN_BROWSER, required: false, default: "false", description: "Automatically open browser" }
#   - { name: TURBO, required: false, default: "false", description: "Use Turbopack for faster builds" }
#   - { name: HOSTNAME, required: false, default: "localhost", description: "Hostname to bind to" }
# examples:
#   - "# Start with defaults (port 3000)"
#   - "./start-dev.sh"
#   - ""
#   - "# Start on custom port and open browser"
#   - "./start-dev.sh --port 3001 --open-browser"
#   - ""
#   - "# Use Turbopack for faster builds"
#   - "./start-dev.sh --turbo"
#   - ""
#   - "# Bind to 0.0.0.0 for network access"
#   - "./start-dev.sh --hostname 0.0.0.0"
# version: 1
# ---

#
# Smart Next.js development server starter with automated checks and setup.
#
# Description:
#   Starts Next.js development server with:
#   - Automatic dependency installation if missing
#   - Port availability checking
#   - Node version verification
#   - Environment file checking
#   - Optional browser auto-launch
#   - Turbopack support
#   - Clear, colorful output
#
# Usage:
#   ./start-dev.sh [OPTIONS]
#
# Options:
#   --port PORT         Port number (default: 3000)
#   --open-browser      Open browser automatically
#   --turbo             Use Turbopack for faster builds
#   --hostname HOST     Hostname to bind to (default: localhost)
#   --skip-checks       Skip Node and environment checks
#   --help              Show this help message
#

set -euo pipefail

# Default values
PORT=3000
OPEN_BROWSER=false
TURBO=false
HOSTNAME="localhost"
SKIP_CHECKS=false

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
GRAY='\033[0;90m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --port)
            PORT="$2"
            shift 2
            ;;
        --open-browser)
            OPEN_BROWSER=true
            shift
            ;;
        --turbo)
            TURBO=true
            shift
            ;;
        --hostname)
            HOSTNAME="$2"
            shift 2
            ;;
        --skip-checks)
            SKIP_CHECKS=true
            shift
            ;;
        --help)
            cat << EOF
Next.js Development Server Starter

Usage:
  $0 [OPTIONS]

Options:
  --port PORT         Port number for dev server (default: 3000)
  --open-browser      Automatically open browser after server starts
  --turbo             Use Turbopack for faster builds (Next.js 13+)
  --hostname HOST     Hostname to bind to (default: localhost, use 0.0.0.0 for network)
  --skip-checks       Skip Node version and environment checks
  --help              Show this help message

Examples:
  $0                                    # Start with defaults
  $0 --port 3001 --open-browser        # Custom port and auto-open browser
  $0 --turbo                           # Use Turbopack
  $0 --hostname 0.0.0.0                # Allow network access
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

# Helper functions
success() {
    echo -e "${GREEN}✓${NC} $1"
}

warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

error() {
    echo -e "${RED}✗${NC} $1"
}

info() {
    echo -e "${CYAN}ℹ️${NC} $1"
}

step() {
    echo -e "\n${CYAN}▶${NC} ${WHITE}$1${NC}"
}

# Header
echo ""
echo -e "${CYAN}======================================================================${NC}"
echo -e "${CYAN}  🚀 Next.js Development Server Starter${NC}"
echo -e "${CYAN}======================================================================${NC}"
echo ""

# Navigate to project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

if [[ -f "$PROJECT_ROOT/package.json" ]]; then
    cd "$PROJECT_ROOT"
    success "Project root: $PROJECT_ROOT"
else
    error "No package.json found. Run from Next.js project root."
    exit 1
fi

# Check if this is a Next.js project
if ! grep -q '"next"' package.json; then
    error "This doesn't appear to be a Next.js project (no next dependency)"
    exit 1
fi

success "Next.js project detected"

# Node version check
if [[ "$SKIP_CHECKS" == "false" ]]; then
    step "Checking Node.js version..."
    
    if ! command -v node &> /dev/null; then
        error "Node.js not found. Install from https://nodejs.org/"
        exit 1
    fi
    
    NODE_VERSION=$(node --version)
    NODE_MAJOR=$(echo "$NODE_VERSION" | sed 's/v\([0-9]*\)\..*/\1/')
    
    if [[ "$NODE_MAJOR" -lt 18 ]]; then
        error "Node.js 18+ required. Current version: $NODE_VERSION"
        info "Update Node.js: https://nodejs.org/"
        exit 1
    fi
    
    success "Node.js $NODE_VERSION ✓"
fi

# Check for dependencies
step "Checking dependencies..."

if [[ ! -d "node_modules" ]]; then
    warning "node_modules not found"
    info "Installing dependencies... (this may take a few minutes)"
    
    if npm install --loglevel=error; then
        success "Dependencies installed ✓"
    else
        error "Failed to install dependencies"
        info "Try running: npm install"
        exit 1
    fi
else
    success "Dependencies found ✓"
fi

# Check for environment files
if [[ "$SKIP_CHECKS" == "false" ]]; then
    step "Checking environment configuration..."
    
    ENV_FOUND=false
    for env_file in ".env.local" ".env.development.local" ".env"; do
        if [[ -f "$env_file" ]]; then
            success "Environment file found: $env_file"
            ENV_FOUND=true
            break
        fi
    done
    
    if [[ "$ENV_FOUND" == "false" ]]; then
        warning "No environment file found"
        info "Consider creating .env.local for environment variables"
    fi
fi

# Check if port is available
step "Checking port availability..."

if command -v lsof &> /dev/null; then
    if lsof -Pi :$PORT -sTCP:LISTEN -t >/dev/null 2>&1; then
        warning "Port $PORT is already in use"
        
        # Try to find next available port
        NEW_PORT=$PORT
        MAX_ATTEMPTS=10
        ATTEMPTS=0
        
        while lsof -Pi :$NEW_PORT -sTCP:LISTEN -t >/dev/null 2>&1 && [[ $ATTEMPTS -lt $MAX_ATTEMPTS ]]; do
            ((NEW_PORT++))
            ((ATTEMPTS++))
        done
        
        if ! lsof -Pi :$NEW_PORT -sTCP:LISTEN -t >/dev/null 2>&1; then
            info "Switching to available port: $NEW_PORT"
            PORT=$NEW_PORT
        else
            error "Could not find available port"
            info "Stop the process using port $PORT or specify different port with --port parameter"
            exit 1
        fi
    else
        success "Port $PORT is available ✓"
    fi
else
    info "Port check skipped (lsof not available)"
fi

# Build dev server command
step "Preparing dev server..."

DEV_COMMAND="npm run dev"
DEV_ARGS=()

# Add port if not default
if [[ "$PORT" != "3000" ]]; then
    DEV_ARGS+=("--port $PORT")
fi

# Add hostname if not default
if [[ "$HOSTNAME" != "localhost" ]]; then
    DEV_ARGS+=("--hostname $HOSTNAME")
fi

# Add turbo flag
if [[ "$TURBO" == "true" ]]; then
    DEV_ARGS+=("--turbo")
    info "Using Turbopack for faster builds"
fi

# Combine arguments
if [[ ${#DEV_ARGS[@]} -gt 0 ]]; then
    DEV_COMMAND="$DEV_COMMAND -- ${DEV_ARGS[*]}"
fi

# Display configuration
echo ""
echo -e "${WHITE}Configuration:${NC}"
echo -e "  ${GRAY}URL:     ${NC}${CYAN}http://$HOSTNAME:$PORT${NC}"
echo -e "  ${GRAY}Port:    ${NC}${WHITE}$PORT${NC}"
echo -e "  ${GRAY}Hostname:${NC}${WHITE} $HOSTNAME${NC}"
if [[ "$TURBO" == "true" ]]; then
    echo -e "  ${GRAY}Turbopack:${NC}${GREEN} Enabled${NC}"
fi
echo ""

# Start server
step "Starting Next.js dev server..."
echo ""
echo -e "${GRAY}======================================================================${NC}"
echo ""

# Open browser if requested
if [[ "$OPEN_BROWSER" == "true" ]]; then
    (
        sleep 3
        if command -v xdg-open &> /dev/null; then
            xdg-open "http://$HOSTNAME:$PORT" &> /dev/null
        elif command -v open &> /dev/null; then
            open "http://$HOSTNAME:$PORT" &> /dev/null
        fi
    ) &
    
    info "Browser will open automatically in 3 seconds..."
fi

# Execute dev command
eval "$DEV_COMMAND"
