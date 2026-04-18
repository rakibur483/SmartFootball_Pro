class InjuryModel {
  final String id;
  final String title;
  final String category;
  final String bodyPart;
  final String description;
  final String symptoms;
  final String causes;
  final String recoveryTime;
  final String preventionTips;
  final String imageUrl;

  InjuryModel({
    required this.id,
    required this.title,
    required this.category,
    required this.bodyPart,
    required this.description,
    required this.symptoms,
    required this.causes,
    required this.recoveryTime,
    required this.preventionTips,
    required this.imageUrl,
  });

  factory InjuryModel.fromMap(String id, Map<String, dynamic> data) {
    return InjuryModel(
      id: id,
      title: data['title'] ?? '',
      category: data['category'] ?? '',
      bodyPart: data['bodyPart'] ?? '',
      description: data['description'] ?? '',
      symptoms: data['symptoms'] ?? '',
      causes: data['causes'] ?? '',
      recoveryTime: data['recoveryTime'] ?? '',
      preventionTips: data['preventionTips'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
    );
  }
}