import 'package:flutter/material.dart';
import '../models/injury_model.dart';
import '../services/firestore_service.dart';
import 'add_injury_screen.dart';
import 'injury_detail_screen.dart';

class InjuryScreen extends StatefulWidget {
  const InjuryScreen({super.key});

  @override
  State<InjuryScreen> createState() => _InjuryScreenState();
}

class _InjuryScreenState extends State<InjuryScreen> {
  final FirestoreService firestoreService = FirestoreService();
  final TextEditingController searchController = TextEditingController();

  String searchText = '';
  String selectedCategory = 'All';

  Future<void> openAddInjuryScreen() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddInjuryScreen(),
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<InjuryModel> filterInjuries(List<InjuryModel> injuries) {
    return injuries.where((item) {
      final title = item.title.toLowerCase();
      final category = item.category.toLowerCase();
      final bodyPart = item.bodyPart.toLowerCase();
      final query = searchText.toLowerCase();

      final matchesSearch =
          title.contains(query) ||
          category.contains(query) ||
          bodyPart.contains(query);

      final matchesCategory =
          selectedCategory == 'All' || item.category == selectedCategory;

      return matchesSearch && matchesCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Injury Prevention'),
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
                hintText: 'Search injury...',
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
              value: selectedCategory,
              decoration: InputDecoration(
                labelText: 'Filter by Category',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: const [
                DropdownMenuItem(value: 'All', child: Text('All')),
                DropdownMenuItem(
                  value: 'Muscle Injury',
                  child: Text('Muscle Injury'),
                ),
                DropdownMenuItem(
                  value: 'Ligament Injury',
                  child: Text('Ligament Injury'),
                ),
                DropdownMenuItem(
                  value: 'Joint Injury',
                  child: Text('Joint Injury'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  selectedCategory = value ?? 'All';
                });
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<List<InjuryModel>>(
              stream: firestoreService.getInjuriesStream(),
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

                final injuries = snapshot.data ?? [];
                final filteredInjuries = filterInjuries(injuries);

                if (injuries.isEmpty) {
                  return const Center(
                    child: Text('No injury data found'),
                  );
                }

                if (filteredInjuries.isEmpty) {
                  return const Center(
                    child: Text('No matching injury found'),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: filteredInjuries.length,
                  itemBuilder: (context, index) {
                    final item = filteredInjuries[index];

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
                          item.title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text('${item.category} • ${item.bodyPart}'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => InjuryDetailScreen(
                                injury: item,
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
        onPressed: openAddInjuryScreen,
        child: const Icon(Icons.add),
      ),
    );
  }
}