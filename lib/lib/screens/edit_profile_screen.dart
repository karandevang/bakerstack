// lib/screens/edit_profile_screen.dart
// Edit user profile information

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../services/api_service.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  File? _profileImage;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();

    // Track changes
    _nameController.addListener(() => setState(() => _hasChanges = true));
    _emailController.addListener(() => setState(() => _hasChanges = true));
    _phoneController.addListener(() => setState(() => _hasChanges = true));
  }

  Future<void> _loadUserData() async {
    // TODO: Load from API
    // Mock data
    _nameController.text = 'Karan Patel';
    _emailController.text = 'karan@bakerstack.com';
    _phoneController.text = '+91 9876543210';
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_hasChanges) {
          return await _showDiscardDialog();
        }
        return true;
      },
      child: Scaffold(
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
                        onPressed: () async {
                          if (_hasChanges) {
                            final shouldPop = await _showDiscardDialog();
                            if (shouldPop) Navigator.pop(context);
                          } else {
                            Navigator.pop(context);
                          }
                        },
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Edit Profile',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (_hasChanges)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Unsaved',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Profile Picture
                      GestureDetector(
                        onTap: _pickImage,
                        child: Stack(
                          children: [
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFF6B73FF).withOpacity(0.1),
                                image: _profileImage != null
                                    ? DecorationImage(
                                  image: FileImage(_profileImage!),
                                  fit: BoxFit.cover,
                                )
                                    : null,
                              ),
                              child: _profileImage == null
                                  ? Icon(
                                Icons.person,
                                size: 60,
                                color: Color(0xFF6B73FF),
                              )
                                  : null,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Color(0xFF6B73FF),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 3,
                                  ),
                                ),
                                child: Icon(
                                  Icons.camera_alt,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 32),

                      // Full Name
                      _buildTextField(
                        controller: _nameController,
                        label: 'Full Name',
                        icon: Icons.person_outline,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),

                      // Email
                      _buildTextField(
                        controller: _emailController,
                        label: 'Email Address',
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!value.contains('@')) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),

                      // Phone
                      _buildTextField(
                        controller: _phoneController,
                        label: 'Phone Number',
                        icon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your phone number';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 32),

                      // Change Password Button
                      OutlinedButton.icon(
                        onPressed: _showChangePasswordDialog,
                        icon: Icon(Icons.lock_outline),
                        label: Text('Change Password'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Color(0xFF6B73FF),
                          side: BorderSide(color: Color(0xFF6B73FF)),
                          padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
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

        // Bottom Buttons
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
            child: Row(
              children: [
                // Cancel
                Expanded(
                  child: OutlinedButton(
                    onPressed: () async {
                      if (_hasChanges) {
                        final shouldPop = await _showDiscardDialog();
                        if (shouldPop) Navigator.pop(context);
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Color(0xFF6B73FF),
                      side: BorderSide(color: Color(0xFF6B73FF)),
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),

                // Save
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: _isLoading || !_hasChanges ? null : _saveProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF6B73FF),
                      padding: EdgeInsets.symmetric(vertical: 14),
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
                      'Save Changes',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Color(0xFF6B73FF)),
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
      ),
    );
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _profileImage = File(image.path);
          _hasChanges = true;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking image: ${e.toString()}'),
          backgroundColor: Color(0xFFEF4444),
        ),
      );
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final apiService = Provider.of<ApiService>(context, listen: false);
      // TODO: Upload profile image if changed
      // TODO: Update profile via API

      await Future.delayed(Duration(seconds: 2)); // Simulate API call

      setState(() {
        _isLoading = false;
        _hasChanges = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profile updated successfully!'),
          backgroundColor: Color(0xFF10B981),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update profile'),
          backgroundColor: Color(0xFFEF4444),
        ),
      );
    }
  }

  Future<bool> _showDiscardDialog() async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Discard changes?'),
        content: Text('You have unsaved changes. Are you sure you want to leave?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Keep Editing'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFEF4444),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text('Discard'),
          ),
        ],
      ),
    ) ?? false;
  }

  void _showChangePasswordDialog() {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Current Password',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'New Password',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Confirm New Password',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Validate and change password
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Password changed successfully!'),
                  backgroundColor: Color(0xFF10B981),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF6B73FF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text('Change Password'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}