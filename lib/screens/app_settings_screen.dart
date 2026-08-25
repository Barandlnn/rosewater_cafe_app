import 'package:flutter/material.dart';

class AppSettingsScreen extends StatefulWidget {
  const AppSettingsScreen({super.key});

  @override
  State<AppSettingsScreen> createState() => _AppSettingsScreenState();
}

class _AppSettingsScreenState extends State<AppSettingsScreen> {
  bool _animationsEnabled = true;
  String _selectedLanguage = 'English';

  bool _soundEffectsEnabled = true;
  bool _hapticFeedbackEnabled = true;

  String _cacheSize = '12.5 MB';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7FB),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              _buildHeader(),

              const SizedBox(height: 8),

              _buildAppearanceHeader(),

              _buildAppearanceRow(
                icon: Icons.dark_mode_outlined,
                title: 'Dark Mode',
                subtitle: 'Switch to dark theme\n(Coming Soon)',
                value: false,
                onChanged: null,
              ),

              _buildAppearanceRow(
                icon: Icons.palette_outlined,
                title: 'Animations',
                subtitle: 'Enable smooth animations\nthroughout the app',
                value: _animationsEnabled,
                onChanged: (value) {
                  setState(() {
                    _animationsEnabled = value;
                  });
                },
                isLast: true,
              ),

              const SizedBox(height: 20),

              _buildLanguageCard(),

              const SizedBox(height: 20),

              _buildInteractionsCard(),

              const SizedBox(height: 20),

              _buildDataStorageCard(),

              const SizedBox(height: 20),

              _buildAppInfoCard(),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return SizedBox(
      height: 40,
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
            'App Settings',
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

  Widget _buildAppearanceHeader() {
    return Container(
      width: double.infinity,
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
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
      child: const Row(
        children: [
          Icon(Icons.palette_outlined, size: 20, color: Colors.white),

          SizedBox(width: 8),

          Text(
            'Appearance',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageOption({required String language}) {
    final bool isSelected = _selectedLanguage == language;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedLanguage = language;
          });
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: double.infinity,
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFFFFE4E6)
                : const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(8),
            border: isSelected
                ? Border.all(color: const Color(0xFFFF2056), width: 1)
                : null,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  language,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                    color: isSelected
                        ? const Color(0xFFC70036)
                        : const Color(0xFF1E2939),
                  ),
                ),
              ),

              if (isSelected)
                const Icon(Icons.check, size: 18, color: Color(0xFFC70036)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.90),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.10),
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.language, size: 20, color: Color(0xFF1E2939)),

              SizedBox(width: 8),

              Text(
                'Language',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1E2939),
                ),
              ),
            ],
          ),

          const SizedBox(height: 36),

          _buildLanguageOption(language: 'English'),

          const SizedBox(height: 8),

          _buildLanguageOption(language: 'Arabic'),

          const SizedBox(height: 8),

          _buildLanguageOption(language: 'French'),

          const SizedBox(height: 8),

          _buildLanguageOption(language: 'Spanish'),
        ],
      ),
    );
  }

  Widget _buildDataStorageCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.90),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.10),
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Data & Storage',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1E2939),
            ),
          ),

          const SizedBox(height: 36),

          Container(
            width: double.infinity,
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Cache Size',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF4A5565),
                    ),
                  ),
                ),
                Text(
                  _cacheSize,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1E2939),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            height: 40,
            child: OutlinedButton(
              onPressed: () {
                setState(() {
                  _cacheSize = '0 MB';
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Cache cleared successfully')),
                );
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF1E2939),
                side: BorderSide(
                  color: Colors.black.withValues(alpha: 0.10),
                  width: 0.5,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Clear Cache',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
          ),

          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            height: 40,
            child: OutlinedButton(
              onPressed: _showClearAppDataDialog,
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFE7000B),
                side: const BorderSide(color: Color(0xFFFFA2A2), width: 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Clear All App Data',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showClearAppDataDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Clear All App Data?'),
          content: const Text(
            'This will remove locally stored app data. '
            'This action will be connected fully later.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);

                ScaffoldMessenger.of(this.context).showSnackBar(
                  const SnackBar(
                    content: Text('Clear All App Data will be connected later'),
                  ),
                );
              },
              child: const Text(
                'Clear Data',
                style: TextStyle(color: Color(0xFFE7000B)),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAppInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.90),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.10),
          width: 0.5,
        ),
      ),
      child: const Column(
        children: [
          Text(
            'Rosewater Café',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Color(0xFF6A7282),
            ),
          ),

          SizedBox(height: 8),

          Text(
            'Version 1.0.0',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1E2939),
            ),
          ),

          SizedBox(height: 8),

          Text(
            'Build 2024.01.14',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: Color(0xFF94A3B8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInteractionRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    bool isLast = false,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: isLast
            ? const BorderRadius.only(
                bottomLeft: Radius.circular(14),
                bottomRight: Radius.circular(14),
              )
            : BorderRadius.zero,
        border: Border(
          top: BorderSide(
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
                    height: 1.4,
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

  Widget _buildAppearanceRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool>? onChanged,
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
          left: BorderSide(
            color: Colors.black.withValues(alpha: 0.06),
            width: 0.5,
          ),
          right: BorderSide(
            color: Colors.black.withValues(alpha: 0.06),
            width: 0.5,
          ),
          bottom: BorderSide(
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
                    height: 1.4,
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

  Widget _buildInteractionsCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.90),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.10),
          width: 0.5,
        ),
      ),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  Icons.phone_android_outlined,
                  size: 20,
                  color: Color(0xFF1E2939),
                ),

                SizedBox(width: 8),

                Text(
                  'Interactions',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1E2939),
                  ),
                ),
              ],
            ),
          ),

          _buildInteractionRow(
            icon: Icons.volume_up_outlined,
            title: 'Sound Effects',
            subtitle: 'Play sounds for actions\nand notifications',
            value: _soundEffectsEnabled,
            onChanged: (value) {
              setState(() {
                _soundEffectsEnabled = value;
              });
            },
          ),

          _buildInteractionRow(
            icon: Icons.phone_android_outlined,
            title: 'Haptic Feedback',
            subtitle: 'Vibrate on button presses\nand interactions',
            value: _hapticFeedbackEnabled,
            onChanged: (value) {
              setState(() {
                _hapticFeedbackEnabled = value;
              });
            },
            isLast: true,
          ),
        ],
      ),
    );
  }
}
