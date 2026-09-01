import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_profile_model.dart';

class UserService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static Future<void> createUserProfile({
    required String uid,
    required String fullName,
    required String email,
    required String phone,
  }) async {
    await _firestore.collection('users').doc(uid).set({
      'fullName': fullName.trim(),
      'email': email.trim(),
      'phone': phone.trim(),
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  static Future<UserProfileModel?> getUserProfile({required String uid}) async {
    final document = await _firestore.collection('users').doc(uid).get();

    if (!document.exists) {
      return null;
    }

    final data = document.data();

    if (data == null) {
      return null;
    }

    return UserProfileModel.fromMap(data);
  }

  static Future<void> updateUserProfile({
    required String uid,
    required String fullName,
    required String phone,
  }) async {
    await _firestore.collection('users').doc(uid).update({
      'fullName': fullName.trim(),
      'phone': phone.trim(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}
