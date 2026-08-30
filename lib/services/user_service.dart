import 'package:cloud_firestore/cloud_firestore.dart';

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

  static Future<Map<String, dynamic>?> getUserProfile({
    required String uid,
  }) async {
    final document = await _firestore.collection('users').doc(uid).get();

    if (!document.exists) {
      return null;
    }

    return document.data();
  }
}
