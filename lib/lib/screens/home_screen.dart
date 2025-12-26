import 'product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../models/product.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  String? _selectedCategory;
  bool _isLoading = true;
  String _searchQuery = '';
  Set<String> _wishlistProductIds = {};

  final List<String> _categories = ['All', 'Boxes', 'Bags', 'Containers', 'Wrapping'];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() => _isLoading = true);

    try {
      final apiService = Provider.of<ApiService>(context, listen: false);
      final products = await apiService.getProducts(
        category: _selectedCategory,
      );

      setState(() {
        _allProducts = products;
        _filteredProducts = products;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load products'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _filterByCategory(String category) {
    setState(() {
      if (category == 'All') {
        _selectedCategory = null;
        _filteredProducts = _allProducts;
      } else {
        _selectedCategory = category;
        _filteredProducts = _allProducts
            .where((p) => p.category.toLowerCase() == category.toLowerCase())
            .toList();
      }
    });
    _loadProducts();
  }

  void _searchProducts(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredProducts = _allProducts;
      } else {
        _filteredProducts = _allProducts
            .where((p) =>
        p.name.toLowerCase().contains(query.toLowerCase()) ||
            p.description.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  Future<void> _addToCart(Product product) async {
    try {
      final apiService = Provider.of<ApiService>(context, listen: false);
      await apiService.addToCart(product.id, 1);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Added to cart'),
          backgroundColor: Color(0xFF10B981),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(bottom: 70, left: 16, right: 16),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add to cart'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9FAFB),
      body: RefreshIndicator(
        onRefresh: _loadProducts,
        child: CustomScrollView(
          slivers: [
            // Header with gradient
            SliverAppBar(
              expandedHeight: 180,
              floating: false,
              pinned: true,
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
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          Text(
                            'BakerStack',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Premium Bakery Packaging',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 16),

                          // Search Bar
                          Container(
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
                              onChanged: _searchProducts,
                              decoration: InputDecoration(
                                hintText: 'Search products...',
                                hintStyle: TextStyle(color: Color(0xFF6B7280)),
                                prefixIcon: Icon(Icons.search, color: Color(0xFF6B7280)),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              backgroundColor: Color(0xFF667eea),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(20),
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

            // Category Filter Chips
            SliverToBoxAdapter(
              child: Container(
                height: 60,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    final isSelected = (category == 'All' && _selectedCategory == null) ||
                        category == _selectedCategory;

                    return Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(category),
                        selected: isSelected,
                        onSelected: (_) => _filterByCategory(category),
                        backgroundColor: Colors.white,
                        selectedColor: Color(0xFF667eea),
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Color(0xFF6B7280),
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: isSelected ? Color(0xFF667eea) : Color(0xFFE5E7EB),
                            width: isSelected ? 0 : 1,
                          ),
                        ),
                        elevation: isSelected ? 4 : 0,
                        shadowColor: Color(0xFF667eea).withOpacity(0.3),
                      ),
                    );
                  },
                ),
              ),
            ),

            // Product Grid
            _isLoading
                ? SliverFillRemaining(
              child: Center(child: CircularProgressIndicator(color: Color(0xFF667eea))),
            )
                : _filteredProducts.isEmpty
                ? SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.inventory_2_outlined, size: 64, color: Color(0xFF6B7280)),
                    SizedBox(height: 16),
                    Text(
                      'No products found',
                      style: TextStyle(fontSize: 18, color: Color(0xFF6B7280)),
                    ),
                  ],
                ),
              ),
            )
                : SliverPadding(
              padding: EdgeInsets.all(16),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.65,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                delegate: SliverChildBuilderDelegate(
                      (context, index) => _buildProductCard(_filteredProducts[index]),
                  childCount: _filteredProducts.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Super tight spacing - NO gap between price and button!

  Widget _buildProductCard(Product product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(product: product),
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
          mainAxisSize: MainAxisSize.min,
          children: [
            // Product Image with Badges
            Stack(
              children: [
                Container(
                  height: 155,
                  decoration: BoxDecoration(
                    color: Color(0xFFF0F0F0),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    image: product.imageUrl != null
                        ? DecorationImage(
                      image: NetworkImage(product.imageUrl!),
                      fit: BoxFit.cover,
                    )
                        : null,
                  ),
                  child: product.imageUrl == null
                      ? Center(
                    child: Icon(
                      Icons.image_outlined,
                      size: 40,
                      color: Color(0xFFCCCCCC),
                    ),
                  )
                      : null,
                ),

                // Discount Badge
                if (product.discountPercent > 0)
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: Color(0xFFEF4444),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '${product.discountPercent}% OFF',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                // Wishlist Heart Icon
                Positioned(
                  top: 6,
                  left: 6,
                  child: GestureDetector(
                    onTap: () {
                      _toggleWishlist(product.id);
                    },
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Icon(
                        _wishlistProductIds.contains(product.id)
                            ? Icons.favorite
                            : Icons.favorite_outline,
                        size: 16,
                        color: _wishlistProductIds.contains(product.id)
                            ? Color(0xFFEF4444)
                            : Color(0xFF666666),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Category
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: Color(0xFF6B73FF).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      product.category,
                      style: TextStyle(
                        color: Color(0xFF6B73FF),
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: 6),

                  // Product Name
                  Container(
                    height: 32, // Fixed height for exactly 2 lines (13px font * 1.2 height * 2 lines)
                    child: Text(
                      product.name,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A1A),
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  SizedBox(height: 6),

                  // Price and Stock Status
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Price
                      Expanded(
                        child: Row(
                          children: [
                            Text(
                              '₹${product.price.toStringAsFixed(0)}',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF6B73FF),
                              ),
                            ),
                            SizedBox(width: 4),
                            if (product.mrp > product.price)
                              Flexible(
                                child: Text(
                                  '₹${product.mrp.toStringAsFixed(0)}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF999999),
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                          ],
                        ),
                      ),

                      // Stock Status
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 5,
                            height: 5,
                            decoration: BoxDecoration(
                              color: product.inStock ? Color(0xFF10B981) : Color(0xFFEF4444),
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 3),
                          Text(
                            product.inStock ? 'In Stock' : 'Out',
                            style: TextStyle(
                              fontSize: 12,
                              color: product.inStock ? Color(0xFF10B981) : Color(0xFFEF4444),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: 8), // Small gap before button

                  // Add to Cart Button - INSIDE SAME PADDING!
                  SizedBox(
                    width: double.infinity,
                    height: 36,
                    child: ElevatedButton(
                      onPressed: product.inStock
                          ? () => _addToCartFromHome(product)
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: product.inStock ? Color(0xFF6B73FF) : Color(0xFFCCCCCC),
                        padding: EdgeInsets.zero,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.shopping_cart_outlined, size: 14,color: product.inStock ? Colors.white : Colors.grey,),
                          SizedBox(width: 4),
                          Text(
                            'Add to Cart',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: product.inStock ? Colors.white : Colors.grey
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

// Add to cart method
  Future<void> _addToCartFromHome(Product product) async {
    try {
      final apiService = Provider.of<ApiService>(context, listen: false);
      await apiService.addToCart(product.id, 1);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white, size: 18),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Added to cart!',
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
          backgroundColor: Color(0xFF10B981),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
          margin: EdgeInsets.all(16),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add to cart'),
          backgroundColor: Color(0xFFEF4444),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(16),
        ),
      );
    }
  }

  void _toggleWishlist(String productId) {
    setState(() {
      if (_wishlistProductIds.contains(productId)) {
        _wishlistProductIds.remove(productId);
      } else {
        _wishlistProductIds.add(productId);
      }
    });

    // TODO: Call API to add/remove from wishlist
    final apiService = Provider.of<ApiService>(context, listen: false);
    if (_wishlistProductIds.contains(productId)) {
      // apiService.addToWishlist(productId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Added to wishlist'),
          duration: Duration(seconds: 1),
          backgroundColor: Color(0xFF10B981),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      // apiService.removeFromWishlist(productId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Removed from wishlist'),
          duration: Duration(seconds: 1),
          backgroundColor: Color(0xFF666666),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}