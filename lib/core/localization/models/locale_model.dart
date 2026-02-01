import 'package:flutter/material.dart';

/// Data model representing a supported locale with display information
class LocaleModel {
  final String languageCode;
  final String countryCode;
  final String displayName;
  final String nativeName;

  const LocaleModel({
    required this.languageCode,
    required this.countryCode,
    required this.displayName,
    required this.nativeName,
  });

  /// Get Flutter Locale object
  Locale get locale => Locale(languageCode, countryCode);

  /// Get locale string in format 'languageCode_countryCode'
  String get localeString => '${languageCode}_$countryCode';

  /// List of all supported locales
  static const List<LocaleModel> supportedLocales = [
    LocaleModel(
      languageCode: 'en',
      countryCode: 'US',
      displayName: 'English',
      nativeName: 'English',
    ),
    LocaleModel(
      languageCode: 'am',
      countryCode: 'ET',
      displayName: 'Amharic',
      nativeName: 'አማርኛ',
    ),
    LocaleModel(
      languageCode: 'om',
      countryCode: 'ET',
      displayName: 'Afan Oromo',
      nativeName: 'Afaan Oromoo',
    ),
  ];

  /// Get LocaleModel from locale string
  static LocaleModel? fromString(String localeString) {
    try {
      final parts = localeString.split('_');
      if (parts.length == 2) {
        return supportedLocales.firstWhere(
          (locale) =>
              locale.languageCode == parts[0] && locale.countryCode == parts[1],
          orElse: () => supportedLocales.first,
        );
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  /// Get LocaleModel from Locale object
  static LocaleModel? fromLocale(Locale locale) {
    try {
      return supportedLocales.firstWhere(
        (localeModel) =>
            localeModel.languageCode == locale.languageCode &&
            localeModel.countryCode == locale.countryCode,
        orElse: () => supportedLocales.first,
      );
    } catch (e) {
      return null;
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LocaleModel &&
        other.languageCode == languageCode &&
        other.countryCode == countryCode;
  }

  @override
  int get hashCode => languageCode.hashCode ^ countryCode.hashCode;
}
