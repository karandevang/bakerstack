import 'package:flutter/material.dart';
import '../models/notification_item.dart';
import '../utils/colors.dart';

class NotificationsScreen extends StatelessWidget {
  final List notifications = [
    NotificationItem(title: 'Order Update', message: 'Your order of ID:4 out for delivery'),
    NotificationItem(title: 'Order Update', message: 'Your order of ID:2 out for delivery'),
    NotificationItem(title: 'Order Update', message: 'Your order of ID:1 out for delivery'),
    NotificationItem(title: 'Order Update', message: 'Your Order of Id:3 is packed'),
    NotificationItem(title: 'Order Update', message: 'Your Order of Id:2 is packed'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              // App Bar
              Container(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Text(
                      'Notifications',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    Icon(Icons.shopping_cart, color: Colors.white),
                  ],
                ),
              ),
              // Content
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                  ),
                  child: ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      final notification = notifications[index];
                      return Container(
                        margin: EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.white.withOpacity(0.2)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ListTile(
                          leading: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Icon(Icons.notifications, color: Colors.white),
                          ),
                          title: Text(notification.title, style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(notification.message),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}