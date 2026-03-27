import 'package:flutter/material.dart';
import 'package:my_app/application/auth/service/service.dart';

class UserDetailPage extends StatelessWidget {
  final AuthService _authService = AuthService();

  UserDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Detail')),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _authService.getUserDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No user details found'));
          }

          final user = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Name: ${user['name']}', style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 8),
                Text('Email: ${user['email']}', style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 8),
                Text('Phone: ${user['phone']}', style: const TextStyle(fontSize: 18)),
              ],
            ),
          );
        },
      ),
    );
  }
}