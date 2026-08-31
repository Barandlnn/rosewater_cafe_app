import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../services/notification_settings_service.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  bool _pushNotifications = true;
  bool _emailNotifications = true;
  bool _smsNotifications = false;
  bool _soundAndVibration = true;

  bool _eventReminders = true;
  bool _allowanceAlerts = true;
  bool _promotionsAndOffers = true;

  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final user = AuthService.currentUser;

    if (user == null) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
      });

      return;
    }

    try {
      var settings = await NotificationSettingsService.getSettings(
        uid: user.uid,
      );

      if (settings == null) {
        await NotificationSettingsService.createDefaultSettings(uid: user.uid);

        settings = await NotificationSettingsService.getSettings(uid: user.uid);
      }

      if (!mounted) {
        return;
      }

      setState(() {
        _pushNotifications = settings?['pushNotifications'] as bool? ?? true;

        _emailNotifications = settings?['emailNotifications'] as bool? ?? true;

        _smsNotifications = settings?['smsNotifications'] as bool? ?? false;

        _soundAndVibration = settings?['soundAndVibration'] as bool? ?? true;

        _eventReminders = settings?['eventReminders'] as bool? ?? true;

        _allowanceAlerts = settings?['allowanceAlerts'] as bool? ?? true;

        _promotionsAndOffers =
            settings?['promotionsAndOffers'] as bool? ?? true;

        _isLoading = false;
      });
    } on FirebaseException catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Notification settings could not be loaded (${error.code}).',
          ),
        ),
      );
    }
  }

  Future<void> _saveSettings() async {
    final user = AuthService.currentUser;

    if (user == null || _isSaving) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      await NotificationSettingsService.updateSettings(
        uid: user.uid,
        pushNotifications: _pushNotifications,
        emailNotifications: _emailNotifications,
        smsNotifications: _smsNotifications,
        soundAndVibration: _soundAndVibration,
        eventReminders: _eventReminders,
        allowanceAlerts: _allowanceAlerts,
        promotionsAndOffers: _promotionsAndOffers,
      );

      if (!mounted) {
        return;
      }

      Navigator.pop(context);
    } on FirebaseException catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isSaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Notification settings could not be saved (${error.code}).',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFFFF7FB),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFFF7FB),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              _buildHeader(),

              const SizedBox(height: 8),

              _buildCommunicationHeader(),

              _buildPreferenceRow(
                icon: Icons.notifications_none,
                title: 'Push Notifications',
                subtitle: 'Receive notifications on your device',
                value: _pushNotifications,
                onChanged: (value) {
                  setState(() {
                    _pushNotifications = value;
                  });
                },
              ),

              _buildPreferenceRow(
                icon: Icons.email_outlined,
                title: 'Email Notifications',
                subtitle: 'Get updates via email',
                value: _emailNotifications,
                onChanged: (value) {
                  setState(() {
                    _emailNotifications = value;
                  });
                },
              ),

              _buildPreferenceRow(
                icon: Icons.chat_bubble_outline,
                title: 'SMS Notifications',
                subtitle: 'Receive text messages for\nimportant updates',
                value: _smsNotifications,
                onChanged: (value) {
                  setState(() {
                    _smsNotifications = value;
                  });
                },
              ),

              _buildPreferenceRow(
                icon: Icons.volume_up_outlined,
                title: 'Sound & Vibration',
                subtitle: 'Play sound when notifications arrive',
                value: _soundAndVibration,
                onChanged: (value) {
                  setState(() {
                    _soundAndVibration = value;
                  });
                },
                isLast: true,
              ),

              const SizedBox(height: 20),

              _buildNotificationTypesHeader(),

              _buildPreferenceRow(
                icon: Icons.notifications_none,
                title: 'Event Reminders',
                subtitle: 'Get reminded about your\nupcoming reservations',
                value: _eventReminders,
                onChanged: (value) {
                  setState(() {
                    _eventReminders = value;
                  });
                },
              ),

              _buildPreferenceRow(
                icon: Icons.notifications_none,
                title: 'Allowance Alerts',
                subtitle: 'Notify when allowances are\nrunning low',
                value: _allowanceAlerts,
                onChanged: (value) {
                  setState(() {
                    _allowanceAlerts = value;
                  });
                },
              ),

              _buildPreferenceRow(
                icon: Icons.notifications_none,
                title: 'Promotions & Offers',
                subtitle: 'Receive special deals and\nmember benefits',
                value: _promotionsAndOffers,
                onChanged: (value) {
                  setState(() {
                    _promotionsAndOffers = value;
                  });
                },
                isLast: true,
              ),

              const SizedBox(height: 20),

              _buildDoneButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return SizedBox(
      height: 48,
      child: Row(
        children: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            borderRadius: BorderRadius.circular(20),
            child: const SizedBox(
              width: 32,
              height: 40,
              child: Icon(Icons.arrow_back, size: 18, color: Color(0xFF1E2939)),
            ),
          ),

          const SizedBox(width: 8),

          const Text(
            'Notifications',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1E2939),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommunicationHeader() {
    return Container(
      width: double.infinity,
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFFFF2056), Color(0xFF9810FA)],
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(14),
          topRight: Radius.circular(14),
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Communication Preferences',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Choose how you want to be notified',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreferenceRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    bool isLast = false,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.90),
        borderRadius: isLast
            ? const BorderRadius.only(
                bottomLeft: Radius.circular(14),
                bottomRight: Radius.circular(14),
              )
            : BorderRadius.zero,
        border: Border(
          bottom: BorderSide(
            color: Colors.black.withValues(alpha: 0.06),
            width: 0.5,
          ),
          left: BorderSide(
            color: Colors.black.withValues(alpha: 0.06),
            width: 0.5,
          ),
          right: BorderSide(
            color: Colors.black.withValues(alpha: 0.06),
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFF4A5565)),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1E2939),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF6A7282),
                  ),
                ),
              ],
            ),
          ),

          Transform.scale(
            scale: 0.85,
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeThumbColor: Colors.white,
              activeTrackColor: const Color(0xFFF20D4F),
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: const Color(0xFFD1D5DB),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationTypesHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.90),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(14),
          topRight: Radius.circular(14),
        ),
        border: Border(
          top: BorderSide(
            color: Colors.black.withValues(alpha: 0.06),
            width: 0.5,
          ),
          left: BorderSide(
            color: Colors.black.withValues(alpha: 0.06),
            width: 0.5,
          ),
          right: BorderSide(
            color: Colors.black.withValues(alpha: 0.06),
            width: 0.5,
          ),
        ),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        color: const Color(0xFFF3F4F6),
        child: const Text(
          'Notification Types',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1E2939),
          ),
        ),
      ),
    );
  }

  Widget _buildDoneButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton(
        onPressed: _isSaving ? null : _saveSettings,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white.withValues(alpha: 0.90),
          foregroundColor: const Color(0xFF1E2939),
          side: BorderSide(
            color: Colors.black.withValues(alpha: 0.08),
            width: 0.5,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: _isSaving
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Text(
                'Done',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
      ),
    );
  }
}
