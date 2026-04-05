import 'package:flutter/material.dart';
import '../data/training_data.dart';
import 'training_detail_screen.dart';

class TrainingScreen extends StatelessWidget {
  const TrainingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Training'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: trainingData.length,
        itemBuilder: (context, index) {
          final item = trainingData[index];
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
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.sports_soccer,
                  color: Colors.green,
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
                    builder: (context) => TrainingDetailScreen(
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