import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationSettingsModel {
  final bool pushNotifications;
  final bool emailNotifications;
  final bool smsNotifications;
  final bool soundAndVibration;
  final bool eventReminders;
  final bool allowanceAlerts;
  final bool promotionsAndOffers;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const NotificationSettingsModel({
    required this.pushNotifications,
    required this.emailNotifications,
    required this.smsNotifications,
    required this.soundAndVibration,
    required this.eventReminders,
    required this.allowanceAlerts,
    required this.promotionsAndOffers,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NotificationSettingsModel.fromMap(Map<String, dynamic> map) {
    return NotificationSettingsModel(
      pushNotifications: map['pushNotifications'] as bool? ?? true,
      emailNotifications: map['emailNotifications'] as bool? ?? true,
      smsNotifications: map['smsNotifications'] as bool? ?? false,
      soundAndVibration: map['soundAndVibration'] as bool? ?? true,
      eventReminders: map['eventReminders'] as bool? ?? true,
      allowanceAlerts: map['allowanceAlerts'] as bool? ?? true,
      promotionsAndOffers: map['promotionsAndOffers'] as bool? ?? true,
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
