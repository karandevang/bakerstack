// lib/screens/marketplace_detail_screen.dart
// Marketplace listing detail with Call & WhatsApp buttons

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MarketplaceDetailScreen extends StatefulWidget {
  final Map<String, dynamic> listing;

  MarketplaceDetailScreen({required this.listing});

  @override
  _MarketplaceDetailScreenState createState() => _MarketplaceDetailScreenState();
}

class _MarketplaceDetailScreenState extends State<MarketplaceDetailScreen> {
  int _currentImageIndex = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final listing = widget.listing;
    final images = listing['images'] ?? [];
    final hasImages = images.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // Image Gallery
              SliverAppBar(
                expandedHeight: 400,
                pinned: true,
                backgroundColor: Colors.white,
                elevation: 0,
                leading: Container(
                  margin: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: Color(0xFF1A1A1A)),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    children: [
                      // Image PageView
                      hasImages
                          ? PageView.builder(
                        controller: _pageController,
                        onPageChanged: (index) {
                          setState(() => _currentImageIndex = index);
                        },
                        itemCount: images.length,
                        itemBuilder: (context, index) {
                          return Container(
                            color: Color(0xFFF5F5F5),
                            child: Image.network(
                              images[index],
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: Icon(
                                    Icons.image_outlined,
                                    size: 100,
                                    color: Color(0xFFCCCCCC),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      )
                          : Container(
                        color: Color(0xFFF5F5F5),
                        child: Center(
                          child: Icon(
                            Icons.image_outlined,
                            size: 100,
                            color: Color(0xFFCCCCCC),
                          ),
                        ),
                      ),

                      // Image Counter
                      if (hasImages && images.length > 1)
                        Positioned(
                          bottom: 16,
                          right: 16,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${_currentImageIndex + 1}/${images.length}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),

                      // Condition Badge
                      Positioned(
                        top: 60,
                        right: 16,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: _getConditionColor(listing['condition']),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            listing['condition'] ?? 'Used',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Product Details
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Price
                      Text(
                        '₹${_formatPrice(listing['price'] ?? 0)}',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6B73FF),
                        ),
                      ),
                      SizedBox(height: 12),

                      // Title
                      Text(
                        listing['title'] ?? 'Listing Title',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1A1A),
                          height: 1.3,
                        ),
                      ),
                      SizedBox(height: 16),

                      // Location
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 20,
                            color: Color(0xFF6B7280),
                          ),
                          SizedBox(width: 6),
                          Text(
                            '${listing['city']}, ${listing['state']}',
                            style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),

                      // Equipment Age
                      Row(
                        children: [
                          Icon(
                            Icons.schedule,
                            size: 20,
                            color: Color(0xFF6B7280),
                          ),
                          SizedBox(width: 6),
                          Text(
                            listing['age'] ?? 'Age not specified',
                            style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),

                      // Posted Time
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 20,
                            color: Color(0xFF6B7280),
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Posted ${_formatTime(listing['posted_at'])}',
                            style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24),

                      // Divider
                      Divider(color: Color(0xFFE5E7EB)),
                      SizedBox(height: 24),

                      // Description
                      Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        listing['description'] ?? 'No description available',
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF4B5563),
                          height: 1.6,
                        ),
                      ),
                      SizedBox(height: 24),

                      // Divider
                      Divider(color: Color(0xFFE5E7EB)),
                      SizedBox(height: 24),

                      // Seller Info
                      Text(
                        'Seller Information',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(
                            Icons.person_outline,
                            size: 20,
                            color: Color(0xFF6B7280),
                          ),
                          SizedBox(width: 8),
                          Text(
                            listing['contact_name'] ?? 'Seller',
                            style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFF4B5563),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 120), // Minimal space - reduced from 24!
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Bottom Action Buttons
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 12), // Top padding reduced to 8px
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: SafeArea(
                top: false, // Don't add top padding!
                child: Row(
                  children: [
                    // Call Button (White with Purple Border)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _makeCall(listing['contact_phone']),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          side: BorderSide(
                            color: Color(0xFF6B73FF),
                            width: 2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.phone,
                              color: Color(0xFF6B73FF),
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Call',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF6B73FF),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 12),

                    // WhatsApp Button (Green)
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _openWhatsApp(listing['contact_phone']),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF25D366), // WhatsApp green
                          padding: EdgeInsets.symmetric(vertical: 16),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.chat_bubble_outline,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'WhatsApp',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getConditionColor(String? condition) {
    switch (condition) {
      case 'Like New':
        return Color(0xFF10B981);
      case 'Good':
        return Color(0xFF3B82F6);
      case 'Fair':
        return Color(0xFFF59E0B);
      case 'Poor':
        return Color(0xFFEF4444);
      default:
        return Color(0xFF6B7280);
    }
  }

  String _formatPrice(dynamic price) {
    final priceInt = price is int ? price : int.tryParse(price.toString()) ?? 0;
    if (priceInt >= 100000) {
      return '${(priceInt / 100000).toStringAsFixed(1)}L';
    } else if (priceInt >= 1000) {
      return '${(priceInt / 1000).toStringAsFixed(0)}K';
    }
    return priceInt.toString();
  }

  String _formatTime(dynamic postedAt) {
    if (postedAt == null) return 'recently';
    try {
      final date = DateTime.parse(postedAt.toString());
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays == 0) {
        return 'today';
      } else if (difference.inDays == 1) {
        return 'yesterday';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} days ago';
      } else {
        return '${(difference.inDays / 7).floor()} weeks ago';
      }
    } catch (e) {
      return 'recently';
    }
  }

  Future<void> _makeCall(String? phone) async {
    if (phone == null || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Phone number not available'),
          backgroundColor: Color(0xFFEF4444),
        ),
      );
      return;
    }

    final Uri phoneUri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not open phone dialer'),
          backgroundColor: Color(0xFFEF4444),
        ),
      );
    }
  }

  Future<void> _openWhatsApp(String? phone) async {
    if (phone == null || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Phone number not available'),
          backgroundColor: Color(0xFFEF4444),
        ),
      );
      return;
    }

    // Remove any non-digit characters
    final cleanPhone = phone.replaceAll(RegExp(r'[^\d+]'), '');
    final Uri whatsappUri = Uri.parse('https://wa.me/$cleanPhone');

    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not open WhatsApp'),
          backgroundColor: Color(0xFFEF4444),
        ),
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

