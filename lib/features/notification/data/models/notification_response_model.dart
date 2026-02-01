import 'package:leyu_mobile/features/notification/data/models/notification_model.dart';

class NotificationResponseModel {
  final List<NotificationModel> notifications;
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  NotificationResponseModel({
    required this.notifications,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory NotificationResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    final result = data['result'] as List<dynamic>? ?? [];

    return NotificationResponseModel(
      notifications: result
          .map((item) => NotificationModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      total: data['total'] ?? 0,
      page: data['page'] ?? 1,
      limit: data['limit'] ?? 10,
      totalPages: data['totalPages'] ?? 0,
    );
  }
}
