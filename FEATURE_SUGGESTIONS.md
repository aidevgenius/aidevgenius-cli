# aidevgenius-cli: Future Feature Suggestions

This document contains 100% new, English-language suggestions for the future evolution of the `aidevgenius` CLI tool. These ideas are designed to expand the tool's capabilities beyond its current state.

## 1. Native GitHub Releases integration for Installers
**Idea:** Instead of hosting `.deb` or `tar.gz` files directly in the repository (like `packages/flutter.deb`), create a helper in `_base.sh` that automatically fetches the latest GitHub Release asset from any public repository.
**Benefit:** Keeps the `aidevgenius-cli` repository size small and ensures users always get the absolute latest version of tools like Neovim or specialized CLIs directly from their official sources.

## 2. Interactive Setup Wizard (`aidevgenius setup`)
**Idea:** A first-run interactive graphical (TUI) wizard using `dialog` or `whiptail` (which are available on Termux). It would ask the user: "Do you want to develop in Flutter?", "Which shell do you prefer?", "Do you want AI coding assistants?".
**Benefit:** dramatically lowers the barrier to entry for beginners hitting Termux for the first time.

## 3. Environment Backup and Restore (`aidevgenius sync`)
**Idea:** Allow users to backup their installed `aidevgenius` packages, `.zshrc`, `.bashrc`, and Neovim configurations to a private GitHub Gist, and restore them on a new phone with a single command.
**Benefit:** Mobile devices are frequently wiped or upgraded. This makes the Termux development environment portable and resilient.

## 4. Local Project Templates (`aidevgenius create`)
**Idea:** Go beyond `flutter init` and offer full project scaffolding. Users could run `aidevgenius create api` to instantly get a Node.js/Express backend template, or `aidevgenius create rust` for a pre-configured Rust project optimized for Termux.
**Benefit:** Turns `aidevgenius` into a universal project bootstrapper, not just an installer.

## 5. Automated Termux Storage & Permission Fixer
**Idea:** New users often struggle with `termux-setup-storage` and Android permissions. A command like `aidevgenius doctor` (global, not just flutter) that checks Android API levels, battery optimization settings (which kill Termux), and storage links, auto-fixing them where possible.
**Benefit:** Eliminates the top 3 causes of "it does not work" issues on Android.

## 6. AI-Powered Command Explainer Built-in
**Idea:** Since `aidevgenius` already installs `qwen`, integrate a native wrapper: `aidevgenius wtf <command>`. If a build fails or a termux package errors out, `aidevgenius` parses the stderr and asks the installed AI CLI to explain the fix in simple terms.
**Benefit:** Makes mobile debugging incredibly seamless without switching contexts.

## 7. Custom Installer Repositories
**Idea:** Currently, `lib/installers/` is hardcoded to the main repository. Allow users to add third-party installer URLs: `aidevgenius repo add username/aidevgenius-plugins`.
**Benefit:** Creates a community ecosystem where anyone can build and share `aidevgenius` installer scripts without needing them merged into the core project.

## 8. Battery & Thermal Aware Builds
**Idea:** Compiling code on an Android phone can overheat the device. Add thermal monitoring (reading `/sys/class/thermal/`) during local operations. If the phone hits 45°C, automatically pause the compilation/installation thread and resume when it cools down.
**Benefit:** Prevents device throttling and protects user hardware during heavy local tasks.

## 9. Background Service Manager (`aidevgenius service`)
**Idea:** Termux lacks `systemd`. Provide a simple command to keep services (like a local database, redis, or a node server) running in the Termux background using `daemonize` or `tmux` sessions automatically managed by `aidevgenius`.
**Benefit:** Allows users to run real full-stack environments effortlessly.

## 10. Integrated Webhooks for Cloud Builds
**Idea:** After `aidevgenius flutter build apk` triggers a GitHub Action, allow configuring a Discord or Telegram webhook so the user gets a push notification on their phone with the APK download link when the cloud build finishes.
**Benefit:** Users can close Termux and do other things on their phone while the cloud works, getting alerted only when the final product is ready.