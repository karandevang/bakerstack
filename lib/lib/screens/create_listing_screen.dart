// lib/screens/create_listing_screen.dart
// Create new marketplace listing with image upload

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CreateListingScreen extends StatefulWidget {
  @override
  _CreateListingScreenState createState() => _CreateListingScreenState();
}

class _CreateListingScreenState extends State<CreateListingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _contactNameController = TextEditingController();
  final _contactPhoneController = TextEditingController();
  final _locationController = TextEditingController();

  String _selectedCategory = 'Ovens';
  String _selectedCondition = 'Like New';
  String _selectedAge = 'Less than 1 year';

  final List<String> _categories = [
    'Ovens',
    'Mixers',
    'Refrigerators',
    'Display Cases',
    'Dough Equipment',
    'Other',
  ];

  final List<String> _conditions = [
    'Like New',
    'Good',
    'Fair',
    'Poor',
  ];

  final List<String> _ageOptions = [
    'Less than 1 year',
    '1-2 years',
    '2-3 years',
    '3-5 years',
    '5-10 years',
    'More than 10 years',
  ];

  List<File> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

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
              child: Padding(
                padding: EdgeInsets.all(20),
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
                            'Create Listing',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Sell your bakery machinery',
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
          ),

          // Form
          Expanded(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.all(20),
                children: [
                  // Image Upload Section
                  Text(
                    'Photos (Max 5)',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  SizedBox(height: 12),
                  _buildImagePicker(),
                  SizedBox(height: 24),

                  // Title
                  _buildTextField(
                    controller: _titleController,
                    label: 'Title',
                    hint: 'e.g., Commercial Convection Oven',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),

                  // Category
                  Text(
                    'Category',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF374151),
                    ),
                  ),
                  SizedBox(height: 8),
                  _buildDropdown(
                    value: _selectedCategory,
                    items: _categories,
                    onChanged: (value) {
                      setState(() => _selectedCategory = value!);
                    },
                  ),
                  SizedBox(height: 16),

                  // Condition
                  Text(
                    'Condition',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF374151),
                    ),
                  ),
                  SizedBox(height: 8),
                  _buildDropdown(
                    value: _selectedCondition,
                    items: _conditions,
                    onChanged: (value) {
                      setState(() => _selectedCondition = value!);
                    },
                  ),
                  SizedBox(height: 16),

                  // Equipment Age
                  Text(
                    'Equipment Age',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF374151),
                    ),
                  ),
                  SizedBox(height: 8),
                  _buildDropdown(
                    value: _selectedAge,
                    items: _ageOptions,
                    onChanged: (value) {
                      setState(() => _selectedAge = value!);
                    },
                  ),
                  SizedBox(height: 16),

                  // Price
                  _buildTextField(
                    controller: _priceController,
                    label: 'Price',
                    hint: '50000',
                    keyboardType: TextInputType.number,
                    prefix: Text('₹ ', style: TextStyle(fontSize: 16)),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a price';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),

                  // Description
                  _buildTextField(
                    controller: _descriptionController,
                    label: 'Description',
                    hint: 'Describe the condition, features, and specifications...',
                    maxLines: 5,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),

                  // Location
                  _buildTextField(
                    controller: _locationController,
                    label: 'Location',
                    hint: 'Mumbai, Maharashtra',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter location';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 24),

                  // Contact Details Section
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Color(0xFF6B73FF).withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Color(0xFF6B73FF).withOpacity(0.2),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 20,
                              color: Color(0xFF6B73FF),
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Contact Information',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1A1A1A),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),

                        _buildTextField(
                          controller: _contactNameController,
                          label: 'Contact Name',
                          hint: 'Your name',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 12),

                        _buildTextField(
                          controller: _contactPhoneController,
                          label: 'Phone Number',
                          hint: '+91 9876543210',
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter phone number';
                            }
                            if (value.length < 10) {
                              return 'Please enter valid phone number';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 100), // Space for button
                ],
              ),
            ),
          ),
        ],
      ),

      // Bottom Button
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: ElevatedButton(
            onPressed: _isLoading ? null : _submitListing,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF6B73FF),
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: _isLoading
                ? SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation(Colors.white),
              ),
            )
                : Text(
              'Post Listing',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return Container(
      height: 120,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          // Selected images
          ..._selectedImages.map((image) => _buildImageCard(image)),

          // Add image button
          if (_selectedImages.length < 5)
            GestureDetector(
              onTap: _pickImages,
              child: Container(
                width: 120,
                margin: EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Color(0xFF6B73FF).withOpacity(0.3),
                    width: 2,
                    style: BorderStyle.solid,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_photo_alternate_outlined,
                      size: 40,
                      color: Color(0xFF6B73FF),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Add Photo',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B73FF),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '${_selectedImages.length}/5',
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF9CA3AF),
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

  Widget _buildImageCard(File image) {
    return Container(
      width: 120,
      margin: EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: FileImage(image),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedImages.remove(image);
                });
              },
              child: Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    Widget? prefix,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            prefix: prefix,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Color(0xFFE5E7EB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Color(0xFFE5E7EB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Color(0xFF6B73FF), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Color(0xFFEF4444)),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFE5E7EB)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down, color: Color(0xFF6B7280)),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Future<void> _pickImages() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage();

      if (images.isNotEmpty) {
        setState(() {
          for (var image in images) {
            if (_selectedImages.length < 5) {
              _selectedImages.add(File(image.path));
            }
          }
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking images: ${e.toString()}'),
          backgroundColor: Color(0xFFEF4444),
        ),
      );
    }
  }

  Future<void> _submitListing() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please add at least one photo'),
          backgroundColor: Color(0xFFEF4444),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    // TODO: Upload images to server
    // TODO: Create listing via API

    await Future.delayed(Duration(seconds: 2)); // Simulate API call

    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Listing posted successfully!'),
        backgroundColor: Color(0xFF10B981),
      ),
    );

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _contactNameController.dispose();
    _contactPhoneController.dispose();
    _locationController.dispose();
    super.dispose();
  }
}