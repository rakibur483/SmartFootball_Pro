import 'package:flutter/material.dart';
import '../data/injury_data.dart';
import 'injury_detail_screen.dart';

class InjuryScreen extends StatelessWidget {
  const InjuryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Injury Prevention'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: injuryData.length,
        itemBuilder: (context, index) {
          final item = injuryData[index];
          return Card(
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              leading: Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.health_and_safety,
                  color: Colors.orange,
                ),
              ),
              title: Text(
                item['title'] ?? '',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(item['subtitle'] ?? ''),
              trailing: const Icon(Icons.arrow_forward_ios, size: 18),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InjuryDetailScreen(
                      title: item['title'] ?? '',
                      description: item['description'] ?? '',
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}