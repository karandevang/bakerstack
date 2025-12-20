import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/notification_item.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<NotificationItem> _notifications = [];
  int _unreadCount = 0;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  void _loadNotifications() {
    setState(() {
      _notifications = [
        NotificationItem(
          id: '1',
          title: 'Order Delivered',
          message: 'Your order BS2024001 has been delivered successfully!',
          type: NotificationType.order,
          isRead: false,
          createdAt: DateTime.now().subtract(Duration(hours: 2)),
        ),
        NotificationItem(
          id: '2',
          title: 'Special Discount!',
          message: 'Get 30% off on all Cake Boxes this week. Limited time offer!',
          type: NotificationType.offer,
          isRead: false,
          createdAt: DateTime.now().subtract(Duration(hours: 5)),
        ),
        NotificationItem(
          id: '3',
          title: 'Order Shipped',
          message: 'Your order BS2024002 is on the way. Expected delivery: Dec 18',
          type: NotificationType.order,
          isRead: true,
          createdAt: DateTime.now().subtract(Duration(days: 1)),
        ),
        NotificationItem(
          id: '4',
          title: 'New Products Added',
          message: 'Check out our new premium macaron boxes collection!',
          type: NotificationType.product,
          isRead: true,
          createdAt: DateTime.now().subtract(Duration(days: 2)),
        ),
      ];

      _unreadCount = _notifications.where((n) => !n.isRead).length;
    });
  }

  void _markAsRead(String id) {
    setState(() {
      final notification = _notifications.firstWhere((n) => n.id == id);
      notification.isRead = true;
      _unreadCount = _notifications.where((n) => !n.isRead).length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      body: CustomScrollView(
        slivers: [
          /// HEADER
          SliverAppBar(
            pinned: true,
            expandedHeight: 140,
            backgroundColor: Color(0xFF667eea),
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                  ),
                ),
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Notifications',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.5,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '$_unreadCount unread notifications',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(15),
              child: Container(
                height: 20,
                decoration: const BoxDecoration(
                  color: Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(25),
                  ),
                ),
              ),
            ),
          ),

          /// CONTENT
          _notifications.isEmpty
              ? SliverFillRemaining(
            child: _buildEmptyState(),
          )
              : SliverPadding(
            padding: EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  return _buildNotificationCard(_notifications[index]);
                },
                childCount: _notifications.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(NotificationItem notification) {
    final isUnread = !notification.isRead;

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isUnread ? Color(0xFF6B73FF) : Colors.transparent,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            if (isUnread) _markAsRead(notification.id);
          },
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: _getNotificationColor(notification.type),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _getNotificationIcon(notification.type),
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notification.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        notification.message,
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF666666),
                          height: 1.4,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        _formatTime(notification.createdAt),
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF999999),
                        ),
                      ),
                    ],
                  ),
                ),

                if (isUnread)
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Color(0xFF6B73FF),
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
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
          Icon(Icons.notifications_none, size: 80, color: Color(0xFFCCCCCC)),
          SizedBox(height: 16),
          Text(
            'No notifications yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF666666),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.order:
        return Icons.inventory_2;
      case NotificationType.product:
        return Icons.notifications;
      case NotificationType.offer:
        return Icons.local_offer;
      case NotificationType.payment:
        return Icons.payment;
      case NotificationType.marketplace:
        return Icons.store;
      default:
        return Icons.notifications;
    }
  }

  Color _getNotificationColor(NotificationType type) {
    switch (type) {
      case NotificationType.order:
      case NotificationType.offer:
        return Color(0xFF6B73FF);
      case NotificationType.product:
        return Color(0xFF999999);
      case NotificationType.payment:
        return Color(0xFF8B5CF6);
      case NotificationType.marketplace:
        return Color(0xFFEC4899);
      default:
        return Color(0xFF6B73FF);
    }
  }

  String _formatTime(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);

    if (diff.inHours < 1) return '${diff.inMinutes} minutes ago';
    if (diff.inHours < 24) return '${diff.inHours} hours ago';
    if (diff.inDays < 7) {
      return '${diff.inDays} ${diff.inDays == 1 ? 'day' : 'days'} ago';
    }
    return DateFormat('MMM d').format(dateTime);
  }
}
