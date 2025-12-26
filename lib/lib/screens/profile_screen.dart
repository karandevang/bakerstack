// lib/screens/profile_screen.dart
// Updated with navigation to all profile-related screens

import 'package:bakerstack/screens/terms_privacy_screen.dart';
import 'package:bakerstack/screens/wishlist_screen.dart';
import 'package:flutter/material.dart';
import 'about_us_screen.dart';
import 'buisness_details_screen.dart';
import 'contact_us_screen.dart';
import 'delivery_addresses_screen.dart';
import 'edit_profile_screen.dart';
import 'my_listing_screen.dart';
import 'orders_screen.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header with gradient
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF6B73FF), Color(0xFF9F7FFF)],
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(24, 24, 24, 32),
                  child: Column(
                    children: [
                      // User Info Card
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            // Avatar
                            Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.person,
                                size: 40,
                                color: Color(0xFF6B73FF),
                              ),
                            ),
                            SizedBox(width: 16),

                            // User Details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Karan Patel',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    '+91 9876543210',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.9),
                                      fontSize: 15,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'karan@bakerstack.com',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.9),
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Menu Items
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  // Account Section
                  _buildSectionTitle('Account'),
                  _buildMenuItem(
                    context,
                    icon: Icons.person_outline,
                    title: 'My Profile',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfileScreen(),
                        ),
                      );
                    },
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.favorite_outline,
                    title: 'My Wishlist',
                    onTap: () {
                      Navigator.push(
                      context,
                      MaterialPageRoute(
                      builder: (context) => WishlistScreen(),
                      ),
                      );
                    },
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.shopping_bag_outlined,
                    title: 'My Orders',
                    onTap: () {
                      Navigator.push(
                      context,
                      MaterialPageRoute(
                      builder: (context) => OrdersScreen(),
                      ),
                      );
                    },
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.inventory_2_outlined,
                    title: 'My Listings',
                    badge: '2',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyListingsScreen(),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 16),

                  // Business Section
                  _buildSectionTitle('Business'),
                  _buildMenuItem(
                    context,
                    icon: Icons.business_outlined,
                    title: 'Business Details',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BusinessDetailsScreen(),
                        ),
                      );
                    },
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.location_on_outlined,
                    title: 'Delivery Addresses',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DeliveryAddressesScreen(),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 16),

                  // Support Section
                  _buildSectionTitle('Support & Legal'),
                  _buildMenuItem(
                    context,
                    icon: Icons.help_outline,
                    title: 'Contact Us',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ContactUsScreen(),
                        ),
                      );
                    },
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.info_outline,
                    title: 'About Us',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AboutUsScreen(),
                        ),
                      );
                    },
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.description_outlined,
                    title: 'Terms & Conditions',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TermsPrivacyScreen(),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 16),

                  // Logout Button
                  Container(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => _showLogoutDialog(context),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: Color(0xFFEF4444), width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.logout,
                            color: Color(0xFFEF4444),
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Logout',
                            style: TextStyle(
                              color: Color(0xFFEF4444),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 32),

                  // Version
                  Text(
                    'Version 1.0.0',
                    style: TextStyle(
                      color: Color(0xFF9CA3AF),
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 4, bottom: 12, top: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF6B7280),
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(
      BuildContext context, {
        required IconData icon,
        required String title,
        required VoidCallback onTap,
        String? badge,
      }) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Color(0xFF6B73FF).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: Color(0xFF6B73FF),
            size: 22,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1F2937),
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (badge != null)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Color(0xFFEF4444),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  badge,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            SizedBox(width: 8),
            Icon(
              Icons.chevron_right,
              color: Color(0xFF9CA3AF),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text('Logout'),
        content: Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement logout logic
              // Clear shared preferences
              // Navigate to login screen
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Logged out successfully'),
                  backgroundColor: Color(0xFF10B981),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFEF4444),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.info_outline, color: Colors.white),
            SizedBox(width: 12),
            Expanded(
              child: Text('$feature coming soon!'),
            ),
          ],
        ),
        backgroundColor: Color(0xFF6B73FF),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: Duration(seconds: 2),
      ),
    );
  }
}