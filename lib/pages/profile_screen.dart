import 'package:bhukk/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();

  // List of options for the profile menu
  final List<Map<String, dynamic>> _menuItems = [
    {
      'title': 'Personal Information',
      'icon': Icons.person,
      'route': '/personal-info',
    },
    {
      'title': 'Payment Methods',
      'icon': Icons.payment,
      'route': '/payment-methods',
    },
    {
      'title': 'Delivery Addresses',
      'icon': Icons.location_on,
      'route': '/addresses',
    },
    {
      'title': 'Order History',
      'icon': Icons.receipt_long,
      'route': '/orders',
    },
    {
      'title': 'Favorites',
      'icon': Icons.favorite,
      'route': '/favorites',
    },
    {
      'title': 'Preferences',
      'icon': Icons.settings,
      'route': '/preferences',
    },
    {
      'title': 'Help & Support',
      'icon': Icons.help,
      'route': '/support',
    },
  ];

  bool _isLoading = false;

  Future<void> _logout() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _authService.logout();
      Get.offAllNamed('/login');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to log out: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Profile',
          style: GoogleFonts.jaldi(
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  // Profile header
                  Container(
                    padding: EdgeInsets.all(24),
                    color: Theme.of(context).primaryColor.withOpacity(0.05),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.grey.shade200,
                          child: Icon(
                            Icons.person,
                            size: 40,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'John Doe', // Replace with actual user name
                                style: GoogleFonts.jaldi(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'john.doe@example.com', // Replace with actual email
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                ),
                              ),
                              SizedBox(height: 8),
                              OutlinedButton(
                                onPressed: () {
                                  // Navigate to edit profile screen
                                  Get.toNamed('/edit-profile');
                                },
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.orange,
                                  side: BorderSide(color: Colors.orange),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                ),
                                child: Text('Edit Profile'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Menu items
                  ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _menuItems.length,
                    separatorBuilder: (context, index) => Divider(height: 1),
                    itemBuilder: (context, index) {
                      final menuItem = _menuItems[index];
                      return ListTile(
                        leading: Icon(
                          menuItem['icon'],
                          color: Colors.orange,
                        ),
                        title: Text(menuItem['title']),
                        trailing: Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          // Navigate to the corresponding screen
                          Get.toNamed(menuItem['route']);
                        },
                      );
                    },
                  ),

                  Divider(height: 1),

                  // Logout button
                  ListTile(
                    leading: Icon(
                      Icons.logout,
                      color: Colors.red,
                    ),
                    title: Text('Log Out'),
                    onTap: _logout,
                  ),

                  SizedBox(height: 24),

                  // App version
                  Text(
                    'App Version 1.0.0',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),

                  SizedBox(height: 16),
                ],
              ),
            ),
    );
  }
}
