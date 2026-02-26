#!/bin/bash
# aidevgenius - Auto Update Command

cmd_update() {
    print_header "Updating aidevgenius"
    echo -e "${DIM}Checking for latest version...${NC}"
    echo ""

    local install_dir="${HOME}/.aidevgenius"
    local current_version="${VERSION:-unknown}"

    # Get latest version from GitHub
    print_step "Fetching latest version..."
    local latest_version
    latest_version=$(curl -fsSL "https://raw.githubusercontent.com/aidevgenius/aidevgenius-cli/dev/lib/core.sh" 2>/dev/null | grep "^VERSION=" | cut -d'"' -f2)
    
    if [[ -z "$latest_version" ]]; then
        print_error "Could not fetch latest version"
        echo "Check your internet connection"
        exit 1
    fi
    
    echo "  Current: v${current_version}"
    echo "  Latest:  v${latest_version}"
    echo ""
    
    # Check if update needed
    if [[ "$current_version" == "$latest_version" ]]; then
        print_success "Already up to date! ✓"
        exit 0
    fi
    
    print_info "New version available!"
    echo ""
    
    # Show changelog
    print_step "What's new in v${latest_version}:"
    local changelog
    changelog=$(curl -fsSL "https://api.github.com/repos/aidevgenius/aidevgenius-cli/commits?per_page=5" 2>/dev/null | grep '"message"' | head -5 | sed 's/.*"message": "\(.*\)".*/  • \1/')
    if [[ -n "$changelog" ]]; then
        echo "$changelog"
    fi
    echo ""

    # Backup current installation
    print_step "Backing up current installation..."
    local backup_dir="${HOME}/.aidevgenius-backup"
    rm -rf "$backup_dir" 2>/dev/null
    cp -r "$install_dir" "$backup_dir" 2>/dev/null
    print_success "Backup created"

    # Download and install latest
    print_step "Downloading latest version..."

    local temp_dir="${PREFIX:-/tmp}/aidevgenius-update-$$"
    mkdir -p "$temp_dir"

    # Download latest release
    if curl -fsSL "https://github.com/aidevgenius/aidevgenius-cli/archive/refs/heads/dev.tar.gz" -o "$temp_dir/aidevgenius.tar.gz" 2>/dev/null; then
        print_success "Downloaded"

        print_step "Installing update..."
        cd "$temp_dir"
        tar -xzf aidevgenius.tar.gz 2>/dev/null

        # Copy new files
        if [[ -d "aidevgenius-cli-dev" ]]; then
            rm -rf "$install_dir"
            mv "aidevgenius-cli-dev" "$install_dir"

            # Make all scripts executable (including new installers)
            chmod +x "$install_dir/bin/aidevgenius" 2>/dev/null
            find "$install_dir/lib" -name "*.sh" -exec chmod +x {} \; 2>/dev/null || true
            
            # Cleanup
            cd ~
            rm -rf "$temp_dir"
            rm -rf "$backup_dir"

            echo ""
            print_success "Updated to v${latest_version}! 🎉"
            echo ""
            echo "Changes applied. Run 'aidevgenius --version' to verify."
            echo ""
        else
            print_error "Update extraction failed"
            restore_backup "$backup_dir" "$install_dir"
            exit 1
        fi
    else
        print_error "Download failed"
        echo "Check your internet connection"
        exit 1
    fi
}

restore_backup() {
    local backup_dir="$1"
    local install_dir="$2"
    
    if [[ -d "$backup_dir" ]]; then
        print_step "Restoring backup..."
        rm -rf "$install_dir"
        mv "$backup_dir" "$install_dir"
        print_warning "Restored previous version"
    fi
}
