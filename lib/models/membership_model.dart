import 'package:cloud_firestore/cloud_firestore.dart';

class MembershipModel {
  final String plan;
  final String status;
  final String memberId;
  final DateTime? startedAt;
  final DateTime? validUntil;
  final int maxGuests;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const MembershipModel({
    required this.plan,
    required this.status,
    required this.memberId,
    required this.startedAt,
    required this.validUntil,
    required this.maxGuests,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MembershipModel.fromMap(Map<String, dynamic> map) {
    return MembershipModel(
      plan: map['plan'] as String? ?? '',
      status: map['status'] as String? ?? '',
      memberId: map['memberId'] as String? ?? '',
      startedAt: _toDate(map['startedAt']),
      validUntil: _toDate(map['validUntil']),
      maxGuests: (map['maxGuests'] as num?)?.toInt() ?? 0,
      createdAt: _toDate(map['createdAt']),
      updatedAt: _toDate(map['updatedAt']),
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
