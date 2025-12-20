import 'package:flutter/material.dart';
import '../models/marketplace_item.dart';

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

  final List<MarketplaceItem> _listings = [
    MarketplaceItem(
      id: '1',
      title: 'Commercial Convection Oven ...',
      price: 50000,
      location: 'Mumbai, Maharashtra',
      condition: 'Like New',
      imageUrl: 'https://images.unsplash.com/photo-1556910103-1c02745aae4d',
      postedAt: DateTime.now().subtract(Duration(days: 2)),
    ),
    MarketplaceItem(
      id: '2',
      title: 'Planetary Mixer 20L - Heavy Duty',
      price: 28000,
      location: 'Delhi, NCR',
      condition: 'Good',
      imageUrl: 'https://images.unsplash.com/photo-1565557623262-b51c2513a641',
      postedAt: DateTime.now().subtract(Duration(days: 5)),
    ),
    MarketplaceItem(
      id: '3',
      title: 'Display Refrigerator - Glass Door',
      price: 35000,
      location: 'Bangalore, Karnataka',
      condition: 'Fair',
      imageUrl: 'https://images.unsplash.com/photo-1584308972272-9e4e7685e80f',
      postedAt: DateTime.now().subtract(Duration(days: 7)),
    ),
    MarketplaceItem(
      id: '4',
      title: 'Dough Mixer - Industrial Grade',
      price: 42000,
      location: 'Pune, Maharashtra',
      condition: 'Like New',
      imageUrl: 'https://images.unsplash.com/photo-1590182450118-d8df7d19e00e',
      postedAt: DateTime.now().subtract(Duration(days: 10)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            floating: false,
            automaticallyImplyLeading: false,
            flexibleSpace: LayoutBuilder(
              builder: (context, constraints) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                    ),
                  ),
                  child: SafeArea(
                    top:false,
                    bottom: false,
                    child: SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(24, 24, 24, 28),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
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
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 8,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: 'Search machinery...',
                                    prefixIcon: Icon(Icons.search),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            backgroundColor: Color(0xFF667eea),
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

          SliverToBoxAdapter(
            child: Column(
              children: [
                // Category Chips
                Container(
                  height: 60,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 16),
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
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Color(0xFF6B73FF)
                                : Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected ? const Color(0xFF4A5DFF) : const Color(0xFFD1D5DB),
                              width: 1, // you can adjust thickness
                            ),
                          ),
                          child: Center(
                            child: Text(
                              category,
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : Color(0xFF666666),
                                fontSize: 15,
                                fontWeight: isSelected ?
                                  FontWeight.w600 : FontWeight.normal
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),


          // ================= GRID =================
          SliverPadding(
            padding: EdgeInsets.all(16),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.70,
              ),
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  return _buildListingCard(_listings[index]);
                },
                childCount: _listings.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= CARD =================
  Widget _buildListingCard(MarketplaceItem item) {
    return Container(
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
          Stack(
            children: [
              Container(
                height: 140,
                decoration: BoxDecoration(
                  borderRadius:
                  BorderRadius.vertical(top: Radius.circular(16)),
                  image: DecorationImage(
                    image: NetworkImage(item.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding:
                  EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getConditionColor(item.condition),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    item.condition,
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
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    '₹${_formatPrice(item.price)}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF6B73FF),
                    ),
                  ),
                  SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.location_on,
                          size: 14, color: Color(0xFF999999)),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          item.location,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF999999),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    _formatTime(item.postedAt),
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
    );
  }

  Color _getConditionColor(String condition) {
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

  String _formatPrice(int price) {
    if (price >= 100000) return '${(price / 100000).toStringAsFixed(1)}L';
    if (price >= 1000) return '${(price / 1000).toStringAsFixed(0)}K';
    return price.toString();
  }

  String _formatTime(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays} days ago';
    return '${(diff.inDays / 7).floor()} weeks ago';
  }

}
