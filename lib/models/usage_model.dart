import 'package:cloud_firestore/cloud_firestore.dart';

class UsageModel {
  final int hookahUsed;
  final int drinksUsed;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UsageModel({
    required this.hookahUsed,
    required this.drinksUsed,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UsageModel.fromMap(Map<String, dynamic> map) {
    return UsageModel(
      hookahUsed: (map['hookahUsed'] as num?)?.toInt() ?? 0,
      drinksUsed: (map['drinksUsed'] as num?)?.toInt() ?? 0,
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
