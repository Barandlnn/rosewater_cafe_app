import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AccountService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> deleteAccount({required String currentPassword}) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw FirebaseAuthException(
        code: 'user-not-found',
        message: 'No signed-in user was found.',
      );
    }

    final email = user.email;

    if (email == null) {
      throw FirebaseAuthException(
        code: 'email-not-found',
        message: 'The signed-in account does not have an email address.',
      );
    }

    final uid = user.uid;

    // ---------------------------------------------------------
    // RE-AUTHENTICATION
    // ---------------------------------------------------------

    final credential = EmailAuthProvider.credential(
      email: email,
      password: currentPassword,
    );

    await user.reauthenticateWithCredential(credential);

    // ---------------------------------------------------------
    // FIRESTORE CLEANUP
    // ---------------------------------------------------------

    await _deleteNotifications(uid);

    await _deleteNotificationSettings(uid);

    await _deleteUsage(uid);

    await _deleteReservations(uid);

    await _deleteDoorAccessRequests(uid);

    await _deleteMembership(uid);

    await _deleteUserProfile(uid);

    // ---------------------------------------------------------
    // FIREBASE AUTH
    // ---------------------------------------------------------

    await user.delete();
  }

  static Future<void> _deleteNotifications(String uid) async {
    final query = _firestore
        .collection('users')
        .doc(uid)
        .collection('notifications');

    await _deleteQueryInBatches(query);
  }

  static Future<void> _deleteNotificationSettings(String uid) async {
    final document = _firestore
        .collection('users')
        .doc(uid)
        .collection('settings')
        .doc('notifications');

    await document.delete();
  }

  static Future<void> _deleteUsage(String uid) async {
    final query = _firestore.collection('usage').doc(uid).collection('months');

    await _deleteQueryInBatches(query);
  }

  static Future<void> _deleteReservations(String uid) async {
    final query = _firestore
        .collection('reservations')
        .where('userId', isEqualTo: uid);

    await _deleteQueryInBatches(query);
  }

  static Future<void> _deleteDoorAccessRequests(String uid) async {
    final query = _firestore
        .collection('doorAccessRequests')
        .where('userId', isEqualTo: uid);

    await _deleteQueryInBatches(query);
  }

  static Future<void> _deleteMembership(String uid) async {
    await _firestore.collection('memberships').doc(uid).delete();
  }

  static Future<void> _deleteUserProfile(String uid) async {
    await _firestore.collection('users').doc(uid).delete();
  }

  static Future<void> _deleteQueryInBatches(
    Query<Map<String, dynamic>> query,
  ) async {
    const batchSize = 400;

    while (true) {
      final snapshot = await query.limit(batchSize).get();

      if (snapshot.docs.isEmpty) {
        return;
      }

      final batch = _firestore.batch();

      for (final document in snapshot.docs) {
        batch.delete(document.reference);
      }

      await batch.commit();
    }
  }
}
