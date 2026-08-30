import 'package:cloud_firestore/cloud_firestore.dart';

class MembershipService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> createMembership({
    required String uid,
    required String plan,
  }) async {
    final now = DateTime.now();

    final validUntil = DateTime(now.year + 1, now.month, now.day);

    final memberId = now.millisecondsSinceEpoch.toString();

    final maxGuests = _getMaxGuests(plan);

    await _firestore.collection('memberships').doc(uid).set({
      'plan': plan,
      'status': 'active',
      'memberId': memberId,
      'startedAt': Timestamp.fromDate(now),
      'validUntil': Timestamp.fromDate(validUntil),
      'maxGuests': maxGuests,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  static Future<Map<String, dynamic>?> getMembership({
    required String uid,
  }) async {
    final document = await _firestore.collection('memberships').doc(uid).get();

    if (!document.exists) {
      return null;
    }

    return document.data();
  }

  static int _getMaxGuests(String plan) {
    switch (plan) {
      case 'Basic':
        return 1;

      case 'Premium':
        return 2;

      case 'VIP':
        return 2;

      default:
        throw ArgumentError('Unknown membership plan: $plan');
    }
  }
}
