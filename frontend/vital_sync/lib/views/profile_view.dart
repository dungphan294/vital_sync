import 'package:flutter/material.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample user data - replace with actual data source
    final userData = {
      "name": "Admin",
      "phone_number": "0123456",
      "dob": "2025-06-02",
      "user_id": "admin",
      "username": "admin",
      "email": "admin@vitalsync.nl",
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.blue,
                child: Icon(Icons.person, size: 50, color: Colors.white),
              ),
            ),
            const SizedBox(height: 24),
            _buildProfileItem('Name', userData['name']!),
            _buildProfileItem('Username', userData['username']!),
            _buildProfileItem('Email', userData['email']!),
            _buildProfileItem('Phone', userData['phone_number']!),
            _buildProfileItem('Date of Birth', userData['dob']!),
            _buildProfileItem('User ID', userData['user_id']!),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
}
