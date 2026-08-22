import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class DoorAccessScreen extends StatefulWidget {
  const DoorAccessScreen({
    super.key,
    required this.memberId,
    required this.membershipPlan,
  });

  final String memberId;
  final String membershipPlan;

  @override
  State<DoorAccessScreen> createState() => _DoorAccessScreenState();
}

class _DoorAccessScreenState extends State<DoorAccessScreen> {
  int _guestCount = 0;

  int get _maxGuests => widget.membershipPlan == 'Basic' ? 1 : 2;

  void _changeGuests(int amount) {
    final nextCount = _guestCount + amount;

    if (nextCount < 0 || nextCount > _maxGuests) return;

    setState(() {
      _guestCount = nextCount;
    });
  }

  @override
  Widget build(BuildContext context) {
    final qrData =
        'rosewater-demo|member:${widget.memberId}|plan:${widget.membershipPlan}|guests:$_guestCount';

    return Scaffold(
      backgroundColor: const Color(0xFFFFF7FB),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 36,
                child: TextButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, size: 18),
                  label: const Text(
                    'Back to Dashboard',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF0A0A0A),
                    padding: EdgeInsets.zero,
                    alignment: Alignment.centerLeft,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
                decoration: BoxDecoration(
                  color: const Color(0xE6FFFFFF),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x1A000000),
                      blurRadius: 18,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'Door Access',
                      style: TextStyle(
                        color: Color(0xFF1E2939),
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 28),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x1A000000),
                            blurRadius: 12,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: QrImageView(
                        data: qrData,
                        version: QrVersions.auto,
                        size: 220,
                        backgroundColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Scan this QR code at the entrance\nto unlock the door',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF4A5565),
                        fontSize: 16,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 44),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'How many people are with you?',
                        style: TextStyle(
                          color: Color(0xFF1E2939),
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'You can bring up to $_maxGuests guests with your ${widget.membershipPlan.toLowerCase()} membership',
                      style: const TextStyle(
                        color: Color(0xFF4A5565),
                        fontSize: 16,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _GuestButton(
                          icon: Icons.remove,
                          onPressed: _guestCount > 0
                              ? () => _changeGuests(-1)
                              : null,
                        ),
                        SizedBox(
                          width: 150,
                          height: 56,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.person_add_alt_1_outlined,
                                    color: Color(0xFF4A5565),
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '$_guestCount',
                                    style: const TextStyle(
                                      color: Color(0xFF1E2939),
                                      fontSize: 28,
                                      height: 1,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Guests',
                                style: TextStyle(
                                  color: Color(0xFF6A7282),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                        _GuestButton(
                          icon: Icons.add,
                          onPressed: _guestCount < _maxGuests
                              ? () => _changeGuests(1)
                              : null,
                        ),
                      ],
                    ),
                    const SizedBox(height: 36),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFBEB),
                        border: Border.all(
                          color: const Color(0xFFFEE685),
                          width: 0.52,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text.rich(
                        TextSpan(
                          style: TextStyle(
                            color: Color(0xFF9A4B00),
                            fontSize: 14,
                            height: 1.45,
                          ),
                          children: [
                            TextSpan(
                              text: 'Note: ',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                            TextSpan(
                              text:
                                  'Your monthly allowance covers your orders only. Guest orders will receive member discounts but are paid separately.',
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFF2056), Color(0xFF9810FA)],
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Door access prepared for $_guestCount guest(s)',
                                ),
                              ),
                            );
                          },
                          child: const Text(
                            'Open Door',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GuestButton extends StatelessWidget {
  const _GuestButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final isEnabled = onPressed != null;

    return SizedBox(
      width: 48,
      height: 48,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF0A0A0A),
          backgroundColor: Colors.white,
          side: BorderSide(
            color: Colors.black.withValues(alpha: isEnabled ? 0.10 : 0.05),
            width: 0.52,
          ),
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          icon == Icons.add ? '+' : '-',
          style: TextStyle(
            color: isEnabled
                ? const Color(0xFF0A0A0A)
                : const Color(0xFF0A0A0A).withValues(alpha: 0.50),
            fontSize: 14,
            height: 20 / 14,
            fontWeight: FontWeight.w500,
            letterSpacing: -0.15,
          ),
        ),
      ),
    );
  }
}
