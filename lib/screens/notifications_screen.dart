import 'package:flutter/material.dart';

import '../services/notification_store.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  int get _unreadCount => NotificationStore.unreadCount;

  void _markAsRead(int id) {
    setState(() {
      NotificationStore.markAsRead(id);
    });
  }

  void _deleteNotification(int id) {
    setState(() {
      NotificationStore.deleteNotification(id);
    });
  }

  void _showDetails(AppNotification notification) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${notification.title} details will be connected later'),
      ),
    );
  }

  void _goBack() {
    Navigator.pop(context, _unreadCount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F9),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: _goBack,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 40,
                      minHeight: 40,
                    ),
                    icon: const Icon(
                      Icons.arrow_back,
                      size: 20,
                      color: Color(0xFF1E2939),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Notifications',
                          style: TextStyle(
                            color: Color(0xFF1E2939),
                            fontSize: 28,
                            height: 1.1,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$_unreadCount unread '
                          '${_unreadCount == 1 ? 'notification' : 'notifications'}',
                          style: const TextStyle(
                            color: Color(0xFF6A7282),
                            fontSize: 14,
                            height: 1.3,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // NOTIFICATION LIST
              if (NotificationStore.notifications.isEmpty)
                const SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.only(top: 80),
                    child: Column(
                      children: [
                        Icon(
                          Icons.notifications_none_outlined,
                          size: 40,
                          color: Color(0xFF9CA3AF),
                        ),
                        SizedBox(height: 12),
                        Text(
                          'No notifications',
                          style: TextStyle(
                            color: Color(0xFF6A7282),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                ...NotificationStore.notifications.map(
                  (notification) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildNotificationCard(notification),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationCard(AppNotification notification) {
    final bool isUnread = !notification.isRead;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.90),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isUnread
              ? const Color(0xFFFF2056)
              : Colors.black.withValues(alpha: 0.10),
          width: isUnread ? 1 : 0.52,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ICON
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: notification.iconBackground,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(
              notification.icon,
              color: notification.iconColor,
              size: 22,
            ),
          ),

          const SizedBox(width: 12),

          // CONTENT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TITLE + TIME + UNREAD DOT
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        notification.title,
                        style: const TextStyle(
                          color: Color(0xFF1E2939),
                          fontSize: 16,
                          height: 1.25,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),

                    Text(
                      notification.time,
                      style: const TextStyle(
                        color: Color(0xFF6A7282),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),

                    if (isUnread) ...[
                      const SizedBox(width: 8),
                      Container(
                        width: 7,
                        height: 7,
                        margin: const EdgeInsets.only(top: 4),
                        decoration: const BoxDecoration(
                          color: Color(0xFFEC003F),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ],
                ),

                const SizedBox(height: 6),

                // MESSAGE
                Text(
                  notification.message,
                  style: const TextStyle(
                    color: Color(0xFF4A5565),
                    fontSize: 14,
                    height: 1.35,
                    fontWeight: FontWeight.w400,
                  ),
                ),

                const SizedBox(height: 10),

                // ACTIONS
                Row(
                  children: [
                    if (isUnread)
                      TextButton.icon(
                        onPressed: () {
                          _markAsRead(notification.id);
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFFEC003F),
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(0, 32),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        icon: const Icon(Icons.check, size: 16),
                        label: const Text(
                          'Mark as Read',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                    if (isUnread && notification.hasDetails)
                      const SizedBox(width: 20),

                    if (notification.hasDetails)
                      TextButton(
                        onPressed: () {
                          _showDetails(notification);
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF9810FA),
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(0, 32),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text(
                          'View Details',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                    const Spacer(),

                    IconButton(
                      onPressed: () {
                        _deleteNotification(notification.id);
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                      tooltip: 'Delete notification',
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Color(0xFF6A7282),
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
