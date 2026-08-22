import 'package:flutter/material.dart';

class AppNotification {
  const AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    required this.isRead,
    required this.hasDetails,
  });

  final int id;
  final String title;
  final String message;
  final String time;
  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final bool isRead;
  final bool hasDetails;

  AppNotification copyWith({bool? isRead}) {
    return AppNotification(
      id: id,
      title: title,
      message: message,
      time: time,
      icon: icon,
      iconColor: iconColor,
      iconBackground: iconBackground,
      isRead: isRead ?? this.isRead,
      hasDetails: hasDetails,
    );
  }
}

class NotificationStore {
  static final List<AppNotification> notifications = [
    const AppNotification(
      id: 1,
      title: 'Low Allowance Alert',
      message:
          'You have only 3 hookah sessions remaining this month. Consider your usage wisely!',
      time: '2h ago',
      icon: Icons.error_outline,
      iconColor: Color(0xFFF59E0B),
      iconBackground: Color(0xFFFFFBEB),
      isRead: false,
      hasDetails: false,
    ),
    const AppNotification(
      id: 2,
      title: 'Event Reminder',
      message:
          'Your private event reservation is coming up tomorrow at 7:00 PM for 15 guests.',
      time: '5h ago',
      icon: Icons.calendar_today_outlined,
      iconColor: Color(0xFF9810FA),
      iconBackground: Color(0xFFFAF5FF),
      isRead: false,
      hasDetails: true,
    ),
    const AppNotification(
      id: 3,
      title: 'Weekend Special! 🎉',
      message:
          'This weekend only: VIP members get 20% off all event bookings. Book your celebration now!',
      time: '1d ago',
      icon: Icons.card_giftcard,
      iconColor: Color(0xFFEC003F),
      iconBackground: Color(0xFFFFF1F2),
      isRead: true,
      hasDetails: true,
    ),
    const AppNotification(
      id: 4,
      title: 'Payment Successful',
      message:
          'Your monthly subscription has been renewed successfully. Thank you for being a valued member!',
      time: '2d ago',
      icon: Icons.check,
      iconColor: Color(0xFF00A63E),
      iconBackground: Color(0xFFF0FDF4),
      isRead: true,
      hasDetails: false,
    ),
    const AppNotification(
      id: 5,
      title: 'New Menu Items Available',
      message:
          'Check out our new premium hookah flavors: Blueberry Mint and Passion Fruit Paradise!',
      time: '3d ago',
      icon: Icons.info_outline,
      iconColor: Color(0xFF155DFC),
      iconBackground: Color(0xFFEFF6FF),
      isRead: true,
      hasDetails: false,
    ),
    const AppNotification(
      id: 6,
      title: 'Welcome to Rosewater Café! 🌹',
      message:
          'Thank you for joining our VIP membership program. Enjoy exclusive benefits and priority access!',
      time: '1/7/2026',
      icon: Icons.info_outline,
      iconColor: Color(0xFF155DFC),
      iconBackground: Color(0xFFEFF6FF),
      isRead: true,
      hasDetails: false,
    ),
  ];

  static int get unreadCount {
    return notifications.where((notification) => !notification.isRead).length;
  }

  static void markAsRead(int id) {
    final index = notifications.indexWhere(
      (notification) => notification.id == id,
    );

    if (index == -1) return;

    notifications[index] = notifications[index].copyWith(isRead: true);
  }

  static void deleteNotification(int id) {
    notifications.removeWhere((notification) => notification.id == id);
  }
}
