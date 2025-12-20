// lib/screens/main_screen.dart
// Version WITHOUT Provider - using simple state management

import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'cart_screen.dart';
import 'marketplace_feed_screen.dart';
import 'notifications_screen.dart';
import 'profile_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  int _unreadNotifications = 2; // Hardcoded for now - will update via callback later

  // Screens for each tab
  final List<Widget> _screens = [
    HomeScreen(),
    CartScreen(),
    MarketplaceFeedScreen(),
    NotificationsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: BottomAppBar(
          color: Colors.white,
          elevation: 0,
          notchMargin: 8,
          shape: CircularNotchedRectangle(),
          child: SizedBox(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Home
                Expanded(
                  child: _buildNavItem(
                    icon: Icons.home_outlined,
                    activeIcon: Icons.home,
                    label: 'Home',
                    index: 0,
                  ),
                ),

                // Cart
                Expanded(
                  child: _buildNavItem(
                    icon: Icons.shopping_cart_outlined,
                    activeIcon: Icons.shopping_cart,
                    label: 'Cart',
                    index: 1,
                  ),
                ),

                // Marketplace (Circular Button - Special)
                SizedBox(width: 56), // Space for the circular button

                // Notifications with badge (NO PROVIDER)
                Expanded(
                  child: _buildNavItemWithBadge(
                    icon: Icons.notifications_outlined,
                    activeIcon: Icons.notifications,
                    label: 'Alerts',
                    index: 3,
                    badgeCount: _unreadNotifications,
                  ),
                ),

                // Profile
                Expanded(
                  child: _buildNavItem(
                    icon: Icons.person_outline,
                    activeIcon: Icons.person,
                    label: 'Profile',
                    index: 4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      // Circular Marketplace Button (Floating)
      floatingActionButton: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF667eea), Color(0xFF764ba2)],
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Color(0xFF667eea).withOpacity(0.4),
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              setState(() => _currentIndex = 2);
            },
            borderRadius: BorderRadius.circular(28),
            child: Icon(
              Icons.store_outlined,
              color: Colors.white,
              size: 28,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
  }) {
    final isActive = _currentIndex == index;

    return InkWell(
      onTap: () {
        setState(() => _currentIndex = index);
      },
      borderRadius: BorderRadius.circular(12),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              color: isActive ? Color(0xFF667eea) : Color(0xFF9CA3AF),
              size: 24,
            ),
            SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: isActive ? Color(0xFF667eea) : Color(0xFF9CA3AF),
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItemWithBadge({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
    required int badgeCount,
  }) {
    final isActive = _currentIndex == index;

    return InkWell(
      onTap: () {
        setState(() => _currentIndex = index);
      },
      borderRadius: BorderRadius.circular(12),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon with badge
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  isActive ? activeIcon : icon,
                  color: isActive ? Color(0xFF667eea) : Color(0xFF9CA3AF),
                  size: 24,
                ),
                if (badgeCount > 0)
                  Positioned(
                    right: -8,
                    top: -6,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                      decoration: BoxDecoration(
                        color: Color(0xFFEF4444),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Center(
                        child: Text(
                          badgeCount > 99 ? '99+' : badgeCount.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            height: 1.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: isActive ? Color(0xFF667eea) : Color(0xFF9CA3AF),
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Method to update notification count (call from notifications screen)
  void updateNotificationCount(int count) {
    setState(() {
      _unreadNotifications = count;
    });
  }
}
