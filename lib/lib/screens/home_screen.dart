// lib/screens/home_screen.dart
// Updated to match the beautiful UI from screenshots

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

  Widget _buildProductCard(Product product) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image with overlay elements
          Stack(
            children: [
              // Image
              Container(
                height: 140,
                decoration: BoxDecoration(
                  color: Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  image: product.imageUrl.isNotEmpty
                      ? DecorationImage(
                    image: NetworkImage(product.imageUrl),
                    fit: BoxFit.cover,
                  )
                      : null,
                ),
                child: product.imageUrl.isEmpty
                    ? Center(child: Icon(Icons.image, size: 48, color: Color(0xFF6B7280)))
                    : null,
              ),

              // Discount Badge (top-right)
              if (product.discountPercent > 0)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Color(0xFFEF4444),
                      borderRadius: BorderRadius.circular(8),
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

              // Wishlist Button (top-left)
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.favorite_border,
                    size: 18,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ),
            ],
          ),

          // Product Info
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF667eea).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      product.category,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF667eea),
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 6),

                  // Product Name
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1F2937),
                      height: 1.2,
                    ),
                  ),

                  const SizedBox(height: 6),

                  // Price
                  Row(
                    children: [
                      Text(
                        '₹${product.price.toInt()}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      if (product.discountPercent > 0) ...[
                        const SizedBox(width: 6),
                        Text(
                          '₹${product.mrp.toInt()}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF6B7280),
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Add to Cart Button
                  SizedBox(
                    width: double.infinity,
                    height: 36,
                    child: ElevatedButton(
                      onPressed: () => _addToCart(product),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF667eea),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.shopping_cart_outlined, size: 12),
                          SizedBox(width: 4),
                          Text(
                            'Add to Cart',
                            style: TextStyle(
                              fontSize: 12,
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

        ],
      ),
    );
  }
}