import 'package:flutter/material.dart';
import '../widgets/menu_card.dart';
import 'training_screen.dart';
import 'injury_screen.dart';
import 'progress_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome to SmartFootball Pro',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Training, injury care, progress tracking and player profile in one place.',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SmartFootball Pro'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            MenuCard(
              title: 'Training',
              subtitle: 'View football training plans',
              icon: Icons.sports_soccer,
              iconBgColor: const Color(0xFFE8F5E9),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TrainingScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            MenuCard(
              title: 'Injury Care',
              subtitle: 'Prevention and recovery tips',
              icon: Icons.healing,
              iconBgColor: const Color(0xFFFFF3E0),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const InjuryScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            MenuCard(
              title: 'Progress',
              subtitle: 'Track your football improvement',
              icon: Icons.show_chart,
              iconBgColor: const Color(0xFFE3F2FD),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProgressScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            MenuCard(
              title: 'Profile',
              subtitle: 'View and manage your profile',
              icon: Icons.person,
              iconBgColor: const Color(0xFFF3E5F5),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}