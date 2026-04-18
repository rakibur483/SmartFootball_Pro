class TrainingModel {
  final String id;
  final String title;
  final String category;
  final String level;
  final String duration;
  final String description;
  final String benefits;
  final String steps;
  final String videoUrl;
  final String imageUrl;

  TrainingModel({
    required this.id,
    required this.title,
    required this.category,
    required this.level,
    required this.duration,
    required this.description,
    required this.benefits,
    required this.steps,
    required this.videoUrl,
    required this.imageUrl,
  });

  factory TrainingModel.fromMap(String id, Map<String, dynamic> data) {
    return TrainingModel(
      id: id,
      title: data['title'] ?? '',
      category: data['category'] ?? '',
      level: data['level'] ?? '',
      duration: data['duration'] ?? '',
      description: data['description'] ?? '',
      benefits: data['benefits'] ?? '',
      steps: data['steps'] ?? '',
      videoUrl: data['videoUrl'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
    );
  }
}