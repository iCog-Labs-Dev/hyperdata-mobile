import 'package:get/get.dart';
import 'package:leyu_mobile/core/utils/message.dart';
import 'package:leyu_mobile/features/notification/domain/entities/notification_entity.dart';
import 'package:leyu_mobile/features/notification/domain/usecases/notification_usecase.dart';

class NotificationController extends GetxController {
  final NotificationUsecase _usecase;

  NotificationController(this._usecase);

  // Observable state variables
  RxList<NotificationEntity> notifications = <NotificationEntity>[].obs;
  RxBool isLoading = false.obs;
  RxBool isLoadingMore = false.obs;
  RxBool hasMore = true.obs;
  RxBool hasError = false.obs;
  RxString errorMessage = ''.obs;
  RxInt currentPage = 1.obs;
  RxInt unreadCount = 0.obs;

  final int pageSize = 10;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
    fetchUnreadCount();
  }

  /// Fetch notifications with pagination support
  Future<void> fetchNotifications({bool nextPage = false}) async {
    try {
      // Prevent loading more if no more data available
      if (nextPage && !hasMore.value) return;

      // Set appropriate loading state
      if (nextPage) {
        isLoadingMore.value = true;
      } else {
        isLoading.value = true;
        currentPage.value = 1;
        hasError.value = false;
        errorMessage.value = '';
        // Don't clear notifications on refresh to maintain UI
        if (notifications.isEmpty) {
          notifications.clear();
        }
      }

      // Fetch notifications from use case
      final response = await _usecase.getNotifications(
        page: currentPage.value,
        limit: pageSize,
      );

      // Handle null response (error already shown by use case)
      if (response == null) {
        // Set error state for initial load
        if (!nextPage && notifications.isEmpty) {
          hasError.value = true;
          errorMessage.value = 'Failed to load notifications';
        }
        hasMore.value = false;
        return;
      }

      // Convert models to entities
      final entities = _usecase.convertToEntities(response);

      // Update notifications list
      if (nextPage) {
        notifications.addAll(entities);
      } else {
        notifications.value = entities;
      }

      // Clear error state on success
      hasError.value = false;
      errorMessage.value = '';

      // Update pagination state
      hasMore.value = entities.length == pageSize;
      if (hasMore.value) {
        currentPage.value++;
      }
    } catch (e) {
      print('Error fetching notifications: $e');

      // Set error state for initial load
      if (!nextPage && notifications.isEmpty) {
        hasError.value = true;
        errorMessage.value = 'An unexpected error occurred';
      }

      hasMore.value = false;
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  /// Fetch unread notification count
  Future<void> fetchUnreadCount() async {
    try {
      final count = await _usecase.getUnreadCount();
      unreadCount.value = count;
    } catch (e) {
      print('Error fetching unread count: $e');
      // Silently fail - don't show error to user for count
      unreadCount.value = 0;
    }
  }

  /// Retry fetching notifications after an error
  Future<void> retryFetchNotifications() async {
    await fetchNotifications(nextPage: false);
  }

  /// Mark notification as read with optimistic UI updates
  Future<void> markNotificationAsRead(String notificationId) async {
    try {
      // Find the notification in the list
      final index = notifications.indexWhere((n) => n.id == notificationId);
      if (index == -1) return;

      // Check if already read
      if (notifications[index].isRead) return;

      // Store original notification for rollback
      final originalNotification = notifications[index];

      // Optimistic UI update - create a new entity with isRead = true
      final updatedNotification = NotificationEntity(
        id: originalNotification.id,
        userId: originalNotification.userId,
        title: originalNotification.title,
        message: originalNotification.message,
        type: originalNotification.type,
        isRead: true,
        createdDate: originalNotification.createdDate,
        updatedDate: originalNotification.updatedDate,
      );

      // Update UI immediately
      notifications[index] = updatedNotification;
      if (unreadCount.value > 0) {
        unreadCount.value--;
      }

      // Make API call
      final success = await _usecase.markAsRead(notificationId);

      // Rollback on failure
      if (!success) {
        notifications[index] = originalNotification;
        if (unreadCount.value < 99) {
          unreadCount.value++;
        }
      }
    } catch (e) {
      print('Error marking notification as read: $e');
      showErrorMessage('Failed to mark notification as read');
    }
  }

  /// Refresh notifications for pull-to-refresh
  Future<void> refreshNotifications() async {
    await fetchNotifications(nextPage: false);
    await fetchUnreadCount();
  }

  /// Get notifications grouped by date categories
  Map<String, List<NotificationEntity>> getGroupedNotifications() {
    return _usecase.groupNotificationsByDate(notifications);
  }
}
