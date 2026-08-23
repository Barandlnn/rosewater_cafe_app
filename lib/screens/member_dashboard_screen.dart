import 'package:flutter/material.dart';
import 'door_access_screen.dart';
import 'event_reservation_screen.dart';
import 'notifications_screen.dart';
import '../services/notification_store.dart';
import 'profile_screen.dart';

class MemberDashboardScreen extends StatefulWidget {
  final DateTime registrationDate;

  MemberDashboardScreen({super.key, DateTime? registrationDate})
    : registrationDate = registrationDate ?? DateTime.now();

  @override
  State<MemberDashboardScreen> createState() => _MemberDashboardScreenState();
}

class _MemberDashboardScreenState extends State<MemberDashboardScreen> {
  final String _memberName = 'Demo';
  final String _memberId = '1768390004573';
  final String _membershipPlan = 'Premium';
  int get _notificationCount => NotificationStore.unreadCount;

  DateTime get _validUntilDate {
    return DateTime(
      widget.registrationDate.year + 1,
      widget.registrationDate.month,
      widget.registrationDate.day,
    );
  }

  String get _validUntil {
    final date = _validUntilDate;

    return '${date.month}/${date.day}/${date.year}';
  }

  // Hookah Sessions ve Drinks kartları için ortak yapı.
  Widget _buildAllowanceCard({
    required String title,
    required int remaining,
    required int total,
    required IconData icon,
    required Color iconColor,
    required Color iconBackgroundColor,
  }) {
    final int used = total - remaining;

    final double remainingRatio = total == 0
        ? 0
        : (remaining / total).clamp(0.0, 1.0).toDouble();

    return Container(
      width: double.infinity,
      height: 197,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.90),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.10),
          width: 0.52,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Icon + title + allowance
          SizedBox(
            width: double.infinity,
            height: 52,
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: iconBackgroundColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: iconColor, size: 22),
                ),
                const SizedBox(width: 12),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Color(0xFF4A5565),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      '$remaining / $total',
                      style: const TextStyle(
                        color: Color(0xFF1E2939),
                        fontSize: 22,
                        height: 1,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: SizedBox(
              width: double.infinity,
              height: 8,
              child: Stack(
                children: [
                  Container(
                    color: const Color(0xFF030213).withValues(alpha: 0.20),
                  ),
                  FractionallySizedBox(
                    widthFactor: remainingRatio,
                    child: Container(color: const Color(0xFF030213)),
                  ),
                ],
              ),
            ),
          ),

          // Monthly usage
          Text(
            '$used used this\nmonth',
            style: const TextStyle(
              color: Color(0xFF6A7282),
              fontSize: 12,
              height: 1.15,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  // Service Hours içerisindeki iki saat satırı için ortak yapı.
  Widget _buildServiceHourRow({required String title, required String time}) {
    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Color(0xFF364153),
                fontSize: 16,
                height: 1.4,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Expanded(
            child: Text(
              time,
              style: const TextStyle(
                color: Color(0xFF101828),
                fontSize: 16,
                height: 1.4,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Service Hours kartının tamamı.
  Widget _buildServiceHoursCard() {
    final int currentHour = DateTime.now().hour;

    // 09:00 - 23:00 arasında full service.
    final bool isFullService = currentHour >= 9 && currentHour < 23;

    final String currentStatus = isFullService
        ? 'Full service available'
        : 'Self-service available';

    return Container(
      width: double.infinity,
      height: 366,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.90),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.10),
          width: 0.52,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Service Hours başlığı
          const Row(
            children: [
              Icon(Icons.schedule_outlined, color: Color(0xFF4A5565), size: 24),
              SizedBox(width: 12),
              Text(
                'Service Hours',
                style: TextStyle(
                  color: Color(0xFF1E2939),
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          // Full Service + Self-Service
          SizedBox(
            width: double.infinity,
            height: 156,
            child: Column(
              children: [
                _buildServiceHourRow(
                  title: 'Full Service\nHours',
                  time: '9:00 AM - 11:00\nPM',
                ),
                const SizedBox(height: 12),
                _buildServiceHourRow(
                  title: 'Self-Service\nHours',
                  time: '11:00 PM - 9:00\nAM',
                ),
              ],
            ),
          ),

          // Current Status
          Container(
            width: double.infinity,
            height: 53,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDF4),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFB9F8CF), width: 0.52),
            ),
            child: Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: 'Current Status: ',
                    style: TextStyle(
                      color: Color(0xFF016630),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(
                    text: currentStatus,
                    style: const TextStyle(
                      color: Color(0xFF016630),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMembershipBenefitsCard() {
    return Container(
      width: double.infinity,
      height: 241,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.90),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.10),
          width: 0.52,
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: double.infinity,
            height: 28,
            child: Text(
              'Membership Benefits',
              style: TextStyle(
                color: Color(0xFF1E2939),
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          SizedBox(
            width: double.infinity,
            height: 124,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '• Bring up to 2 guests with you',
                  style: TextStyle(
                    color: Color(0xFF4A5565),
                    fontSize: 14,
                    height: 1.2,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '• Member-exclusive discounts on guest orders',
                  style: TextStyle(
                    color: Color(0xFF4A5565),
                    fontSize: 14,
                    height: 1.2,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '• Priority event reservations',
                  style: TextStyle(
                    color: Color(0xFF4A5565),
                    fontSize: 14,
                    height: 1.2,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '• QR code door access',
                  style: TextStyle(
                    color: Color(0xFF4A5565),
                    fontSize: 14,
                    height: 1.2,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavItem({
    required IconData icon,
    required String label,
    required bool isActive,
    required double width,
    required VoidCallback onTap,
  }) {
    final Color color = isActive
        ? const Color(0xFFEC003F)
        : const Color(0xFF6A7282);

    return SizedBox(
      width: width,
      height: 60,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 24),
              SizedBox(height: isActive ? 8 : 4),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: isActive ? FontWeight.w500 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F9),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: 136,
                child: Stack(
                  children: [
                    Positioned(
                      top: 10,
                      left: 0,
                      right: 154,
                      child: Text(
                        'Welcome,\n$_memberName!',
                        style: const TextStyle(
                          color: Color(0xFF1E2939),
                          fontSize: 36,
                          height: 1.1,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.37,
                        ),
                      ),
                    ),

                    Positioned(
                      top: 90,
                      left: 0,
                      child: Text(
                        'Member ID:\n$_memberId',
                        style: const TextStyle(
                          color: Color(0xFF4A5565),
                          fontSize: 16,
                          height: 1.5,
                          fontWeight: FontWeight.w400,
                          letterSpacing: -0.15,
                        ),
                      ),
                    ),

                    Positioned(
                      top: 10,
                      right: 0,
                      child: SizedBox(
                        width: 150,
                        height: 36,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(18),
                                onTap: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const NotificationsScreen(),
                                    ),
                                  );

                                  if (!mounted) return;

                                  setState(() {});
                                },
                                child: SizedBox(
                                  width: 40,
                                  height: 36,
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      const Center(
                                        child: Icon(
                                          Icons.notifications_none_outlined,
                                          color: Color(0xFF4A5565),
                                          size: 20,
                                        ),
                                      ),
                                      if (_notificationCount > 0)
                                        Positioned(
                                          top: -4,
                                          right: 0,
                                          child: Container(
                                            width: 20,
                                            height: 20,
                                            alignment: Alignment.center,
                                            decoration: const BoxDecoration(
                                              color: Color(0xFFEC003F),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Text(
                                              '$_notificationCount',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(width: 8),

                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(8),
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Logout will be connected with Firebase later',
                                      ),
                                    ),
                                  );
                                },
                                child: const SizedBox(
                                  width: 102,
                                  height: 36,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Icon(
                                        Icons.logout_outlined,
                                        color: Color(0xFF4A5565),
                                        size: 18,
                                      ),
                                      SizedBox(width: 6),
                                      Text(
                                        'Logout',
                                        style: TextStyle(
                                          color: Color(0xFF4A5565),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: -0.15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Membership Status
              SizedBox(
                width: double.infinity,
                height: 169,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Color(0xFFC27AFF), Color(0xFF9810FA)],
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x40000000),
                        blurRadius: 18,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 60,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Membership Status',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '$_membershipPlan Member',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 28,
                                      height: 1,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.18),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.55),
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Text(
                                'Active',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Spacer(),

                      Text(
                        'Valid until: $_validUntil',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // Access Café button
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DoorAccessScreen(
                          memberId: _memberId,
                          membershipPlan: _membershipPlan,
                        ),
                      ),
                    );
                  },
                  child: Ink(
                    width: double.infinity,
                    height: 96,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [Color(0xFFFF2056), Color(0xFF9810FA)],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.qr_code_2, color: Colors.white, size: 18),
                        SizedBox(height: 6),
                        Text(
                          'Access Café',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Reserve Event button
              Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EventReservationScreen(),
                      ),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    height: 76,
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          color: Color(0xFFFF174F),
                          size: 18,
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Reserve Event',
                          style: TextStyle(
                            color: Color(0xFF1E2939),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Hookah Sessions
              _buildAllowanceCard(
                title: 'Hookah Sessions',
                remaining: 15,
                total: 20,
                icon: Icons.smoking_rooms_outlined,
                iconColor: const Color(0xFFF54900),
                iconBackgroundColor: const Color(0xFFFFEDD4),
              ),

              const SizedBox(height: 24),

              // Drinks
              _buildAllowanceCard(
                title: 'Drinks',
                remaining: 18,
                total: 20,
                icon: Icons.local_cafe_outlined,
                iconColor: const Color(0xFF155DFC),
                iconBackgroundColor: const Color(0xFFDBEAFE),
              ),

              const SizedBox(height: 24),

              // Service Hours
              _buildServiceHoursCard(),

              const SizedBox(height: 24),

              // Membership Benefits
              _buildMembershipBenefitsCard(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          height: 81,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Color(0x18000000),
                blurRadius: 20,
                offset: Offset(0, -4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Home
              _buildBottomNavItem(
                icon: Icons.home_outlined,
                label: 'Home',
                isActive: true,
                width: 67,
                onTap: () {
                  // Zaten Home ekranındayız.
                },
              ),

              // QR Code
              _buildBottomNavItem(
                icon: Icons.qr_code_2,
                label: 'QR Code',
                isActive: false,
                width: 82,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DoorAccessScreen(
                        memberId: _memberId,
                        membershipPlan: _membershipPlan,
                      ),
                    ),
                  );
                },
              ),

              // Events
              _buildBottomNavItem(
                icon: Icons.calendar_today_outlined,
                label: 'Events',
                isActive: false,
                width: 70,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Events screen will be connected next'),
                    ),
                  );
                },
              ),

              // Profile
              _buildBottomNavItem(
                icon: Icons.person_outline,
                label: 'Profile',
                isActive: false,
                width: 68,
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfileScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
