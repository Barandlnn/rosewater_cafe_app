import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AccountDeletionException implements Exception {
  const AccountDeletionException({required this.stage, required this.cause});

  final String stage;
  final Object cause;

  @override
  String toString() {
    return 'Account deletion failed during $stage: $cause';
  }
}

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

    await _runDeletionStage(
      stage: 'notifications',
      action: () => _deleteNotifications(uid),
    );

    await _runDeletionStage(
      stage: 'notification settings',
      action: () => _deleteNotificationSettings(uid),
    );

    await _runDeletionStage(stage: 'usage', action: () => _deleteUsage(uid));

    await _runDeletionStage(
      stage: 'reservations',
      action: () => _deleteReservations(uid),
    );

    await _runDeletionStage(
      stage: 'door access requests',
      action: () => _deleteDoorAccessRequests(uid),
    );

    await _runDeletionStage(
      stage: 'membership',
      action: () => _deleteMembership(uid),
    );

    await _runDeletionStage(
      stage: 'user profile',
      action: () => _deleteUserProfile(uid),
    );

    // ---------------------------------------------------------
    // FIREBASE AUTH
    // ---------------------------------------------------------

    await _runDeletionStage(
      stage: 'Firebase Authentication account',
      action: user.delete,
    );
  }

  static Future<void> _runDeletionStage({
    required String stage,
    required Future<void> Function() action,
  }) async {
    try {
      await action();
    } on FirebaseAuthException {
      rethrow;
    } catch (error) {
      throw AccountDeletionException(stage: stage, cause: error);
    }
  }

  static Future<void> _deleteNotifications(String uid) async {
    final query = _firestore
        .collection('users')
        .doc(uid)
        .collection('notifications');

    await _deleteQueryInBatches(query);
  }

  static Future<void> _deleteNotificationSettings(String uid) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('settings')
        .doc('notifications')
        .delete();
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
