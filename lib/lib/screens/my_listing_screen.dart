// lib/screens/my_listings_screen.dart
// View and manage user's marketplace listings

import 'package:flutter/material.dart';
import 'edit_listing_screen.dart';
import 'create_listing_screen.dart';

class MyListingsScreen extends StatefulWidget {
  @override
  _MyListingsScreenState createState() => _MyListingsScreenState();
}

class _MyListingsScreenState extends State<MyListingsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;

  // Mock data - Replace with API call
  final List<Map<String, dynamic>> _activeListings = [
    {
      'id': '1',
      'title': 'Commercial Convection Oven',
      'price': 50000,
      'condition': 'Like New',
      'images': ['https://images.unsplash.com/photo-1556910103-1c02745aae4d'],
      'location': 'Mumbai, Maharashtra',
      'views': 45,
      'status': 'active',
      'posted_at': DateTime.now().subtract(Duration(days: 2)),
    },
    {
      'id': '2',
      'title': 'Planetary Mixer 20L',
      'price': 28000,
      'condition': 'Good',
      'images': ['https://images.unsplash.com/photo-1565557623262-b51c2513a641'],
      'location': 'Delhi, NCR',
      'views': 23,
      'status': 'active',
      'posted_at': DateTime.now().subtract(Duration(days: 5)),
    },
  ];

  final List<Map<String, dynamic>> _soldListings = [
    {
      'id': '3',
      'title': 'Display Refrigerator',
      'price': 35000,
      'condition': 'Fair',
      'images': ['https://images.unsplash.com/photo-1584308972272-9e4e7685e80f'],
      'location': 'Bangalore, Karnataka',
      'views': 67,
      'status': 'sold',
      'posted_at': DateTime.now().subtract(Duration(days: 15)),
      'sold_at': DateTime.now().subtract(Duration(days: 3)),
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
                  // Title Row
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
                                'My Listings',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${_activeListings.length} active listings',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Create New Listing Button
                        IconButton(
                          icon: Icon(Icons.add_circle_outline, color: Colors.white, size: 28),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CreateListingScreen(),
                              ),
                            ).then((_) => setState(() {})); // Refresh on return
                          },
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
                        Tab(text: 'Active (${_activeListings.length})'),
                        Tab(text: 'Sold (${_soldListings.length})'),
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
                // Active Listings
                _buildListingsTab(_activeListings, isActive: true),

                // Sold Listings
                _buildListingsTab(_soldListings, isActive: false),
              ],
            ),
          ),
        ],
      ),

      // Floating Action Button
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateListingScreen(),
            ),
          ).then((_) => setState(() {}));
        },
        backgroundColor: Color(0xFF6B73FF),
        icon: Icon(Icons.add),
        label: Text(
          'New Listing',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildListingsTab(List<Map<String, dynamic>> listings, {required bool isActive}) {
    if (listings.isEmpty) {
      return _buildEmptyState(isActive);
    }

    return RefreshIndicator(
      onRefresh: _refreshListings,
      color: Color(0xFF6B73FF),
      child: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: listings.length,
        itemBuilder: (context, index) {
          return _buildListingCard(listings[index], isActive: isActive);
        },
      ),
    );
  }

  Widget _buildListingCard(Map<String, dynamic> listing, {required bool isActive}) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
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
          // Image and Info Row
          Padding(
            padding: EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Color(0xFFF0F0F0),
                    image: listing['images'] != null && listing['images'].isNotEmpty
                        ? DecorationImage(
                      image: NetworkImage(listing['images'][0]),
                      fit: BoxFit.cover,
                    )
                        : null,
                  ),
                  child: Stack(
                    children: [
                      // Status Badge
                      if (!isActive)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Color(0xFF10B981),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'SOLD',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(width: 12),

                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        listing['title'] ?? '',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1A1A),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 6),

                      // Price
                      Text(
                        '₹${_formatPrice(listing['price'])}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6B73FF),
                        ),
                      ),
                      SizedBox(height: 4),

                      // Location
                      Row(
                        children: [
                          Icon(Icons.location_on, size: 14, color: Color(0xFF9CA3AF)),
                          SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              listing['location'] ?? '',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF9CA3AF),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 6),

                      // Views and Date
                      Row(
                        children: [
                          Icon(Icons.visibility, size: 14, color: Color(0xFF9CA3AF)),
                          SizedBox(width: 4),
                          Text(
                            '${listing['views']} views',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF9CA3AF),
                            ),
                          ),
                          SizedBox(width: 12),
                          Icon(Icons.access_time, size: 14, color: Color(0xFF9CA3AF)),
                          SizedBox(width: 4),
                          Text(
                            _formatDate(listing['posted_at']),
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF9CA3AF),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Action Buttons
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Color(0xFFF3F4F6)),
              ),
            ),
            child: Row(
              children: [
                if (isActive) ...[
                  // Edit Button
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditListingScreen(listing: listing),
                          ),
                        ).then((_) => setState(() {}));
                      },
                      icon: Icon(Icons.edit_outlined, size: 18),
                      label: Text('Edit'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Color(0xFF6B73FF),
                        side: BorderSide(color: Color(0xFF6B73FF)),
                        padding: EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),

                  // Mark as Sold Button
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _markAsSold(listing),
                      icon: Icon(Icons.check_circle_outline, size: 18),
                      label: Text('Mark Sold'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF10B981),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),

                  // Delete Button
                  IconButton(
                    onPressed: () => _deleteListing(listing),
                    icon: Icon(Icons.delete_outline),
                    color: Color(0xFFEF4444),
                    style: IconButton.styleFrom(
                      backgroundColor: Color(0xFFEF4444).withOpacity(0.1),
                    ),
                  ),
                ] else ...[
                  // Relist Button for Sold Items
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _relistItem(listing),
                      icon: Icon(Icons.replay, size: 18),
                      label: Text('Relist'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Color(0xFF6B73FF),
                        side: BorderSide(color: Color(0xFF6B73FF)),
                        padding: EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),

                  // Delete Button
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _deleteListing(listing),
                      icon: Icon(Icons.delete_outline, size: 18),
                      label: Text('Delete'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Color(0xFFEF4444),
                        side: BorderSide(color: Color(0xFFEF4444)),
                        padding: EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isActive) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isActive ? Icons.inventory_2_outlined : Icons.check_circle_outline,
            size: 80,
            color: Color(0xFFCCCCCC),
          ),
          SizedBox(height: 16),
          Text(
            isActive ? 'No Active Listings' : 'No Sold Items',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF6B7280),
            ),
          ),
          SizedBox(height: 8),
          Text(
            isActive
                ? 'Post your first machinery for sale'
                : 'Items you\'ve sold will appear here',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF9CA3AF),
            ),
            textAlign: TextAlign.center,
          ),
          if (isActive) ...[
            SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateListingScreen(),
                  ),
                ).then((_) => setState(() {}));
              },
              icon: Icon(Icons.add),
              label: Text('Create Listing'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF6B73FF),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ],
      ),
    );
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

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${(difference.inDays / 7).floor()}w ago';
    }
  }

  Future<void> _refreshListings() async {
    setState(() => _isLoading = true);
    // TODO: Fetch listings from API
    await Future.delayed(Duration(seconds: 1));
    setState(() => _isLoading = false);
  }

  void _markAsSold(Map<String, dynamic> listing) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Mark as Sold?'),
        content: Text('This will move the listing to your sold items.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Update listing status via API
              setState(() {
                _activeListings.remove(listing);
                listing['status'] = 'sold';
                listing['sold_at'] = DateTime.now();
                _soldListings.insert(0, listing);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Listing marked as sold!'),
                  backgroundColor: Color(0xFF10B981),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF10B981),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text('Mark Sold'),
          ),
        ],
      ),
    );
  }

  void _deleteListing(Map<String, dynamic> listing) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Delete Listing?'),
        content: Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Delete listing via API
              setState(() {
                _activeListings.remove(listing);
                _soldListings.remove(listing);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Listing deleted!'),
                  backgroundColor: Color(0xFFEF4444),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFEF4444),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _relistItem(Map<String, dynamic> listing) {
    // TODO: Relist item via API
    setState(() {
      _soldListings.remove(listing);
      listing['status'] = 'active';
      listing.remove('sold_at');
      _activeListings.insert(0, listing);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Item relisted!'),
        backgroundColor: Color(0xFF6B73FF),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}