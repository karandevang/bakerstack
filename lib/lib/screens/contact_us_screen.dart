// lib/screens/contact_us_screen.dart
// Contact support and help center

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/api_service.dart';

class ContactUsScreen extends StatefulWidget {
  @override
  _ContactUsScreenState createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();

  bool _isSubmitting = false;
  String _selectedCategory = 'General Inquiry';

  final List<String> _categories = [
    'General Inquiry',
    'Order Support',
    'Product Issue',
    'Payment Issue',
    'Account Help',
    'Technical Issue',
    'Feedback',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    // Pre-fill with user data
    _nameController.text = 'Karan Patel';
    _emailController.text = 'karan@bakerstack.com';
    _phoneController.text = '+91 9876543210';
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
                            'Contact Us',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'We\'re here to help you',
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

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Quick Contact Options
                  _buildQuickContactOptions(),
                  SizedBox(height: 24),

                  // Contact Form
                  Text(
                    'Send us a message',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  SizedBox(height: 16),

                  _buildContactForm(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickContactOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Contact',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A1A),
          ),
        ),
        SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: _buildContactCard(
                icon: Icons.phone,
                title: 'Call Us',
                subtitle: '+91 1800-123-4567',
                color: Color(0xFF10B981),
                onTap: () => _makePhoneCall('+911800123456'),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _buildContactCard(
                icon: Icons.email,
                title: 'Email',
                subtitle: 'support@bakerstack.com',
                color: Color(0xFF3B82F6),
                onTap: () => _sendEmail('support@bakerstack.com'),
              ),
            ),
          ],
        ),
        SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: _buildContactCard(
                icon: Icons.chat,
                title: 'WhatsApp',
                subtitle: 'Chat with us',
                color: Color(0xFF25D366),
                onTap: () => _openWhatsApp('+911800123456'),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _buildContactCard(
                icon: Icons.web,
                title: 'Website',
                subtitle: 'bakerstack.com',
                color: Color(0xFF6B73FF),
                onTap: () => _openWebsite('https://bakerstack.com'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Color(0xFFE5E7EB)),
        ),
        child: Column(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A1A),
              ),
            ),
            SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 11,
                color: Color(0xFF6B7280),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactForm() {
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
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category Dropdown
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: InputDecoration(
                labelText: 'Category',
                prefixIcon: Icon(Icons.category_outlined, color: Color(0xFF6B73FF)),
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
              ),
              items: _categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                });
              },
            ),
            SizedBox(height: 16),

            // Name
            _buildTextField(
              controller: _nameController,
              label: 'Your Name',
              icon: Icons.person_outline,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            SizedBox(height: 16),

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
            SizedBox(height: 16),

            // Phone
            _buildTextField(
              controller: _phoneController,
              label: 'Phone Number',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 16),

            // Subject
            _buildTextField(
              controller: _subjectController,
              label: 'Subject',
              icon: Icons.subject_outlined,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a subject';
                }
                return null;
              },
            ),
            SizedBox(height: 16),

            // Message
            TextFormField(
              controller: _messageController,
              maxLines: 5,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your message';
                }
                if (value.length < 10) {
                  return 'Message must be at least 10 characters';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Message',
                hintText: 'Describe your issue or inquiry...',
                prefixIcon: Padding(
                  padding: EdgeInsets.only(bottom: 60),
                  child: Icon(Icons.message_outlined, color: Color(0xFF6B73FF)),
                ),
                alignLabelWithHint: true,
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
            ),
            SizedBox(height: 24),

            // Submit Button
            ElevatedButton(
              onPressed: _isSubmitting ? null : _submitForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF6B73FF),
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: _isSubmitting
                  ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              )
                  : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.send, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Submit Request',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
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

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final apiService = Provider.of<ApiService>(context, listen: false);
      // TODO: Submit contact form via API

      await Future.delayed(Duration(seconds: 2)); // Simulate API call

      setState(() => _isSubmitting = false);

      // Show success dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, color: Color(0xFF10B981), size: 64),
              SizedBox(height: 16),
              Text(
                'Message Sent!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'We\'ve received your message and will get back to you within 24 hours.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6B7280),
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Close contact screen
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF6B73FF),
                minimumSize: Size(double.infinity, 44),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('Done'),
            ),
          ],
        ),
      );
    } catch (e) {
      setState(() => _isSubmitting = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to send message. Please try again.'),
          backgroundColor: Color(0xFFEF4444),
        ),
      );
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final uri = Uri.parse('tel:$phoneNumber');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch phone app')),
      );
    }
  }

  Future<void> _sendEmail(String email) async {
    final uri = Uri.parse('mailto:$email');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch email app')),
      );
    }
  }

  Future<void> _openWhatsApp(String phoneNumber) async {
    final uri = Uri.parse('https://wa.me/$phoneNumber');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open WhatsApp')),
      );
    }
  }

  Future<void> _openWebsite(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open website')),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }
}