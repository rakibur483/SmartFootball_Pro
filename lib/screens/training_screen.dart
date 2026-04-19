// Training detail screen updated by Hasibul (Member 2)
import 'package:flutter/material.dart';
import '../models/training_model.dart';
import '../services/firestore_service.dart';
import 'add_training_screen.dart';
import 'training_detail_screen.dart';

class TrainingScreen extends StatefulWidget {
  const TrainingScreen({super.key});

  @override
  State<TrainingScreen> createState() => _TrainingScreenState();
}

class _TrainingScreenState extends State<TrainingScreen> {
  final FirestoreService firestoreService = FirestoreService();
  final TextEditingController searchController = TextEditingController();

  String searchText = '';
  String selectedLevel = 'All';

  Future<void> openAddTrainingScreen() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddTrainingScreen(),
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<TrainingModel> filterTrainings(List<TrainingModel> trainings) {
    return trainings.where((item) {
      final title = item.title.toLowerCase();
      final category = item.category.toLowerCase();
      final level = item.level.toLowerCase();
      final query = searchText.toLowerCase();

      final matchesSearch = title.contains(query) || category.contains(query);

      final matchesLevel =
          selectedLevel == 'All' || item.level == selectedLevel;

      return matchesSearch && matchesLevel;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Training'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search training...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchText.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          searchController.clear();
                          setState(() {
                            searchText = '';
                          });
                        },
                        icon: const Icon(Icons.clear),
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 6, 12, 8),
            child: DropdownButtonFormField<String>(
              value: selectedLevel,
              decoration: InputDecoration(
                labelText: 'Filter by Level',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: const [
                DropdownMenuItem(value: 'All', child: Text('All')),
                DropdownMenuItem(value: 'Beginner', child: Text('Beginner')),
                DropdownMenuItem(
                  value: 'Intermediate',
                  child: Text('Intermediate'),
                ),
                DropdownMenuItem(value: 'Advanced', child: Text('Advanced')),
              ],
              onChanged: (value) {
                setState(() {
                  selectedLevel = value ?? 'All';
                });
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<List<TrainingModel>>(
              stream: firestoreService.getTrainingsStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                final trainings = snapshot.data ?? [];
                final filteredTrainings = filterTrainings(trainings);

                if (trainings.isEmpty) {
                  return const Center(
                    child: Text('No training data found'),
                  );
                }

                if (filteredTrainings.isEmpty) {
                  return const Center(
                    child: Text('No matching training found'),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: filteredTrainings.length,
                  itemBuilder: (context, index) {
                    final item = filteredTrainings[index];

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
                          item.title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text('${item.category} • ${item.level}'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TrainingDetailScreen(
                                training: item,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openAddTrainingScreen,
        child: const Icon(Icons.add),
      ),
    );
  }
}
