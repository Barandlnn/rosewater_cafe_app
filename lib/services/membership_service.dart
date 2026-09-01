import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/membership_model.dart';
import 'usage_service.dart';

class MembershipService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> createMembershipWithUsage({
    required String uid,
    required String plan,
  }) async {
    final now = DateTime.now();

    final validUntil = DateTime(now.year + 1, now.month, now.day);

    final memberId = now.millisecondsSinceEpoch.toString();

    final maxGuests = _getMaxGuests(plan);

    final monthId = UsageService.currentMonthId;

    final membershipReference = _firestore.collection('memberships').doc(uid);

    final usageReference = _firestore
        .collection('usage')
        .doc(uid)
        .collection('months')
        .doc(monthId);

    final batch = _firestore.batch();

    // ---------------------------------------------------------
    // MEMBERSHIP
    // ---------------------------------------------------------

    batch.set(membershipReference, {
      'plan': plan,
      'status': 'active',
      'memberId': memberId,
      'startedAt': Timestamp.fromDate(now),
      'validUntil': Timestamp.fromDate(validUntil),
      'maxGuests': maxGuests,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    // ---------------------------------------------------------
    // INITIAL MONTHLY USAGE
    // ---------------------------------------------------------

    batch.set(usageReference, {
      'hookahUsed': 0,
      'drinksUsed': 0,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    // Membership + usage birlikte başarılı olur veya
    // ikisi de Firestore'a yazılmaz.
    await batch.commit();
  }

  static Future<MembershipModel?> getMembership({required String uid}) async {
    final document = await _firestore.collection('memberships').doc(uid).get();

    if (!document.exists) {
      return null;
    }

    final data = document.data();

    if (data == null) {
      return null;
    }

    return MembershipModel.fromMap(data);
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
