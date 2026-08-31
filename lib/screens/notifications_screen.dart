import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../services/notification_service.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<Map<String, dynamic>> _notifications = [];

  bool _isLoading = true;
  String? _errorMessage;

  int get _unreadCount {
    return _notifications.where((notification) {
      return notification['isRead'] != true;
    }).length;
  }

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    final user = AuthService.currentUser;

    if (user == null) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'You must be signed in to view notifications.';
      });
      return;
    }

    try {
      final notifications = await NotificationService.getNotifications(
        uid: user.uid,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _notifications = notifications;
        _isLoading = false;
        _errorMessage = null;
      });
    } on FirebaseException catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
        _errorMessage = 'Notifications could not be loaded (${error.code}).';
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
        _errorMessage = 'Notifications could not be loaded.';
      });
    }
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'event':
        return Icons.calendar_today_outlined;

      case 'allowance':
        return Icons.error_outline;

      case 'promotion':
        return Icons.card_giftcard;

      case 'payment':
        return Icons.check;

      default:
        return Icons.info_outline;
    }
  }

  Color _getIconColor(String type) {
    switch (type) {
      case 'event':
        return const Color(0xFF9810FA);

      case 'allowance':
        return const Color(0xFFF59E0B);

      case 'promotion':
        return const Color(0xFFEC003F);

      case 'payment':
        return const Color(0xFF00A63E);

      default:
        return const Color(0xFF155DFC);
    }
  }

  Color _getIconBackground(String type) {
    switch (type) {
      case 'event':
        return const Color(0xFFFAF5FF);

      case 'allowance':
        return const Color(0xFFFFFBEB);

      case 'promotion':
        return const Color(0xFFFFF1F2);

      case 'payment':
        return const Color(0xFFF0FDF4);

      default:
        return const Color(0xFFEFF6FF);
    }
  }

  String _formatNotificationTime(dynamic value) {
    if (value is! Timestamp) {
      return '';
    }

    final date = value.toDate();
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return 'Just now';
    }

    if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    }

    if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    }

    if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    }

    return '${date.month}/${date.day}/${date.year}';
  }

  void _showDetails(Map<String, dynamic> notification) {
    final title = notification['title'] as String? ?? 'Notification';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$title details will be connected later')),
    );
  }

  void _goBack() {
    Navigator.pop(context, _unreadCount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F9),
      body: SafeArea(child: _buildBody()),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                size: 48,
                color: Color(0xFFB42318),
              ),
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Color(0xFF1E2939), fontSize: 16),
              ),
              const SizedBox(height: 24),
              TextButton(
                onPressed: _loadNotifications,
                child: const Text('Try Again'),
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: _goBack,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
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

          if (_notifications.isEmpty)
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
            ..._notifications.map(
              (notification) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildNotificationCard(notification),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification) {
    final bool isUnread = notification['isRead'] != true;

    final String title = notification['title'] as String? ?? 'Notification';

    final String message = notification['message'] as String? ?? '';

    final String type = notification['type'] as String? ?? 'info';

    final bool hasDetails = notification['hasDetails'] == true;

    final dynamic createdAt = notification['createdAt'];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
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
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _getIconBackground(type),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(
              _getNotificationIcon(type),
              color: _getIconColor(type),
              size: 22,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        title,
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
                      _formatNotificationTime(createdAt),
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

                Text(
                  message,
                  style: const TextStyle(
                    color: Color(0xFF4A5565),
                    fontSize: 14,
                    height: 1.35,
                    fontWeight: FontWeight.w400,
                  ),
                ),

                if (hasDetails) ...[
                  const SizedBox(height: 10),
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
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
