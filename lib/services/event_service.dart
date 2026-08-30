import 'package:cloud_firestore/cloud_firestore.dart';

class EventService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<Map<String, dynamic>?> getPrivateEvent() async {
    final document = await _firestore
        .collection('events')
        .doc('private_event')
        .get();

    if (!document.exists) {
      return null;
    }

    return document.data();
  }
}
