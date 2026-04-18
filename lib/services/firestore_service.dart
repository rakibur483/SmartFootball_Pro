import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/injury_model.dart';
import '../models/training_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<InjuryModel>> getInjuries() async {
    final snapshot = await _firestore.collection('injuries').get();

    return snapshot.docs
        .map((doc) => InjuryModel.fromMap(doc.id, doc.data()))
        .toList();
  }

  Future<List<TrainingModel>> getTrainings() async {
    final snapshot = await _firestore.collection('trainings').get();

    return snapshot.docs
        .map((doc) => TrainingModel.fromMap(doc.id, doc.data()))
        .toList();
  }

  Stream<List<TrainingModel>> getTrainingsStream() {
    return _firestore.collection('trainings').snapshots().map(
      (snapshot) => snapshot.docs
          .map((doc) => TrainingModel.fromMap(doc.id, doc.data()))
          .toList(),
    );
  }

  Stream<List<InjuryModel>> getInjuriesStream() {
    return _firestore.collection('injuries').snapshots().map(
      (snapshot) => snapshot.docs
          .map((doc) => InjuryModel.fromMap(doc.id, doc.data()))
          .toList(),
    );
  }

  Future<void> addTraining({
    required String title,
    required String category,
    required String level,
    required String duration,
    required String description,
    required String benefits,
    required String steps,
    required String videoUrl,
    required String imageUrl,
  }) async {
    await _firestore.collection('trainings').add({
      'title': title,
      'category': category,
      'level': level,
      'duration': duration,
      'description': description,
      'benefits': benefits,
      'steps': steps,
      'videoUrl': videoUrl,
      'imageUrl': imageUrl,
    });
  }

  Future<void> addInjury({
    required String title,
    required String category,
    required String bodyPart,
    required String description,
    required String symptoms,
    required String causes,
    required String recoveryTime,
    required String preventionTips,
    required String imageUrl,
  }) async {
    await _firestore.collection('injuries').add({
      'title': title,
      'category': category,
      'bodyPart': bodyPart,
      'description': description,
      'symptoms': symptoms,
      'causes': causes,
      'recoveryTime': recoveryTime,
      'preventionTips': preventionTips,
      'imageUrl': imageUrl,
    });
  }

  Future<void> updateTraining({
    required String id,
    required String title,
    required String category,
    required String level,
    required String duration,
    required String description,
    required String benefits,
    required String steps,
    required String videoUrl,
    required String imageUrl,
  }) async {
    await _firestore.collection('trainings').doc(id).update({
      'title': title,
      'category': category,
      'level': level,
      'duration': duration,
      'description': description,
      'benefits': benefits,
      'steps': steps,
      'videoUrl': videoUrl,
      'imageUrl': imageUrl,
    });
  }

  Future<void> updateInjury({
    required String id,
    required String title,
    required String category,
    required String bodyPart,
    required String description,
    required String symptoms,
    required String causes,
    required String recoveryTime,
    required String preventionTips,
    required String imageUrl,
  }) async {
    await _firestore.collection('injuries').doc(id).update({
      'title': title,
      'category': category,
      'bodyPart': bodyPart,
      'description': description,
      'symptoms': symptoms,
      'causes': causes,
      'recoveryTime': recoveryTime,
      'preventionTips': preventionTips,
      'imageUrl': imageUrl,
    });
  }

  Future<void> deleteTraining(String id) async {
    await _firestore.collection('trainings').doc(id).delete();
  }

  Future<void> deleteInjury(String id) async {
    await _firestore.collection('injuries').doc(id).delete();
  }

  Future<void> markTrainingCompleted({
    required TrainingModel training,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }

    await _firestore.collection('progress').add({
      'userId': user.uid,
      'title': training.title,
      'category': training.category,
      'level': training.level,
      'duration': training.duration,
      'description': training.description,
      'completedAt': Timestamp.now(),
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getUserProgressStream() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }

    return _firestore
        .collection('progress')
        .where('userId', isEqualTo: user.uid)
        .orderBy('completedAt', descending: true)
        .snapshots();
  }
}