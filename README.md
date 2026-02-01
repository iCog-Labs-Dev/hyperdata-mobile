# Leyu Mobile

<div align="center">

![Leyu Logo](assets/images/logo.png)

**A mobile application for dataset contributors of Leyu**

[![Flutter](https://img.shields.io/badge/Flutter-3.5.0-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.5.0-0175C2?logo=dart)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)

[Features](#features) • [Getting Started](#getting-started) • [Documentation](#documentation) • [Contributing](#contributing) • [License](#license)

</div>

---

## 📱 About

Leyu Mobile is a Flutter-based mobile application designed for dataset contributors. The app enables users to contribute to various data collection tasks including speech-to-text, text-to-speech, and text-to-text tasks, helping build high-quality datasets for machine learning and AI applications.

### Key Highlights

- 🎯 **Task Management**: Browse, accept, and complete various data collection tasks
- 🎤 **Audio Recording**: High-quality audio recording for speech tasks
- 🔊 **Audio Playback**: Built-in audio player for reviewing recordings
- 📝 **Text Input**: Validated text input for transcription tasks
- 🌍 **Multi-language Support**: Supports Amharic, Oromo, and English
- 🔔 **Push Notifications**: Real-time updates via OneSignal
- 💰 **Wallet Integration**: Track earnings and manage withdrawals
- 👤 **Profile Management**: Comprehensive user profile and settings
- 🔐 **Secure Authentication**: JWT-based authentication with token refresh

## ✨ Features

### For Contributors

- **Task Discovery**: Browse available tasks filtered by type and status
- **Task Submission**: Complete tasks with audio recording or text input
- **Progress Tracking**: Monitor task completion and submission history
- **Earnings Dashboard**: View earnings and transaction history
- **Notifications**: Receive updates on task assignments and approvals
- **Profile Management**: Update personal information and preferences

### Technical Features

- **Clean Architecture**: Separation of concerns with domain, data, and presentation layers
- **State Management**: GetX for reactive state management
- **Local Storage**: Hive for efficient local data persistence
- **Secure Storage**: Flutter Secure Storage for sensitive data
- **API Integration**: RESTful API with Dio HTTP client
- **Push Notifications**: OneSignal integration for real-time updates
- **Audio Management**: Advanced audio recording and playback
- **Offline Support**: Local caching for offline functionality
- **Environment Configuration**: Secure environment variable management

## 🚀 Getting Started

### Prerequisites

- **Flutter SDK**: 3.5.0 or higher
- **Dart SDK**: 3.5.0 or higher
- **Android Studio** or **Xcode** (for iOS development)
- **Git**: For version control

### Installation

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

   See [docs/SETUP.md](docs/SETUP.md) for detailed instructions.

4. **Run the app**

   ```bash
   # Development
   flutter run

   # Release
   flutter run --release
   ```

### Building for Production

#### Android

```bash
flutter build apk --release
# or
flutter build appbundle --release
```

#### iOS

```bash
flutter build ios --release
```

## 📖 Documentation

### Getting Started

- **[docs/SETUP.md](docs/SETUP.md)** - Complete setup guide
- **[CONTRIBUTING.md](CONTRIBUTING.md)** - How to contribute
- **[CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md)** - Community guidelines

### Technical Documentation

- **[ARCHITECTURE.md](ARCHITECTURE.md)** - App architecture and design patterns
- **[API_DOCUMENTATION.md](API_DOCUMENTATION.md)** - API integration guide
- **[CHANGELOG.md](CHANGELOG.md)** - Version history and changes

### Additional Resources

- **[LICENSE](LICENSE)** - MIT License
- **[CONTRIBUTORS.md](CONTRIBUTORS.md)** - Project contributors

## 🏗️ Architecture

The app follows **Clean Architecture** principles with clear separation of concerns:

```
lib/
├── core/                      # Core functionality
│   ├── api/                   # API client and constants
│   ├── cache/                 # Cache management
│   ├── constants/             # App constants
│   ├── errors/                # Error handling
│   ├── localization/          # Multi-language support
│   ├── services/              # Core services
│   ├── theme/                 # App theming
│   ├── utils/                 # Utility functions
│   └── widgets/               # Reusable widgets
├── features/                  # Feature modules
│   ├── auth/                  # Authentication
│   │   ├── data/              # Data layer
│   │   ├── domain/            # Domain layer
│   │   └── presentation/      # Presentation layer
│   ├── home/                  # Home & tasks
│   ├── notification/          # Notifications
│   └── profile/               # User profile
├── routes/                    # App routing
└── main.dart                  # App entry point
```

### Key Technologies

- **State Management**: GetX
- **HTTP Client**: Dio
- **Local Database**: Hive
- **Secure Storage**: Flutter Secure Storage
- **Audio Recording**: record package
- **Audio Playback**: just_audio
- **Push Notifications**: OneSignal
- **Image Handling**: cached_network_image
- **Environment Variables**: flutter_dotenv

## 🌍 Localization

The app supports multiple languages:

- 🇺🇸 **English** (en_US)
- 🇪🇹 **Amharic** (am_ET)
- 🇪🇹 **Oromo** (om_ET)

To add a new language:

1. Create translation file in `lib/core/localization/translations/`
2. Add locale to `lib/core/localization/app_translations.dart`
3. Update `LocalizationController` if needed

## 🔐 Security

- **Environment Variables**: Sensitive data stored in `.env` (not in version control)
- **Secure Storage**: Tokens and credentials encrypted with Flutter Secure Storage
- **API Security**: JWT-based authentication with automatic token refresh
- **Input Validation**: All user inputs validated before processing
- **HTTPS Only**: All API calls over HTTPS

For security concerns, please email security@leyu.ai or open a private security advisory on GitHub.

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test
flutter test test/widget_test.dart
```

## 📱 Supported Platforms

- ✅ **Android**: API 21+ (Android 5.0+)
- ✅ **iOS**: iOS 12.0+

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md) for details.

### Quick Contribution Steps

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📝 Code of Conduct

This project follows the [Contributor Covenant Code of Conduct](CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👥 Team

- **Development Team**: Leyu Development Team
- **Contributors**: See [CONTRIBUTORS.md](CONTRIBUTORS.md)

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- GetX for state management
- OneSignal for push notifications
- All contributors who have helped improve this project

## 📞 Support

- **Documentation**: Check the [docs](#documentation) section
- **Issues**: [GitHub Issues](https://github.com/yourusername/leyu_mobile/issues)
- **Discussions**: [GitHub Discussions](https://github.com/yourusername/leyu_mobile/discussions)

## 🗺️ Roadmap

- [ ] Add more task types
- [ ] Implement offline mode
- [ ] Add dark mode
- [ ] Improve accessibility
- [ ] Add unit tests coverage
- [ ] Add integration tests
- [ ] Performance optimizations
- [ ] UI/UX improvements

## 📊 Project Status

- **Version**: 1.0.0+2
- **Status**: Active Development
- **Last Updated**: January 2026

---

<div align="center">

Made with ❤️ by the Leyu Team

[⬆ Back to Top](#leyu-mobile)

</div>
