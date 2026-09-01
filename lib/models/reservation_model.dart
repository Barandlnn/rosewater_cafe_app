import 'package:cloud_firestore/cloud_firestore.dart';

class ReservationModel {
  final String id;
  final String userId;
  final String eventId;
  final String eventType;
  final DateTime? eventDateTime;
  final int duration;
  final int guestCount;
  final double baseRate;
  final double estimatedTotal;
  final String currency;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ReservationModel({
    required this.id,
    required this.userId,
    required this.eventId,
    required this.eventType,
    required this.eventDateTime,
    required this.duration,
    required this.guestCount,
    required this.baseRate,
    required this.estimatedTotal,
    required this.currency,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ReservationModel.fromMap({
    required String id,
    required Map<String, dynamic> map,
  }) {
    return ReservationModel(
      id: id,
      userId: map['userId'] as String? ?? '',
      eventId: map['eventId'] as String? ?? '',
      eventType: map['eventType'] as String? ?? '',
      eventDateTime: _toDate(map['eventDateTime']),
      duration: (map['duration'] as num?)?.toInt() ?? 0,
      guestCount: (map['guestCount'] as num?)?.toInt() ?? 0,
      baseRate: (map['baseRate'] as num?)?.toDouble() ?? 0,
      estimatedTotal: (map['estimatedTotal'] as num?)?.toDouble() ?? 0,
      currency: map['currency'] as String? ?? '',
      status: map['status'] as String? ?? '',
      createdAt: _toDate(map['createdAt']),
      updatedAt: _toDate(map['updatedAt']),
    );
  }

  static DateTime? _toDate(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return null;
  }
}
