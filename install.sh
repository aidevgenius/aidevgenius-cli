#!/bin/bash
# aidevgenius Installer
# One-line installation: curl -fsSL https://raw.githubusercontent.com/aidevgenius/aidevgenius-cli/dev/install.sh | bash

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
DIM='\033[2m'
NC='\033[0m'

print_success() { echo -e "${GREEN}✓${NC} $1"; }
print_error()   { echo -e "${RED}✗${NC} $1"; }
print_warning() { echo -e "${YELLOW}⚠${NC} $1"; }
print_info()    { echo -e "${BLUE}ℹ${NC} $1"; }
print_step()    { echo -e "${CYAN}→${NC} $1"; }

# Banner
echo ""
echo -e "${BOLD}${CYAN}"
echo "     _    ___   ____  _______     __    ____ _____ _   _ ___ _   _ ____  "
echo "    / \  |_ _| |  _ \| ____\ \   / /   / ___| ____| \ | |_ _| | | / ___| "
echo "   / _ \  | |  | | | |  _|  \ \ / /   | |  _|  _| |  \| || || | | \___ \ "
echo "  / ___ \ | |  | |_| | |___  \ V /    | |_| | |___| |\  || || |_| |___) |"
echo " /_/   \_\___| |____/|_____|  \_/      \____|_____|_| \_|___|\___/|____/ "
echo -e "${NC}"
echo -e "${BOLD}Multi-purpose CLI for mobile developers${NC}"
echo ""

# Detect Termux
is_termux() {
    [[ -n "$PREFIX" && "$PREFIX" == *"com.termux"* ]]
}

# Check if command exists
check_cmd() {
    command -v "$1" &>/dev/null
}

# Install directory
INSTALL_DIR="${HOME}/.aidevgenius"
REPO_URL="https://github.com/aidevgenius/aidevgenius-cli.git"

# Detect environment
if is_termux; then
    print_info "Detected: Termux on Android"
    BIN_DIR="$PREFIX/bin"
else
    print_info "Detected: $(uname -s)"
    BIN_DIR="${HOME}/.local/bin"
fi

# ── Minimal global deps: only git and curl ──────────────────────────────────
print_step "Checking core dependencies..."

install_pkg() {
    local pkg="$1"
    if is_termux; then
        pkg install -y "$pkg" 2>/dev/null || true
    elif check_cmd apt-get; then
        sudo apt-get install -y "$pkg" 2>/dev/null || true
    elif check_cmd brew; then
        brew install "$pkg" 2>/dev/null || true
    fi
}

# git (needed to clone/update aidevgenius itself)
if ! check_cmd git; then
    print_step "Installing git..."
    install_pkg git
fi
if check_cmd git; then
    print_success "git ready"
else
    print_error "Failed to install git"
    exit 1
fi

# curl (needed for downloads)
if ! check_cmd curl; then
    print_step "Installing curl..."
    install_pkg curl
fi
if check_cmd curl; then
    print_success "curl ready"
else
    print_error "Failed to install curl"
    exit 1
fi

# NOTE: gh, jq, termux-api are NOT installed here.
# They are installed on-demand by the tools that need them:
#   gh         → installed by: aidevgenius flutter init / build
#   jq         → installed by: aidevgenius flutter build
#   termux-api → installed by: aidevgenius flutter run web
# ────────────────────────────────────────────────────────────────────────────

# Clone or update repository
print_step "Installing aidevgenius..."

if [[ -d "$INSTALL_DIR" ]]; then
    print_info "Updating existing installation..."
    cd "$INSTALL_DIR"
    git fetch origin dev 2>/dev/null || true
    git reset --hard origin/dev 2>/dev/null || git pull 2>/dev/null || true
else
    print_info "Cloning repository..."
    git clone "$REPO_URL" "$INSTALL_DIR"
fi

# Make scripts executable
chmod +x "$INSTALL_DIR/bin/aidevgenius" 2>/dev/null || true
find "$INSTALL_DIR/lib" -name "*.sh" -exec chmod +x {} \; 2>/dev/null || true

# Create bin directory if needed
mkdir -p "$BIN_DIR"

# Create symlink
print_step "Creating symlink..."
ln -sf "$INSTALL_DIR/bin/aidevgenius" "$BIN_DIR/aidevgenius"
print_success "Symlink created at $BIN_DIR/aidevgenius"

# Add to PATH if needed
if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
    print_step "Adding to PATH..."

    SHELL_RC=""
    if [[ -n "$BASH_VERSION" ]]; then
        SHELL_RC="${HOME}/.bashrc"
    elif [[ -n "$ZSH_VERSION" ]]; then
        SHELL_RC="${HOME}/.zshrc"
    else
        SHELL_RC="${HOME}/.profile"
    fi

    if ! grep -q "$BIN_DIR" "$SHELL_RC" 2>/dev/null; then
        echo "" >>"$SHELL_RC"
        echo "# aidevgenius" >>"$SHELL_RC"
        echo "export PATH=\"$BIN_DIR:\$PATH\"" >>"$SHELL_RC"
        print_success "Added to $SHELL_RC"
    fi

    export PATH="$BIN_DIR:$PATH"
fi

# Done!
echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✓${NC} ${BOLD}aidevgenius installed successfully!${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo "Quick start:"
echo "  aidevgenius --help              Show all commands"
echo "  aidevgenius install flutter     Install Flutter SDK"
echo "  aidevgenius install qwen        Install Qwen AI Code CLI"
echo "  aidevgenius install shell-tools Install auto-suggestions"
echo ""
echo "In a Flutter project:"
echo "  aidevgenius flutter init            Setup cloud build"
echo "  aidevgenius flutter build apk       Build APK in cloud"
echo "  aidevgenius flutter run web         Run web server locally"
echo ""
echo "Update:"
echo "  aidevgenius update"
echo ""
echo -e "${DIM}Powered by aidevgenius • https://github.com/aidevgenius/aidevgenius-cli${NC}"
echo ""
if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
    print_warning "Please restart your terminal or run:"
    echo "  source ${SHELL_RC}"
    echo ""
fi
