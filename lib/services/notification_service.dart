// lib/services/notification_service.dart
// Service to manage notification count

import 'package:flutter/foundation.dart';

class NotificationService extends ChangeNotifier {
  int _unreadCount = 0;

  int get unreadCount => _unreadCount;

  // Update unread count
  void setUnreadCount(int count) {
    _unreadCount = count;
    notifyListeners();
  }

  // Increment unread count (when new notification arrives)
  void incrementUnreadCount() {
    _unreadCount++;
    notifyListeners();
  }

  // Decrement unread count (when notification is marked as read)
  void decrementUnreadCount() {
    if (_unreadCount > 0) {
      _unreadCount--;
      notifyListeners();
    }
  }

  // Mark all as read
  void markAllAsRead() {
    _unreadCount = 0;
    notifyListeners();
  }

  // Fetch unread count from API
  Future<void> fetchUnreadCount() async {
    // TODO: Call your backend API to get unread notification count
    // For now, using mock data
    await Future.delayed(Duration(milliseconds: 500));
    _unreadCount = 2; // Mock data
    notifyListeners();
  }
}