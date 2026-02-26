# Changelog

All notable changes to aidevgenius are documented here.

## [3.0.2] - 2026-02-23

### Added
- **Plugin-based Installer Architecture**: `lib/installers/` directory introduced. Any `.sh` file added here automatically becomes a `aidevgenius install <name>` command.
- `aidevgenius install qwen`: Installs Qwen Code CLI via npm automatically.
- Generic fallback installer: `aidevgenius install <pkg>` will attempt to install via Termux `pkg` if a dedicated script doesn't exist.
- 12 standard plugins added to the `aidevgenius install oh-my-zsh` configuration.

### Changed
- Removed all dependencies on the TermuxVoid repository.
- Flutter installation now uses a dedicated `packages/flutter.deb` file hosted directly in the aidevgenius-cli repository for enhanced reliability and custom branding.
- Global installation script (`install.sh`) now only installs absolute minimum dependencies (`git`, `curl`). Other dependencies like `gh`, `jq`, `npm` are installed lazily only when requested by a specific command.
- Switched all main repository references from the `main` branch to the `dev` branch.

## [2.7.1] - 2025-02-01

### Added
- Complete Zsh setup with one command: `aidevgenius install oh-my-zsh`
  - Zsh shell
  - Oh My Zsh framework
  - Powerlevel10k theme
  - zsh-autosuggestions
  - zsh-syntax-highlighting
  - zsh-completions
- Automatic .zshrc configuration from the current shell

## [2.7.0] - 2025-02-01

### Added
- `aidevgenius install shell-tools` - Bundle with Fish, Zsh, TheFuck, Fzf
- `aidevgenius install fish` - Fish shell with auto-suggestions
- `aidevgenius install zsh` - Z Shell
- `aidevgenius install oh-my-zsh` - Complete Zsh setup
- `aidevgenius install thefuck` - Command correction tool
- Post-install prompt asking to install shell-tools

### Changed
- Installer now asks if you want shell-tools after CLI install

## [2.6.0] - 2025-02-01

### Added
- `aidevgenius install` command for installing packages
- `aidevgenius install flutter` - Install Flutter SDK
- `aidevgenius install neovim/micro/vim` - Install editors
- Automatic TermuxVoid repository setup
- aidevgenius branding throughout CLI
- TermuxVoid credit in install messages
- Professional README with badges
- CONTRIBUTING.md guide
- CHANGELOG.md

### Changed
- Completely rewrote `aidevgenius update` for automatic updates
- Auto-download latest version with backup
- Shows changelog during updates
- Silenced TermuxVoid output during install

### Fixed
- Update command now actually auto-updates
- Flutter install uses correct TermuxVoid repo

## [2.5.0] - 2025-02-01

### Added
- TermuxVoid integration for Flutter install

### Fixed
- Flutter SDK installation on Termux

## [2.4.0] - 2025-01-31

### Added
- Live build progress with elapsed time
- Step-by-step build status display
- Auto-detect artifact names for download

### Fixed
- "Artifact not found" download errors
- APK file overwrite issues

## [2.3.0] - 2025-01-31

### Added
- `--split-per-abi` flag for split APKs
- `--target-platform` for specific architectures
- `--install` to install APK after download
- Pro tips displayed after `aidevgenius flutter init`

### Changed
- Workflow template copied from file instead of hardcoded
- Auto-overwrite existing workflow files

## [2.0.0] - 2025-01-31

### Added
- Complete CLI rewrite as `aidevgenius`
- Multi-tool architecture
- `aidevgenius flutter` subcommands
- Cloud build support via GitHub Actions
- `aidevgenius update` command

### Changed
- Renamed from aidevgenius-flutter to aidevgenius
- Modular script structure

## [1.0.0] - 2025-01-30

### Added
- Initial release
- Flutter cloud build support
- APK generation via GitHub Actions
