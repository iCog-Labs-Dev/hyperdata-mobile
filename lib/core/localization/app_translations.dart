import 'package:get/get.dart';
import 'package:leyu_mobile/core/localization/translations/en_us_translations.dart';
import 'package:leyu_mobile/core/localization/translations/am_et_translations.dart';
import 'package:leyu_mobile/core/localization/translations/om_et_translations.dart';

/// Central translations class implementing GetX Translations interface
/// Provides translations for all supported languages in the app
class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': enUS,
        'am_ET': amET,
        'om_ET': omET,
      };
}
