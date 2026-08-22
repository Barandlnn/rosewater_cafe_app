import 'package:flutter/material.dart';

class ReservationConfirmedScreen extends StatelessWidget {
  const ReservationConfirmedScreen({
    super.key,
    required this.date,
    required this.time,
    required this.duration,
    required this.guestCount,
  });

  final DateTime date;
  final TimeOfDay time;
  final int duration;
  final int guestCount;

  String get _formattedDate {
    return '${date.month}/${date.day}/${date.year}';
  }

  String get _formattedTime {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7FB),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          child: Column(
            children: [
              // Success notification
              Container(
                width: double.infinity,
                height: 53,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.black.withValues(alpha: 0.10),
                    width: 0.52,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x14000000),
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Color(0xFF0A0A0A),
                      size: 18,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Event reservation confirmed!',
                      style: TextStyle(
                        color: Color(0xFF0A0A0A),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Main confirmation card
              Container(
                width: double.infinity,
                height: 649,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.90),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Colors.black.withValues(alpha: 0.10),
                    width: 0.52,
                  ),
                ),
                child: Column(
                  children: [
                    // Green success circle
                    Container(
                      width: 96,
                      height: 96,
                      decoration: const BoxDecoration(
                        color: Color(0xFFDCFCE7),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Color(0xFF00A63E),
                        size: 44,
                      ),
                    ),

                    const SizedBox(height: 48),

                    // Title
                    const SizedBox(
                      width: double.infinity,
                      height: 72,
                      child: Center(
                        child: Text(
                          'Reservation\nConfirmed!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF1E2939),
                            fontSize: 28,
                            height: 1.05,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Description
                    const SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: Center(
                        child: Text(
                          'Your event has been\nsuccessfully reserved',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF4A5565),
                            fontSize: 16,
                            height: 1.4,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 48),

                    // Reservation details
                    Container(
                      width: double.infinity,
                      height: 152,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildDetailRow(
                            label: 'Date:',
                            value: _formattedDate,
                          ),
                          _buildDetailRow(
                            label: 'Time:',
                            value: _formattedTime,
                          ),
                          _buildDetailRow(
                            label: 'Duration:',
                            value:
                                '$duration ${duration == 1 ? 'hour' : 'hours'}',
                          ),
                          _buildDetailRow(
                            label: 'Guests:',
                            value:
                                '$guestCount ${guestCount == 1 ? 'person' : 'people'}',
                          ),
                        ],
                      ),
                    ),

                    const Spacer(),

                    // Back to Dashboard
                    SizedBox(
                      width: double.infinity,
                      height: 36,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [Color(0xFFFF2056), Color(0xFF9810FA)],
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Back to Dashboard',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
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

  Widget _buildDetailRow({required String label, required String value}) {
    return SizedBox(
      width: double.infinity,
      height: 24,
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFF4A5565),
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF101828),
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
