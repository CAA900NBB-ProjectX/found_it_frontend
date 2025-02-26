import 'package:flutter/material.dart';
import '../auth/services/auth_service.dart';
import '../screens/view_item_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  String _username = 'User'; // Default value
  String _email = 'user@example.com'; // Default value

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    // In a real app, you would load the user profile from an API or local storage
    // For now, we'll just use placeholder data

    // Example of how you might fetch user data in a real app:
    // final userData = await _authService.getUserProfile();
    // setState(() {
    //   _username = userData['username'];
    //   _email = userData['email'];
    // });
  }

  Future<void> _logout() async {
    setState(() {
      _isLoading = true;
    });

    await _authService.logout();

    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Profile header
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: null, // Add a profile photo here if available
                    child: Icon(Icons.person, size: 50),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _username,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _email,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // My Items section
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'My Activity',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.checklist),
                      title: const Text('My Reports'),
                      subtitle: const Text('Items you have reported'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        // Navigate to user's reports
                      },
                    ),
                  ),

                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.history),
                      title: const Text('Search History'),
                      subtitle: const Text('Items you have searched for'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        // Navigate to search history
                      },
                    ),
                  ),

                  // Account section
                  const SizedBox(height: 24),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Account',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.person_outline),
                      title: const Text('Edit Profile'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        // Navigate to edit profile
                      },
                    ),
                  ),

                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.settings_outlined),
                      title: const Text('Settings'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        // Navigate to settings
                      },
                    ),
                  ),

                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.help_outline),
                      title: const Text('Help & Support'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        // Navigate to help
                      },
                    ),
                  ),

                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.logout),
                    label: const Text('Logout'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: _isLoading ? null : _logout,
                  ),

                  const SizedBox(height: 24),
                  const Text(
                    'Found It! v1.0.0',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}