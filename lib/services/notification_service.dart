import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/notification_model.dart';

class NotificationService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static CollectionReference<Map<String, dynamic>> _notificationsReference({
    required String uid,
  }) {
    return _firestore.collection('users').doc(uid).collection('notifications');
  }

  static Future<List<NotificationModel>> getNotifications({
    required String uid,
  }) async {
    final snapshot = await _notificationsReference(
      uid: uid,
    ).orderBy('createdAt', descending: true).get();

    return snapshot.docs
        .map(
          (document) =>
              NotificationModel.fromMap(id: document.id, map: document.data()),
        )
        .toList();
  }

  static Future<void> createReservationConfirmation({
    required String uid,
    required String reservationId,
  }) async {
    await _notificationsReference(uid: uid).doc(reservationId).set({
      'title': 'Event Reservation Confirmed',
      'message': 'Your private event reservation has been confirmed.',
      'type': 'event',
      'isRead': false,
      'hasDetails': true,
      'reservationId': reservationId,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  static Future<void> markAsRead({
    required String uid,
    required String notificationId,
  }) async {
    await _notificationsReference(uid: uid).doc(notificationId).update({
      'isRead': true,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  static Future<void> deleteNotification({
    required String uid,
    required String notificationId,
  }) async {
    await _notificationsReference(uid: uid).doc(notificationId).delete();
  }

  static Future<int> getUnreadCount({required String uid}) async {
    final snapshot = await _notificationsReference(
      uid: uid,
    ).where('isRead', isEqualTo: false).get();

    return snapshot.docs.length;
  }
}
