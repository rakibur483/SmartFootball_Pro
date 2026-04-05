import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Center(child: Text("No user found"));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("No data found"));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  child: const Icon(Icons.person, size: 40),
                ),
                const SizedBox(height: 10),
                Text(
                  data['name'] ?? '',
                  style: const TextStyle(fontSize: 20),
                ),
                Text(data['email'] ?? ''),
                const SizedBox(height: 20),

                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text("Name"),
                  subtitle: Text(data['name'] ?? ''),
                ),
                ListTile(
                  leading: const Icon(Icons.sports),
                  title: const Text("Position"),
                  subtitle: Text(data['position'] ?? ''),
                ),
                ListTile(
                  leading: const Icon(Icons.trending_up),
                  title: const Text("Level"),
                  subtitle: Text(data['level'] ?? ''),
                ),
                ListTile(
                  leading: const Icon(Icons.flag),
                  title: const Text("Goal"),
                  subtitle: Text(data['goal'] ?? ''),
                ),

                const Spacer(),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    minimumSize: const Size.fromHeight(50),
                  ),
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pop(context);
                  },
                  child: const Text("Logout"),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}