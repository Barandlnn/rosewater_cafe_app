import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfileModel {
  final String fullName;
  final String email;
  final String phone;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserProfileModel({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserProfileModel.fromMap(Map<String, dynamic> map) {
    return UserProfileModel(
      fullName: map['fullName'] as String? ?? '',
      email: map['email'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
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
