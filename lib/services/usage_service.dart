import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/usage_model.dart';

class UsageService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static String get currentMonthId {
    final now = DateTime.now();

    final month = now.month.toString().padLeft(2, '0');

    return '${now.year}-$month';
  }

  static Future<void> createMonthlyUsage({required String uid}) async {
    final monthId = currentMonthId;

    final documentReference = _firestore
        .collection('usage')
        .doc(uid)
        .collection('months')
        .doc(monthId);

    final document = await documentReference.get();

    if (document.exists) {
      return;
    }

    await documentReference.set({
      'hookahUsed': 0,
      'drinksUsed': 0,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  static Future<UsageModel?> getCurrentUsage({required String uid}) async {
    final monthId = currentMonthId;

    final document = await _firestore
        .collection('usage')
        .doc(uid)
        .collection('months')
        .doc(monthId)
        .get();

    if (!document.exists) {
      return null;
    }

    final data = document.data();

    if (data == null) {
      return null;
    }

    return UsageModel.fromMap(data);
  }
}
