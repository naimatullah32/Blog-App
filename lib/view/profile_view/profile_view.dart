import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: const Color(0xFF4F46E5),
      ),
      body: Column(
        children: [
          const SizedBox(height: 30),
          const CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(
              "https://i.pravatar.cc/300",
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            "Alex Smith",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const Text("alex@email.com", style: TextStyle(color: Colors.grey)),

          const SizedBox(height: 30),

          _tile(Icons.edit, "Edit Profile"),
          _tile(Icons.lock, "Change Password"),
          _tile(Icons.logout, "Logout", color: Colors.red),
        ],
      ),
    );
  }

  Widget _tile(IconData icon, String text, {Color color = Colors.black}) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(text, style: TextStyle(color: color)),
    );
  }
}
