import 'package:flutter/material.dart';
import 'package:leyu_mobile/core/theme/app_colors.dart';

class NotificationDateSectionWidget extends StatelessWidget {
  final String dateCategory;

  const NotificationDateSectionWidget({
    super.key,
    required this.dateCategory,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      color: AppColors.appBgColor,
      child: Text(
        dateCategory,
        style: const TextStyle(
          fontSize: 13.0,
          fontWeight: FontWeight.w600,
          color: AppColors.grayText,
        ),
      ),
    );
  }
}
