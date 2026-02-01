import 'package:leyu_mobile/core/utils/message.dart';
import 'package:leyu_mobile/features/notification/data/models/notification_response_model.dart';
import 'package:leyu_mobile/features/notification/domain/entities/notification_entity.dart';
import 'package:leyu_mobile/features/notification/domain/repositories/notification_repository.dart';

class NotificationUsecase {
  final NotificationRepository _repository;

  NotificationUsecase(this._repository);

  /// Fetch notifications and convert to entities
  Future<NotificationResponseModel?> getNotifications({
    required int page,
    required int limit,
  }) async {
    final result = await _repository.getNotifications(
      page: page,
      limit: limit,
    );

    return result.fold(
      (failure) {
        showErrorMessage(failure.message);
        return null;
      },
      (response) => response,
    );
  }

  /// Get unread notification count
  Future<int> getUnreadCount() async {
    final result = await _repository.getUnreadCount();

    return result.fold(
      (failure) {
        // Silently fail for count - don't show error to user
        return 0;
      },
      (count) => count,
    );
  }

  /// Mark notification as read
  Future<bool> markAsRead(String notificationId) async {
    final result = await _repository.markAsRead(notificationId);

    return result.fold(
      (failure) {
        showErrorMessage(failure.message);
        return false;
      },
      (_) {
        // Success - no message needed for individual mark as read
        return true;
      },
    );
  }

  /// Mark all notifications as read
  Future<bool> markAllAsRead() async {
    final result = await _repository.markAllAsRead();

    return result.fold(
      (failure) {
        showErrorMessage(failure.message);
        return false;
      },
      (_) {
        showSuccessMessage('All notifications marked as read');
        return true;
      },
    );
  }

  /// Convert notification models to entities
  List<NotificationEntity> convertToEntities(
      NotificationResponseModel response) {
    return response.notifications
        .map((model) => NotificationEntity.fromModel(model))
        .toList();
  }

  /// Group notifications by date categories (Today, Yesterday, etc.)
  /// Ensures proper date comparison considering timezone
  /// Returns a map with date categories as keys and lists of notifications as values
  /// Categories are sorted: Today first, Yesterday second, then reverse chronological
  Map<String, List<NotificationEntity>> groupNotificationsByDate(
      List<NotificationEntity> notifications) {
    final Map<String, List<NotificationEntity>> grouped = {};
    final Map<String, DateTime> categoryDates = {};

    // Group notifications by date category
    for (var notification in notifications) {
      final category = notification.getDateCategory();
      if (!grouped.containsKey(category)) {
        grouped[category] = [];
        // Store the actual date for sorting purposes
        categoryDates[category] = notification.createdDate.toLocal();
      }
      grouped[category]!.add(notification);
    }

    // Sort notifications within each category by created date (newest first)
    grouped.forEach((key, value) {
      value.sort((a, b) => b.createdDate.compareTo(a.createdDate));
    });

    // Sort categories: Today first, Yesterday second, then reverse chronological
    final sortedKeys = grouped.keys.toList()
      ..sort((a, b) {
        // Today always comes first
        if (a == 'Today') return -1;
        if (b == 'Today') return 1;

        // Yesterday comes second
        if (a == 'Yesterday') return -1;
        if (b == 'Yesterday') return 1;

        // For other dates, sort in reverse chronological order using stored dates
        final dateA = categoryDates[a];
        final dateB = categoryDates[b];

        if (dateA != null && dateB != null) {
          return dateB.compareTo(dateA);
        }

        // Fallback to string comparison if dates not available
        return b.compareTo(a);
      });

    // Create a new map with sorted keys maintaining insertion order
    final Map<String, List<NotificationEntity>> sortedGrouped = {};
    for (var key in sortedKeys) {
      sortedGrouped[key] = grouped[key]!;
    }

    return sortedGrouped;
  }
}
