import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String id;
  final String title;
  final String message;
  final String type;
  final bool isRead;
  final bool hasDetails;
  final String? reservationId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.isRead,
    required this.hasDetails,
    required this.reservationId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NotificationModel.fromMap({
    required String id,
    required Map<String, dynamic> map,
  }) {
    return NotificationModel(
      id: id,
      title: map['title'] as String? ?? 'Notification',
      message: map['message'] as String? ?? '',
      type: map['type'] as String? ?? 'info',
      isRead: map['isRead'] as bool? ?? false,
      hasDetails: map['hasDetails'] as bool? ?? false,
      reservationId: map['reservationId'] as String?,
      createdAt: _toDate(map['createdAt']),
      updatedAt: _toDate(map['updatedAt']),
    );
  }

  NotificationModel copyWith({bool? isRead}) {
    return NotificationModel(
      id: id,
      title: title,
      message: message,
      type: type,
      isRead: isRead ?? this.isRead,
      hasDetails: hasDetails,
      reservationId: reservationId,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  static DateTime? _toDate(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is DateTime) {
      return value;
    }

    return null;
  }
}
