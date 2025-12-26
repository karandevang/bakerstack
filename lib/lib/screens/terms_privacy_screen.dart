// lib/screens/terms_privacy_screen.dart
// Terms of Service and Privacy Policy

import 'package:flutter/material.dart';

class TermsPrivacyScreen extends StatefulWidget {
  final int initialTab; // 0 = Terms, 1 = Privacy

  TermsPrivacyScreen({this.initialTab = 0});

  @override
  _TermsPrivacyScreenState createState() => _TermsPrivacyScreenState();
}

class _TermsPrivacyScreenState extends State<TermsPrivacyScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTab,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      body: Column(
        children: [
          // Header
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF6B73FF), Color(0xFF9F7FFF)],
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 16),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Legal',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Terms & Privacy Policy',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Tabs
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicatorSize: TabBarIndicatorSize.tab, // Fill the tab
                      indicator: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      labelColor: Color(0xFF6B73FF),
                      unselectedLabelColor: Colors.white,
                      labelStyle: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                      dividerColor: Colors.transparent, // Remove divider
                      tabs: [
                        Tab(text: 'Terms of Service'),
                        Tab(text: 'Privacy Policy'),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // Tab Views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTermsOfService(),
                _buildPrivacyPolicy(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTermsOfService() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildUpdateInfo('Last updated: December 2024'),
          SizedBox(height: 24),

          _buildSection(
            'Acceptance of Terms',
            'By accessing and using BakerStack, you accept and agree to be bound by the terms and provision of this agreement. If you do not agree to these terms, please do not use our services.',
          ),

          _buildSection(
            'Use of Service',
            'BakerStack provides a marketplace platform for bakery supplies and equipment. You agree to use the service only for lawful purposes and in accordance with these terms.',
          ),

          _buildSection(
            'User Accounts',
            'You are responsible for:\n\n• Maintaining the confidentiality of your account\n• All activities that occur under your account\n• Notifying us immediately of any unauthorized use\n• Providing accurate and complete information',
          ),

          _buildSection(
            'Prohibited Activities',
            'You may not:\n\n• Use the service for any illegal purpose\n• Violate any laws in your jurisdiction\n• Infringe upon intellectual property rights\n• Transmit viruses or malicious code\n• Harass, abuse, or harm other users\n• Impersonate any person or entity',
          ),

          _buildSection(
            'Products and Pricing',
            '• All prices are in Indian Rupees (INR)\n• Prices are subject to change without notice\n• We reserve the right to refuse or cancel orders\n• Product availability may vary\n• Images are for reference only',
          ),

          _buildSection(
            'Orders and Payment',
            '• Orders are subject to acceptance and availability\n• Payment must be made before delivery\n• We accept multiple payment methods\n• All transactions are secure and encrypted\n• Refunds processed as per our refund policy',
          ),

          _buildSection(
            'Delivery',
            '• Delivery times are estimates only\n• We are not liable for delays beyond our control\n• Delivery charges may apply\n• You must provide accurate delivery information\n• Risk passes to you upon delivery',
          ),

          _buildSection(
            'Returns and Refunds',
            '• Returns accepted within 7 days of delivery\n• Products must be unused and in original packaging\n• Refunds processed within 7-10 business days\n• Shipping charges are non-refundable\n• Damaged items reported within 24 hours',
          ),

          _buildSection(
            'Intellectual Property',
            'All content, trademarks, and data on BakerStack are our intellectual property or licensed to us. You may not use, copy, or distribute any content without our written permission.',
          ),

          _buildSection(
            'Limitation of Liability',
            'BakerStack shall not be liable for any indirect, incidental, special, or consequential damages arising from your use of the service.',
          ),

          _buildSection(
            'Indemnification',
            'You agree to indemnify and hold BakerStack harmless from any claims, damages, or expenses arising from your use of the service or violation of these terms.',
          ),

          _buildSection(
            'Modifications',
            'We reserve the right to modify these terms at any time. Continued use of the service constitutes acceptance of modified terms.',
          ),

          _buildSection(
            'Governing Law',
            'These terms are governed by the laws of India. Any disputes shall be subject to the exclusive jurisdiction of courts in Mumbai, Maharashtra.',
          ),

          _buildSection(
            'Contact Information',
            'For questions about these terms, contact us at:\n\nEmail: legal@bakerstack.com\nPhone: +91 1800-123-4567\nAddress: Mumbai, Maharashtra, India',
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyPolicy() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildUpdateInfo('Last updated: December 2024'),
          SizedBox(height: 24),

          _buildSection(
            'Introduction',
            'BakerStack ("we", "our", or "us") is committed to protecting your privacy. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our mobile application and services.',
          ),

          _buildSection(
            'Information We Collect',
            'Personal Information:\n• Name and contact information\n• Email address and phone number\n• Delivery addresses\n• Payment information\n• Business details (GST, PAN)\n\nUsage Information:\n• Device information\n• IP address and location data\n• App usage statistics\n• Search and browsing history\n• Order history and preferences',
          ),

          _buildSection(
            'How We Use Your Information',
            'We use your information to:\n\n• Process and fulfill your orders\n• Communicate about your orders\n• Improve our services\n• Send promotional offers (with consent)\n• Prevent fraud and enhance security\n• Comply with legal obligations\n• Analyze usage patterns and trends',
          ),

          _buildSection(
            'Information Sharing',
            'We may share your information with:\n\n• Service providers and delivery partners\n• Payment processors\n• Legal authorities when required\n• Business partners (with consent)\n\nWe do NOT sell your personal information to third parties.',
          ),

          _buildSection(
            'Data Security',
            'We implement industry-standard security measures to protect your information:\n\n• Encryption of sensitive data\n• Secure payment processing\n• Regular security audits\n• Access controls and authentication\n• Secure data storage\n\nHowever, no method of transmission over the internet is 100% secure.',
          ),

          _buildSection(
            'Cookies and Tracking',
            'We use cookies and similar technologies to:\n\n• Remember your preferences\n• Analyze app usage\n• Provide personalized content\n• Improve user experience\n\nYou can control cookie settings in your device settings.',
          ),

          _buildSection(
            'Your Rights',
            'You have the right to:\n\n• Access your personal information\n• Correct inaccurate information\n• Delete your account and data\n• Opt-out of marketing communications\n• Request data portability\n• Withdraw consent at any time',
          ),

          _buildSection(
            'Data Retention',
            'We retain your information for as long as necessary to:\n\n• Fulfill the purposes outlined in this policy\n• Comply with legal obligations\n• Resolve disputes\n• Enforce our agreements\n\nInactive accounts may be deleted after 3 years.',
          ),

          _buildSection(
            'Children\'s Privacy',
            'Our service is not intended for children under 18. We do not knowingly collect information from children. If you believe we have collected information from a child, please contact us immediately.',
          ),

          _buildSection(
            'Third-Party Links',
            'Our app may contain links to third-party websites. We are not responsible for their privacy practices. Please review their privacy policies before providing any information.',
          ),

          _buildSection(
            'Changes to Privacy Policy',
            'We may update this Privacy Policy from time to time. We will notify you of any changes by posting the new policy on this page and updating the "Last updated" date.',
          ),

          _buildSection(
            'International Data Transfers',
            'Your information may be transferred to and processed in countries other than India. We ensure appropriate safeguards are in place for such transfers.',
          ),

          _buildSection(
            'Contact Us',
            'If you have questions about this Privacy Policy or our data practices, contact us at:\n\nEmail: privacy@bakerstack.com\nPhone: +91 1800-123-4567\nAddress: BakerStack Technologies Pvt Ltd\nMumbai, Maharashtra, India',
          ),

          _buildSection(
            'Consent',
            'By using BakerStack, you consent to our Privacy Policy and agree to its terms.',
          ),
        ],
      ),
    );
  }

  Widget _buildUpdateInfo(String text) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFF6B73FF).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Color(0xFF6B73FF).withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Color(0xFF6B73FF), size: 20),
          SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF374151),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF6B7280),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}