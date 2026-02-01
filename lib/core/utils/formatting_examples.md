# Date and Number Formatting Examples

This document provides examples of how to use the locale-aware formatting functions in `date_formatter.dart`.

## Date Formatting

### Format Date
```dart
import 'package:leyu_mobile/core/utils/date_formatter.dart';

final date = DateTime.now();
final formatted = formatDate(date);
// English: Jan 10, 2025
// Amharic: ጃንዩ 10, 2025
// Afan Oromo: Jan 10, 2025
```

### Format Date with Time
```dart
final dateTime = DateTime.now();
final formatted = formatDateTime(dateTime);
// English: Jan 10, 2025, 3:45 PM
// Amharic: ጃንዩ 10, 2025, 3:45 ከሰዓት
// Afan Oromo: Jan 10, 2025, 3:45 PM
```

### Format Time Only
```dart
final time = DateTime.now();
final formatted = formatTime(time);
// English: 3:45 PM
// Amharic: 3:45 ከሰዓት
// Afan Oromo: 3:45 PM
```

## Number Formatting

### Format Number
```dart
final number = 1234567.89;
final formatted = formatNumber(number);
// English: 1,234,567.89
// Amharic: 1,234,567.89
// Afan Oromo: 1,234,567.89
```

### Format Currency
```dart
final amount = 1500.50;
final formatted = formatCurrency(amount, currencySymbol: 'ETB');
// English: ETB1,500.50
// Amharic: ETB1,500.50
// Afan Oromo: ETB1,500.50
```

### Format Percentage
```dart
final percentage = 0.75; // 75%
final formatted = formatPercentage(percentage);
// English: 75%
// Amharic: 75%
// Afan Oromo: 75%
```

## Automatic Updates

All formatting functions automatically use the current locale from `LocalizationController`. When the user changes the language, any widgets that use these functions will automatically update to show the new format.

## Usage in Widgets

```dart
import 'package:leyu_mobile/core/utils/date_formatter.dart';

class MyWidget extends StatelessWidget {
  final DateTime date;
  final double amount;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(formatDate(date)),
        Text(formatCurrency(amount, currencySymbol: 'ETB')),
      ],
    );
  }
}
```

## Notes

- All functions use the `intl` package for locale-aware formatting
- Formats automatically update when the user changes language
- The `LocalizationController` must be initialized before using these functions
- Date formatting is initialized in `main.dart` using `initializeDateFormatting()`
- All functions have fallback formatting if locale-specific formatting fails
- Fallback formats use simple, universal patterns (e.g., "MMM dd, yyyy")
