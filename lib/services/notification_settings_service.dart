import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationSettingsService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static DocumentReference<Map<String, dynamic>> _settingsReference({
    required String uid,
  }) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('settings')
        .doc('notifications');
  }

  static Future<Map<String, dynamic>?> getSettings({
    required String uid,
  }) async {
    final snapshot = await _settingsReference(uid: uid).get();

    if (!snapshot.exists) {
      return null;
    }

    return snapshot.data();
  }

  static Future<void> createDefaultSettings({required String uid}) async {
    await _settingsReference(uid: uid).set({
      'pushNotifications': true,
      'emailNotifications': true,
      'smsNotifications': false,
      'soundAndVibration': true,
      'eventReminders': true,
      'allowanceAlerts': true,
      'promotionsAndOffers': true,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  static Future<void> updateSettings({
    required String uid,
    required bool pushNotifications,
    required bool emailNotifications,
    required bool smsNotifications,
    required bool soundAndVibration,
    required bool eventReminders,
    required bool allowanceAlerts,
    required bool promotionsAndOffers,
  }) async {
    await _settingsReference(uid: uid).update({
      'pushNotifications': pushNotifications,
      'emailNotifications': emailNotifications,
      'smsNotifications': smsNotifications,
      'soundAndVibration': soundAndVibration,
      'eventReminders': eventReminders,
      'allowanceAlerts': allowanceAlerts,
      'promotionsAndOffers': promotionsAndOffers,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}
