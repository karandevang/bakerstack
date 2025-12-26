// lib/screens/marketplace_feed_screen.dart
// Updated with navigation to detail screen

import 'package:flutter/material.dart';
import 'marketplace_detail_screen.dart';
import 'create_listing_screen.dart'; // Add this

class MarketplaceFeedScreen extends StatefulWidget {
  @override
  _MarketplaceFeedScreenState createState() => _MarketplaceFeedScreenState();
}

class _MarketplaceFeedScreenState extends State<MarketplaceFeedScreen> {
  String _selectedCategory = 'All';
  final List<String> _categories = [
    'All',
    'Ovens',
    'Mixers',
    'Refrigerators',
    'Display Cases',
  ];

  final List<Map<String, dynamic>> _listings = [
    {
      'id': '1',
      'title': 'Commercial Convection Oven',
      'price': 50000,
      'location': 'Mumbai, Maharashtra',
      'city': 'Mumbai',
      'state': 'Maharashtra',
      'condition': 'Like New',
      'age': '1-2 years',
      'images': ['https://images.unsplash.com/photo-1556910103-1c02745aae4d'],
      'description': 'High-quality commercial convection oven in excellent condition. Perfect for bakeries and restaurants. Features digital temperature control and multiple racks.',
      'contact_name': 'Rajesh Kumar',
      'contact_phone': '+919876543210',
      'posted_at': DateTime.now().subtract(Duration(days: 2)).toIso8601String(),
    },
    {
      'id': '2',
      'title': 'Planetary Mixer 20L - Heavy Duty',
      'price': 28000,
      'location': 'Delhi, NCR',
      'city': 'Delhi',
      'state': 'NCR',
      'condition': 'Good',
      'age': '3-5 years',
      'images': ['https://images.unsplash.com/photo-1565557623262-b51c2513a641'],
      'description': '20-liter planetary mixer suitable for commercial bakery use. Heavy-duty construction with stainless steel bowl.',
      'contact_name': 'Amit Sharma',
      'contact_phone': '+919876543211',
      'posted_at': DateTime.now().subtract(Duration(days: 5)).toIso8601String(),
    },
    {
      'id': '3',
      'title': 'Display Refrigerator - Glass Door',
      'price': 35000,
      'location': 'Bangalore, Karnataka',
      'city': 'Bangalore',
      'state': 'Karnataka',
      'condition': 'Fair',
      'age': '5-10 years',
      'images': ['https://images.unsplash.com/photo-1584308972272-9e4e7685e80f'],
      'description': 'Glass door display refrigerator ideal for showcasing cakes and pastries. Energy efficient cooling system.',
      'contact_name': 'Priya Singh',
      'contact_phone': '+919876543212',
      'posted_at': DateTime.now().subtract(Duration(days: 7)).toIso8601String(),
    },
    {
      'id': '4',
      'title': 'Dough Mixer - Industrial Grade',
      'price': 42000,
      'location': 'Pune, Maharashtra',
      'city': 'Pune',
      'state': 'Maharashtra',
      'condition': 'Like New',
      'age': 'Less than 1 year',
      'images': ['https://images.unsplash.com/photo-1590182450118-d8df7d19e00e'],
      'description': 'Industrial-grade dough mixer with large capacity. Perfect for high-volume bakery operations.',
      'contact_name': 'Suresh Patel',
      'contact_phone': '+919876543213',
      'posted_at': DateTime.now().subtract(Duration(days: 10)).toIso8601String(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      body: Column(
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
                padding: EdgeInsets.fromLTRB(24, 24, 24, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      'Marketplace',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.5,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Buy & Sell Used Bakery Machinery',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 20),

                    // Search bar
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        style: TextStyle(color: Colors.white, fontSize: 16),
                        decoration: InputDecoration(
                          hintText: 'Search machinery...',
                          hintStyle: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 16,
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.white.withOpacity(0.7),
                            size: 24,
                          ),
                          suffixIcon: Container(
                            margin: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.tune,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Category chips
          Container(
            height: 65,
            color: Colors.white,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = category == _selectedCategory;

                return GestureDetector(
                  onTap: () {
                    setState(() => _selectedCategory = category);
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 12),
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? Color(0xFF6B73FF) : Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        category,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Color(0xFF666666),
                          fontSize: 15,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Listings Grid
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.58,
              ),
              itemCount: _listings.length,
              itemBuilder: (context, index) {
                return _buildListingCard(_listings[index]);
              },
            ),
          ),
        ],
      ),

      // Floating Action Button to Create Listing
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateListingScreen(),
            ),
          );
        },
        backgroundColor: Color(0xFF6B73FF),
        child: Icon(Icons.add, size: 28),
        elevation: 4,
      ),
    );
  }

  Widget _buildListingCard(Map<String, dynamic> item) {
    return GestureDetector(
      onTap: () {
        // Navigate to marketplace detail screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MarketplaceDetailScreen(listing: item),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Stack(
              children: [
                Container(
                  height: 180,
                  decoration: BoxDecoration(
                    color: Color(0xFFF0F0F0),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                    image: item['images'] != null && item['images'].isNotEmpty
                        ? DecorationImage(
                      image: NetworkImage(item['images'][0]),
                      fit: BoxFit.cover,
                    )
                        : null,
                  ),
                ),

                // Condition badge
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getConditionColor(item['condition']),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      item['condition'] ?? 'Used',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Content
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      item['title'] ?? '',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A1A),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 6),

                    // Price
                    Text(
                      '₹${_formatPrice(item['price'])}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF6B73FF),
                      ),
                    ),

                    Spacer(),

                    // Location
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 14,
                          color: Color(0xFF999999),
                        ),
                        SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            item['location'] ?? '',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF999999),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),

                    // Equipment Age
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: Color(0xFF999999),
                        ),
                        SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            item['age'] ?? 'Age not specified',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF999999),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),

                    // Posted time
                    Text(
                      _formatTime(item['posted_at']),
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFFBBBBBB),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
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
    if (postedAt == null) return 'Recently';
    try {
      final date = DateTime.parse(postedAt.toString());
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays == 0) {
        return 'Today';
      } else if (difference.inDays == 1) {
        return 'Yesterday';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} days ago';
      } else {
        return '${(difference.inDays / 7).floor()} weeks ago';
      }
    } catch (e) {
      return 'Recently';
    }
  }
}