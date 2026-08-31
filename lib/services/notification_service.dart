import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static CollectionReference<Map<String, dynamic>> _notificationsReference({
    required String uid,
  }) {
    return _firestore.collection('users').doc(uid).collection('notifications');
  }

  static Future<List<Map<String, dynamic>>> getNotifications({
    required String uid,
  }) async {
    final snapshot = await _notificationsReference(
      uid: uid,
    ).orderBy('createdAt', descending: true).get();

    return snapshot.docs.map((document) {
      return {'id': document.id, ...document.data()};
    }).toList();
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
