import '../cache/cache_manager.dart';

/// Service for managing onboarding tutorial state using Hive
class OnboardingService {
  static const String _ttsOnboardingKey = 'has_seen_tts_onboarding';
  static const String _tttOnboardingKey = 'has_seen_ttt_onboarding';
  static const String _sttOnboardingKey = 'has_seen_stt_onboarding';
  static const String _introductionKey = 'has_seen_introduction';

  /// Check if user has seen the introduction page
  static bool hasSeenIntroduction() {
    try {
      return CacheManager.getData(_introductionKey) ?? false;
    } catch (e) {
      return false;
    }
  }

  /// Mark introduction as seen
  static Future<void> markIntroductionAsSeen() async {
    try {
      await CacheManager.saveData(_introductionKey, true);
    } catch (e) {
      // Silently fail
    }
  }

  /// Check if user has seen the Text-to-Speech onboarding
  static bool hasSeenTTSOnboarding() {
    try {
      return CacheManager.getData(_ttsOnboardingKey) ?? false;
    } catch (e) {
      return false;
    }
  }

  /// Check if user has seen the Text-to-Text onboarding
  static bool hasSeenTTTOnboarding() {
    try {
      return CacheManager.getData(_tttOnboardingKey) ?? false;
    } catch (e) {
      return false;
    }
  }

  /// Check if user has seen the Speech-to-Text onboarding
  static bool hasSeenSTTOnboarding() {
    try {
      return CacheManager.getData(_sttOnboardingKey) ?? false;
    } catch (e) {
      return false;
    }
  }

  /// Mark Text-to-Speech onboarding as seen
  static Future<void> markTTSOnboardingAsSeen() async {
    try {
      await CacheManager.saveData(_ttsOnboardingKey, true);
    } catch (e) {
      // Silently fail
    }
  }

  /// Mark Text-to-Text onboarding as seen
  static Future<void> markTTTOnboardingAsSeen() async {
    try {
      await CacheManager.saveData(_tttOnboardingKey, true);
    } catch (e) {
      // Silently fail
    }
  }

  /// Mark Speech-to-Text onboarding as seen
  static Future<void> markSTTOnboardingAsSeen() async {
    try {
      await CacheManager.saveData(_sttOnboardingKey, true);
    } catch (e) {
      // Silently fail
    }
  }

  /// Reset all onboarding (for testing)
  static Future<void> resetAllOnboarding() async {
    try {
      await CacheManager.removeData(_ttsOnboardingKey);
      await CacheManager.removeData(_tttOnboardingKey);
      await CacheManager.removeData(_sttOnboardingKey);
      await CacheManager.removeData(_introductionKey);
    } catch (e) {
      // Silently fail
    }
  }
}
