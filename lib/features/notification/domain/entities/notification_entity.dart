import 'package:leyu_mobile/core/utils/date_formatter.dart';
import 'package:leyu_mobile/features/notification/data/models/notification_model.dart';

class NotificationEntity {
  final String id;
  final String userId;
  final String title;
  final String message;
  final String type;
  final bool isRead;
  final DateTime createdDate;
  final DateTime updatedDate;

  NotificationEntity({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.type,
    required this.isRead,
    required this.createdDate,
    required this.updatedDate,
  });

  /// Factory to convert from NotificationModel
  factory NotificationEntity.fromModel(NotificationModel model) {
    return NotificationEntity(
      id: model.id,
      userId: model.userId,
      title: model.title,
      message: model.message,
      type: model.type,
      isRead: model.isRead,
      createdDate: model.createdDate,
      updatedDate: model.updatedDate,
    );
  }

  /// Check if notification was created today (considering local timezone)
  bool isToday() {
    final now = DateTime.now();
    final localCreatedDate = createdDate.toLocal();
    return localCreatedDate.year == now.year &&
        localCreatedDate.month == now.month &&
        localCreatedDate.day == now.day;
  }

  /// Check if notification was created yesterday (considering local timezone)
  bool isYesterday() {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    final localCreatedDate = createdDate.toLocal();
    return localCreatedDate.year == yesterday.year &&
        localCreatedDate.month == yesterday.month &&
        localCreatedDate.day == yesterday.day;
  }

  /// Get date category for grouping (Today, Yesterday, or formatted date)
  /// Uses the existing DateFormatter utility for consistent formatting
  String getDateCategory() {
    if (isToday()) {
      return 'Today';
    } else if (isYesterday()) {
      return 'Yesterday';
    } else {
      // Use the existing DateFormatter utility for locale-aware formatting
      return formatDate(createdDate.toLocal());
    }
  }

  /// Get formatted time for display using DateFormatter utility
  String getFormattedTime() {
    return formatTime(createdDate.toLocal());
  }

  /// Get formatted date and time for display in user-friendly format
  /// Examples: "Today, 8:50 AM", "Yesterday, 3:45 PM", "Nov 15, 2025, 10:30 AM"
  String getFormattedDateTime() {
    final localCreatedDate = createdDate.toLocal();

    if (isToday()) {
      return 'Today, ${formatTime(localCreatedDate)}';
    } else if (isYesterday()) {
      return 'Yesterday, ${formatTime(localCreatedDate)}';
    } else {
      // Use DateFormatter utility for consistent locale-aware formatting
      return formatDateTime(localCreatedDate);
    }
  }
}
