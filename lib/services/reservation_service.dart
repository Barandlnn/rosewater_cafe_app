import 'package:cloud_firestore/cloud_firestore.dart';

class ReservationService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<String> createReservation({
    required String uid,
    required String eventType,
    required DateTime eventDateTime,
    required int duration,
    required int guestCount,
    required double baseRate,
    required double estimatedTotal,
    required String currency,
  }) async {
    final documentReference = await _firestore.collection('reservations').add({
      'userId': uid,
      'eventId': 'private_event',
      'eventType': eventType.trim(),
      'eventDateTime': Timestamp.fromDate(eventDateTime),
      'duration': duration,
      'guestCount': guestCount,
      'baseRate': baseRate,
      'estimatedTotal': estimatedTotal,
      'currency': currency,
      'status': 'confirmed',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    return documentReference.id;
  }
  static Future<Map<String, dynamic>?> getReservationById({
    required String reservationId,
  }) async {
    final document = await _firestore
        .collection('reservations')
        .doc(reservationId)
        .get();

    if (!document.exists) {
      return null;
    }

    final data = document.data();

    if (data == null) {
      return null;
    }

    return {'id': document.id, ...data};
  }
}
