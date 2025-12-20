
class NotificationItem {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  bool isRead;
  final DateTime createdAt;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.isRead,
    required this.createdAt,
  });
}

enum NotificationType {
  order,
  product,
  offer,
  payment,
  marketplace,
}