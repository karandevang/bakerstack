// lib/screens/notifications_screen.dart
import 'package:flutter/material.dart';
import '../models/notification_item.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  // Sample notifications (since backend doesn't have this yet)
  final List<NotificationItem> _notifications = [
    NotificationItem(
      id: '1',
      title: 'Order Delivered',
      message: 'Your order #123 has been delivered successfully!',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: false,
      type: 'order',
    ),
    NotificationItem(
      id: '2',
      title: 'New Product Available',
      message: 'Check out our new industrial mixer in the Packaging category!',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      isRead: false,
      type: 'product',
    ),
    NotificationItem(
      id: '3',
      title: 'Order Shipped',
      message: 'Your order #122 has been shipped and will arrive in 2-3 days.',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      isRead: true,
      type: 'order',
    ),
    NotificationItem(
      id: '4',
      title: 'Wishlist Item on Sale',
      message: 'Premium Baking Tray from your wishlist is now 30% off!',
      timestamp: DateTime.now().subtract(const Duration(days: 3)),
      isRead: true,
      type: 'wishlist',
    ),
    NotificationItem(
      id: '5',
      title: 'Marketplace Listing Sold',
      message: 'Your listing "Industrial Oven" has been marked as sold.',
      timestamp: DateTime.now().subtract(const Duration(days: 5)),
      isRead: true,
      type: 'marketplace',
    ),
  ];

  void _markAsRead(String id) {
    setState(() {
      final notification = _notifications.firstWhere((n) => n.id == id);
      // In real app, call API to mark as read
      // For now, just update local state
    });
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in _notifications) {
        // In real app, call API
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All notifications marked as read'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _deleteNotification(String id) {
    setState(() {
      _notifications.removeWhere((n) => n.id == id);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Notification deleted'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _clearAll() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Notifications'),
        content: const Text('Are you sure you want to clear all notifications?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() {
        _notifications.clear();
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('All notifications cleared'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final unreadCount = _notifications.where((n) => !n.isRead).length;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Notifications'),
            if (unreadCount > 0)
              Text(
                '$unreadCount unread',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                ),
              ),
          ],
        ),
        backgroundColor: const Color(0xFF7B2CBF),
        actions: [
          if (unreadCount > 0)
            TextButton(
              onPressed: _markAllAsRead,
              child: const Text(
                'Mark all read',
                style: TextStyle(color: Colors.white),
              ),
            ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'clear_all') {
                _clearAll();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'clear_all',
                child: Text('Clear all'),
              ),
            ],
          ),
        ],
      ),
      body: _notifications.isEmpty
          ? _buildEmptyState()
          : ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: _notifications.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final notification = _notifications[index];
          return _buildNotificationItem(notification);
        },
      ),
    );
  }

  Widget _buildNotificationItem(NotificationItem notification) {
    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        _deleteNotification(notification.id);
      },
      child: InkWell(
        onTap: () {
          _markAsRead(notification.id);
          _handleNotificationTap(notification);
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          color: notification.isRead ? Colors.white : const Color(0xFF7B2CBF).withOpacity(0.05),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _getNotificationColor(notification.type).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getNotificationIcon(notification.type),
                  color: _getNotificationColor(notification.type),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: notification.isRead
                                  ? FontWeight.w600
                                  : FontWeight.bold,
                            ),
                          ),
                        ),
                        if (!notification.isRead)
                          Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              color: Color(0xFF7B2CBF),
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.message,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _formatTimestamp(notification.timestamp),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 120,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 24),
          const Text(
            'No notifications',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'We\'ll notify you when something new arrives!',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  void _handleNotificationTap(NotificationItem notification) {
    switch (notification.type) {
      case 'order':
        Navigator.pushNamed(context, '/orders');
        break;
      case 'product':
        Navigator.pushNamed(context, '/home');
        break;
      case 'wishlist':
        Navigator.pushNamed(context, '/wishlist');
        break;
      case 'marketplace':
        Navigator.pushNamed(context, '/my-listings');
        break;
      default:
        break;
    }
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'order':
        return Icons.shopping_bag;
      case 'product':
        return Icons.new_releases;
      case 'wishlist':
        return Icons.favorite;
      case 'marketplace':
        return Icons.storefront;
      default:
        return Icons.notifications;
    }
  }

  Color _getNotificationColor(String type) {
    switch (type) {
      case 'order':
        return Colors.blue;
      case 'product':
        return Colors.green;
      case 'wishlist':
        return Colors.red;
      case 'marketplace':
        return Colors.orange;
      default:
        return const Color(0xFF7B2CBF);
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return '${timestamp.day} ${months[timestamp.month - 1]}';
    }
  }
}