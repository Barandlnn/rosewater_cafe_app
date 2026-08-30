import 'package:flutter/material.dart';
import 'door_access_screen.dart';
import 'event_reservation_screen.dart';
import 'member_dashboard_screen.dart';
import 'edit_profile_screen.dart';
import 'payment_methods_screen.dart';
import 'notification_settings_screen.dart';
import 'privacy_security_screen.dart';
import 'help_support_screen.dart';
import 'app_settings_screen.dart';
import '../services/auth_service.dart';
import 'auth_gate.dart';
import '../services/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/membership_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _memberName = 'Demo User';
  String _email = '1@gmail.com';
  String _phone = '+1 (555) 123-4567';
  String _memberId = '-';
  String _membershipPlan = '-';
  String _validUntil = '-';
  int _maxGuests = 0;

  @override
  void initState() {
    super.initState();

    _loadUserProfile();
    _loadMembership();
  }

  Future<void> _loadUserProfile() async {
    final user = AuthService.currentUser;

    if (user == null) {
      return;
    }
    final profile = await UserService.getUserProfile(uid: user.uid);

    if (profile == null) {
      return;
    }
    if (!mounted) {
      return;
    }
    setState(() {
      _memberName = profile['fullName'] as String? ?? _memberName;
      _email = profile['email'] as String? ?? _email;
      _phone = profile['phone'] as String? ?? _phone;
    });
  }

  Future<void> _loadMembership() async {
    final user = AuthService.currentUser;

    if (user == null) {
      return;
    }

    final membership = await MembershipService.getMembership(uid: user.uid);

    if (membership == null) {
      return;
    }

    final validUntilTimestamp = membership['validUntil'] as Timestamp?;

    String formattedValidUntil = '-';

    if (validUntilTimestamp != null) {
      final date = validUntilTimestamp.toDate();

      formattedValidUntil = '${date.month}/${date.day}/${date.year}';
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _memberId = membership['memberId'] as String? ?? _memberId;

      _membershipPlan = membership['plan'] as String? ?? _membershipPlan;

      _maxGuests = membership['maxGuests'] as int? ?? _maxGuests;

      _validUntil = formattedValidUntil;
    });
  }

  // ------------------------------------------------------------
  // GENERAL HELPERS
  // ------------------------------------------------------------

  void _showComingSoon(String featureName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$featureName will be connected later')),
    );
  }

  Future<void> _signOut() async {
    try {
      await AuthService.signOut();

      if (!mounted) {
        return;
      }

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const AuthGate()),
        (route) => false,
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sign out failed. Please try again.')),
      );
    }
  }

  // ------------------------------------------------------------
  // BOTTOM NAVIGATION
  // ------------------------------------------------------------

  void _onBottomNavigationTap(int index) {
    // Zaten Profile ekranındayız.
    if (index == 3) {
      return;
    }

    Widget destination;

    switch (index) {
      case 0:
        destination = MemberDashboardScreen();
        break;

      case 1:
        destination = DoorAccessScreen(
          memberId: _memberId,
          membershipPlan: _membershipPlan,
        );
        break;

      case 2:
        destination = EventReservationScreen();
        break;

      default:
        return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => destination),
    );
  }

  // ------------------------------------------------------------
  // MAIN BUILD
  // ------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7FB),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Profile',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1E2939),
                  height: 1.2,
                ),
              ),

              const SizedBox(height: 24),

              _buildProfileCard(),

              const SizedBox(height: 16),

              _buildEditProfileButton(),

              const SizedBox(height: 24),

              _buildMembershipDetailsCard(),

              const SizedBox(height: 20),

              _buildSettingsCard(),

              const SizedBox(height: 20),

              _buildSignOutButton(),

              const SizedBox(height: 16),

              const Center(
                child: Text(
                  'Version 1.0.0 • Rosewater Café',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF6A7282),
                  ),
                ),
              ),

              const SizedBox(height: 8),
            ],
          ),
        ),
      ),

      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // ------------------------------------------------------------
  // PROFILE CARD
  // ------------------------------------------------------------

  Widget _buildProfileCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0x1A000000), width: 0.5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 12,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildAvatar(),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _memberName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1E2939),
                      ),
                    ),

                    const SizedBox(height: 8),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFB84DFF), Color(0xFF9810FA)],
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${_membershipPlan.toUpperCase()} Member',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 48),

          _buildInfoRow(icon: Icons.mail_outline, text: _email),

          const SizedBox(height: 12),

          _buildInfoRow(icon: Icons.phone_outlined, text: _phone),

          const SizedBox(height: 12),

          _buildInfoRow(
            icon: Icons.credit_card_outlined,
            text: 'Member ID: $_memberId',
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // EDIT PROFILE
  // ------------------------------------------------------------

  Widget _buildEditProfileButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton.icon(
        onPressed: () async {
          final updatedProfile = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditProfileScreen(
                initialName: _memberName,
                initialEmail: _email,
                initialPhone: _phone,
                memberId: _memberId,
                membershipPlan: _membershipPlan,
              ),
            ),
          );
          if (updatedProfile == null) {
            return;
          }
          if (!mounted) {
            return;
          }

          setState(() {
            _memberName = updatedProfile['name'];
            _email = updatedProfile['email'];
            _phone = updatedProfile['phone'];
          });
        },
        icon: const Icon(Icons.person_outline, size: 18),
        label: const Text(
          'Edit Profile',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF101828),
          backgroundColor: Colors.white,
          side: const BorderSide(color: Color(0xFFD1D5DC), width: 1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // MEMBERSHIP DETAILS
  // ------------------------------------------------------------

  Widget _buildMembershipDetailsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0x1A000000), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Membership Details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Color(0xFF101828),
            ),
          ),

          const SizedBox(height: 24),

          _buildMembershipDetailRow(label: 'Plan', value: _membershipPlan),

          const SizedBox(height: 12),

          _buildMembershipDetailRow(label: 'Valid Until', value: _validUntil),

          const SizedBox(height: 12),

          _buildMembershipDetailRow(
            label: 'Max Guests',
            value: _maxGuests.toString(),
          ),

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            height: 36,
            child: OutlinedButton(
              onPressed: () {
                _showComingSoon('Upgrade Membership');
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFFF2056),
                backgroundColor: Colors.white,
                side: const BorderSide(color: Color(0xFFFFA2AD), width: 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Upgrade Membership',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMembershipDetailRow({
    required String label,
    required String value,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFF4A5565),
            ),
          ),

          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF101828),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // SETTINGS
  // ------------------------------------------------------------

  Widget _buildSettingsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xE6FFFFFF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0x1A000000), width: 0.52),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Settings',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Color(0xFF101828),
            ),
          ),

          const SizedBox(height: 20),

          _buildSettingsTile(
            icon: Icons.credit_card_outlined,
            title: 'Payment Methods',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PaymentMethodsScreen(),
                ),
              );
            },
          ),

          const SizedBox(height: 8),

          _buildSettingsTile(
            icon: Icons.notifications_outlined,
            title: 'Notifications',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationSettingsScreen(),
                ),
              );
            },
          ),

          _buildSettingsTile(
            icon: Icons.shield_outlined,
            title: 'Privacy & Security',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PrivacySecurityScreen(),
                ),
              );
            },
          ),
          _buildSettingsTile(
            icon: Icons.help_outline,
            title: 'Help & Support',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HelpSupportScreen(),
                ),
              );
            },
          ),
          _buildSettingsTile(
            icon: Icons.settings_outlined,
            title: 'App Settings',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AppSettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Icon(icon, size: 20, color: const Color(0xFF4A5565)),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xFF1E2939),
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          size: 20,
          color: Color(0xFF94A3B8),
        ),
        onTap: onTap,
      ),
    );
  }

  // ------------------------------------------------------------
  // SIGN OUT
  // ------------------------------------------------------------

  Widget _buildSignOutButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton.icon(
        onPressed: _signOut,
        icon: const Icon(Icons.logout, size: 18),
        label: const Text(
          'Sign Out',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFFEC003F),
          backgroundColor: Colors.white,
          side: const BorderSide(color: Color(0xFFFFA2A2), width: 1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // BOTTOM NAVIGATION BAR
  // ------------------------------------------------------------

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: 3,

      type: BottomNavigationBarType.fixed,

      backgroundColor: Colors.white,

      selectedItemColor: const Color(0xFFFF2056),

      unselectedItemColor: const Color(0xFF6A7282),

      selectedFontSize: 12,

      unselectedFontSize: 12,

      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),

      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w400),

      showSelectedLabels: true,

      showUnselectedLabels: true,

      elevation: 12,

      onTap: _onBottomNavigationTap,

      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Home',
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.qr_code),
          activeIcon: Icon(Icons.qr_code),
          label: 'QR Code',
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today_outlined),
          activeIcon: Icon(Icons.calendar_today),
          label: 'Events',
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // AVATAR
  // ------------------------------------------------------------

  Widget _buildAvatar() {
    return Container(
      width: 80,
      height: 80,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFB95CFF), Color(0xFF9810FA)],
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x30000000),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: const Icon(Icons.person_outline, size: 45, color: Colors.white),
    );
  }

  // ------------------------------------------------------------
  // PROFILE INFO ROW
  // ------------------------------------------------------------

  Widget _buildInfoRow({required IconData icon, required String text}) {
    return Row(
      children: [
        Icon(icon, size: 20, color: const Color(0xFF4A5565)),

        const SizedBox(width: 12),

        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              height: 1.3,
              color: Color(0xFF4A5565),
            ),
          ),
        ),
      ],
    );
  }
}
