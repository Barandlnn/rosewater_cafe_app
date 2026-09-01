import 'package:cloud_firestore/cloud_firestore.dart';

class DoorAccessService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<({String id, DateTime expiresAt})> createAccessRequest({
    required String uid,
    required String memberId,
    required String membershipPlan,
    required int guestCount,
  }) async {
    final expiresAt = DateTime.now().add(const Duration(minutes: 5));

    final documentReference = await _firestore
        .collection('doorAccessRequests')
        .add({
          'userId': uid,
          'memberId': memberId,
          'membershipPlan': membershipPlan,
          'guestCount': guestCount,
          'status': 'pending',
          'createdAt': FieldValue.serverTimestamp(),
          'expiresAt': Timestamp.fromDate(expiresAt),
        });

    return (id: documentReference.id, expiresAt: expiresAt);
  }
}
