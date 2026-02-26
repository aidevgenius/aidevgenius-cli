# aidevgenius - Product Requirements Document

## 1. Product Name
**aidevgenius** (multi-tool CLI, with `flutter` as first tool)

## 2. One-line Vision
A mobile-first CLI that lets users build Flutter apps on Android phones using Termux and cloud builds — without a PC.

## 3. Target Users
- Students with no PC access
- Low-end PC or no-PC developers
- Android + Termux users
- Flutter beginners

## 4. Core Philosophy
- **Don't replace Flutter** — wrap it with mobile-friendly automation
- **Cloud-first builds** — offload heavy builds to GitHub Actions
- **Same commands as Flutter** — familiar interface

## 5. Installation

```bash
curl -fsSL https://raw.githubusercontent.com/aidevgenius/aidevgenius-cli/dev/install.sh | bash
```

## 6. Command Structure

### Global Commands
```bash
aidevgenius --help           # Show help
aidevgenius --version        # Show version  
aidevgenius update           # Update CLI
```

### Flutter Tool Commands
```bash
aidevgenius flutter install       # Install Flutter SDK
aidevgenius flutter doctor        # Check requirements
aidevgenius flutter init          # Initialize cloud build
aidevgenius flutter run web       # Run local web server
```

### Build Commands (matching `flutter build`)
```bash
# APK builds
aidevgenius flutter build apk --debug
aidevgenius flutter build apk --profile
aidevgenius flutter build apk --release

# Split APK (smaller per-device files)
aidevgenius flutter build apk --release --split-per-abi

# Target platform
aidevgenius flutter build apk --release --target-platform android-arm64
aidevgenius flutter build apk --release --target-platform android-arm
aidevgenius flutter build apk --release --target-platform android-x64

# App Bundle
aidevgenius flutter build appbundle --debug
aidevgenius flutter build appbundle --release

# Auto-install on device
aidevgenius flutter build apk --release --install
```

## 7. Architecture

```
User (Termux) → aidevgenius CLI → Plugin Dispatcher (lib/installers/*.sh)
                                 │
                                 ├──> Flutter Tool → GitHub Action → APK
                                 ├──> Qwen Install
                                 └──> Shell Tools Install
```

## 8. Files Generated

### `.github/workflows/aidevgenius-build.yml`
GitHub Actions workflow with inputs:
- `build_type`: debug, profile, release
- `output_type`: apk, appbundle, apk-split
- `target_platform`: all, android-arm64, android-arm, android-x64

### `.aidevgenius.yaml`
Project configuration file.

## 9. Technical Stack
- **CLI**: Pure Bash (native Termux, fast startup)
- **Cloud**: GitHub Actions
- **Auth**: GitHub CLI (`gh auth login`)

## 10. Non-Goals (v1)
- iOS builds
- Emulator management
- Desktop OS support
- GUI interface

## 11. Success Criteria
A user can:
1. Install aidevgenius on phone
2. Create/open Flutter project
3. Run one build command
4. Get working APK downloaded
5. Optionally auto-install to device

**All without touching a PC.**

## 12. Roadmap

### v1 (Current)
- ✅ Install Flutter SDK
- ✅ Doctor command
- ✅ Init cloud build
- ✅ Build APK (debug/profile/release)
- ✅ Build App Bundle
- ✅ Split APK by ABI
- ✅ Target platform
- ✅ Auto-install on device

### v2 (Planned)
- Log streaming
- Build caching
- Run web locally
- Template workflows

### v3 (Current)
- ✅ Auto-discovery Plugin system (`lib/installers/`)
- ✅ 100% aidevgenius branding (No TermuxVoid dependency)
- ✅ AI Tools Integration (Qwen)

### v4 (Future)
- Multiple cloud backends
- Custom workflows