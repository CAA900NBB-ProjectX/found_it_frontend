import 'package:flutter/material.dart';
import 'view_item_screen.dart';
import 'package:intl/intl.dart';
import '../auth/services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  
  // Sample data for now - in a real app, this would come from API
  final List<Map<String, dynamic>> _recentItems = [
    {
      'id': 101,
      'name': 'Blue Backpack',
      'location': 'Campus Library',
      'time': DateTime.now().subtract(const Duration(hours: 2)),
      'status': 'FOUND',
      'category': 'Accessories'
    },
    {
      'id': 102,
      'name': 'iPhone 14',
      'location': 'Student Center',
      'time': DateTime.now().subtract(const Duration(hours: 5)),
      'status': 'LOST',
      'category': 'Electronics'
    },
    {
      'id': 103,
      'name': 'Student ID Card',
      'location': 'Cafeteria',
      'time': DateTime.now().subtract(const Duration(hours: 8)),
      'status': 'FOUND',
      'category': 'Documents'
    },
    {
      'id': 104,
      'name': 'Water Bottle',
      'location': 'Gym',
      'time': DateTime.now().subtract(const Duration(hours: 12)),
      'status': 'FOUND',
      'category': 'Other'
    },
    {
      'id': 105,
      'name': 'Textbook',
      'location': 'Room 302',
      'time': DateTime.now().subtract(const Duration(hours: 24)),
      'status': 'LOST',
      'category': 'Books'
    },
  ];

  Future<void> _logout() async {
    setState(() {
      _isLoading = true;
    });
    
    await _authService.logout();
    
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  String _getTimeAgo(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Found It'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _isLoading ? null : _logout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Column(
        children: [
          // Quick Actions Card
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quick Actions',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.search),
                            label: const Text('Find Item'),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const ViewItemScreen()),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.add_circle_outline),
                            label: const Text('Report Item'),
                            onPressed: () {
                              // This will be handled by the navigation bar
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Recent Items List
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Items',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                TextButton(
                  onPressed: () {
                    // Show all items
                  },
                  child: const Text('See All'),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: ListView.builder(
              itemCount: _recentItems.length,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemBuilder: (context, index) {
                final item = _recentItems[index];
                final bool isFound = item['status'] == 'FOUND';
                
                return Card(
                  margin: const EdgeInsets.only(bottom: 12.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isFound ? Colors.blue : Colors.orange,
                      child: Icon(
                        isFound ? Icons.search : Icons.help_outline,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(item['name']),
                    subtitle: Text('${item['category']} • ${item['location']}'),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          _getTimeAgo(item['time']),
                          style: const TextStyle(fontSize: 12),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: isFound ? Colors.blue.shade100 : Colors.orange.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            item['status'],
                            style: TextStyle(
                              fontSize: 10,
                              color: isFound ? Colors.blue.shade800 : Colors.orange.shade800,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      // Navigate to item details
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ViewItemScreen(),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}