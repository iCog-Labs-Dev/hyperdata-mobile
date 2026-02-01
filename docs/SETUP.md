# Setup Guide

## Quick Setup (5 minutes)

### Prerequisites

- Flutter SDK 3.5.0+
- Dart SDK 3.5.0+
- Android Studio or Xcode
- Git

### Installation Steps

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/leyu_mobile.git
   cd leyu_mobile
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure environment variables**
   ```bash
   cp .env.example .env
   ```

   Edit `.env` and add your configuration:
   ```env
   API_BASE_URL=your_api_base_url
   ONESIGNAL_APP_ID=your_onesignal_app_id
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

## Environment Configuration

### Required Variables

| Variable | Description | Example |
|----------|-------------|---------|
| `API_BASE_URL` | Backend API URL | `http://api.example.com/api` |
| `ONESIGNAL_APP_ID` | OneSignal App ID for push notifications | `your-app-id-here` |

### Multiple Environments

Create separate `.env` files for different environments:

- `.env.dev` - Development
- `.env.staging` - Staging
- `.env.prod` - Production

Switch environments:
```bash
cp .env.dev .env
flutter run
```

## Platform-Specific Setup

### Android

1. **Minimum SDK**: API 21 (Android 5.0)
2. **Target SDK**: Latest stable

No additional configuration needed.

### iOS

1. **Minimum Version**: iOS 12.0
2. **Xcode**: Latest stable version

For OneSignal notifications:
1. Open `ios/Runner.xcworkspace` in Xcode
2. Select Runner target → Build Phases
3. Add "Run Script" phase before "Compile Sources"
4. Add: `source "${SRCROOT}/Scripts/load_env.sh"`

## Verification

### Check Setup

```bash
# Verify Flutter installation
flutter doctor

# Check dependencies
flutter pub get

# Run analyzer
flutter analyze

# Run tests
flutter test
```

### Common Issues

#### "Environment variable not found"
- Ensure `.env` file exists in project root
- Check variable names match exactly
- Restart the app after changing `.env`

#### "Flutter doctor shows issues"
- Follow Flutter doctor recommendations
- Install missing dependencies
- Update Flutter SDK if needed

#### "Build fails"
- Run `flutter clean`
- Delete `pubspec.lock`
- Run `flutter pub get` again
- Try `flutter run --verbose` for detailed logs

## Next Steps

- Read [ARCHITECTURE.md](../ARCHITECTURE.md) to understand the codebase
- Check [API_DOCUMENTATION.md](../API_DOCUMENTATION.md) for API details
- See [CONTRIBUTING.md](../CONTRIBUTING.md) to start contributing

## Support

- Check [README.md](../README.md) for general information
- Review [API_DOCUMENTATION.md](../API_DOCUMENTATION.md) for API issues
- Open an issue on GitHub for bugs
- Join discussions for questions

---

**Need help?** Open an issue or start a discussion on GitHub.
