// lib/screens/about_us_screen.dart
// About BakerStack app and company information

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsScreen extends StatelessWidget {
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
                    padding: EdgeInsets.all(20),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                        SizedBox(width: 12),
                        Text(
                          'About Us',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Logo and App Info
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 32),
                    child: Column(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 20,
                                offset: Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.cake_outlined,
                            size: 50,
                            color: Color(0xFF6B73FF),
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'BakerStack',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Version 1.0.0',
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
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Mission Card
                  _buildInfoCard(
                    icon: Icons.rocket_launch,
                    title: 'Our Mission',
                    description: 'To empower bakeries across India with a one-stop platform for all their supply needs - from packaging materials to raw ingredients and used equipment.',
                  ),
                  SizedBox(height: 16),

                  // Vision Card
                  _buildInfoCard(
                    icon: Icons.visibility,
                    title: 'Our Vision',
                    description: 'To become India\'s largest vertical marketplace for the bakery industry, connecting suppliers and bakery owners seamlessly.',
                  ),
                  SizedBox(height: 16),

                  // What We Offer
                  _buildInfoCard(
                    icon: Icons.storefront,
                    title: 'What We Offer',
                    description: 'BakerStack is your complete bakery supply solution:\n\n• E-commerce for packaging materials\n• Raw ingredients (flour, sugar, chocolate, etc.)\n• Marketplace for used bakery equipment\n• Direct supplier connections\n• Competitive pricing\n• Fast delivery across India',
                  ),
                  SizedBox(height: 24),

                  // Features Grid
                  Text(
                    'Key Features',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  SizedBox(height: 16),

                  _buildFeaturesGrid(),
                  SizedBox(height: 24),

                  // Contact & Social
                  Text(
                    'Connect With Us',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  SizedBox(height: 16),

                  _buildSocialLinks(),
                  SizedBox(height: 24),

                  // Company Info
                  _buildCompanyInfo(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
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
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Color(0xFF6B73FF).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Color(0xFF6B73FF), size: 24),
              ),
              SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            description,
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

  Widget _buildFeaturesGrid() {
    final features = [
      {'icon': Icons.shopping_cart, 'title': 'Easy Shopping'},
      {'icon': Icons.local_shipping, 'title': 'Fast Delivery'},
      {'icon': Icons.verified_user, 'title': 'Secure Payments'},
      {'icon': Icons.support_agent, 'title': '24/7 Support'},
      {'icon': Icons.inventory_2, 'title': 'Wide Catalog'},
      {'icon': Icons.price_check, 'title': 'Best Prices'},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.5,
      ),
      itemCount: features.length,
      itemBuilder: (context, index) {
        final feature = features[index];
        return Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Color(0xFFE5E7EB)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                feature['icon'] as IconData,
                color: Color(0xFF6B73FF),
                size: 32,
              ),
              SizedBox(height: 8),
              Text(
                feature['title'] as String,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A1A),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSocialLinks() {
    return Container(
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
        children: [
          _buildSocialButton(
            icon: Icons.language,
            title: 'Website',
            subtitle: 'www.bakerstack.com',
            onTap: () => _launchUrl('https://bakerstack.com'),
          ),
          Divider(height: 24),
          _buildSocialButton(
            icon: Icons.email,
            title: 'Email',
            subtitle: 'support@bakerstack.com',
            onTap: () => _launchUrl('mailto:support@bakerstack.com'),
          ),
          Divider(height: 24),
          _buildSocialButton(
            icon: Icons.phone,
            title: 'Phone',
            subtitle: '+91 1800-123-4567',
            onTap: () => _launchUrl('tel:+911800123456'),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Color(0xFF6B73FF).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Color(0xFF6B73FF), size: 24),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFF9CA3AF)),
        ],
      ),
    );
  }

  Widget _buildCompanyInfo() {
    return Container(
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
            'Company Information',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          SizedBox(height: 16),
          _buildInfoRow(Icons.business, 'BakerStack Technologies Pvt Ltd'),
          SizedBox(height: 12),
          _buildInfoRow(Icons.location_on, 'Mumbai, Maharashtra, India'),
          SizedBox(height: 12),
          _buildInfoRow(Icons.calendar_today, 'Established 2024'),
          SizedBox(height: 16),
          Divider(),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Made with ❤️ for the Indian bakery community',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF6B7280),
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Color(0xFF6B73FF)),
        SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF374151),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}