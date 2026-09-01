import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/event_model.dart';

class EventService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<EventModel?> getPrivateEvent() async {
    final document = await _firestore
        .collection('events')
        .doc('private_event')
        .get();

    if (!document.exists) {
      return null;
    }

    final data = document.data();

    if (data == null) {
      return null;
    }

    return EventModel.fromMap(data);
  }
}
