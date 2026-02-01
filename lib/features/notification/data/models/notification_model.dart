class NotificationModel {
  final String id;
  final String userId;
  final String title;
  final String message;
  final String type;
  final bool isRead;
  final DateTime createdDate;
  final DateTime updatedDate;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.type,
    required this.isRead,
    required this.createdDate,
    required this.updatedDate,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      type: json['type'] ?? '',
      isRead: json['is_read'] ?? false,
      createdDate: json['created_date'] != null
          ? DateTime.parse(json['created_date'])
          : DateTime.now(),
      updatedDate: json['updated_date'] != null
          ? DateTime.parse(json['updated_date'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'message': message,
      'type': type,
      'is_read': isRead,
      'created_date': createdDate.toIso8601String(),
      'updated_date': updatedDate.toIso8601String(),
    };
  }
}
