#!/bin/bash
# aidevgenius installer: flutter
# Usage: aidevgenius install flutter
# Installs Flutter SDK via aidevgenius's .deb package (aidevgenius branding)

cmd_install() {
    # Delegate to the flutter tool's install command
    # This keeps all flutter logic in lib/flutter/
    source "${LIB_DIR}/flutter/install.sh"
    cmd_install_flutter
}
