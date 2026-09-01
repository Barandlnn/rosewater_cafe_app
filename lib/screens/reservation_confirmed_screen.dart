import 'package:flutter/material.dart';

import '../services/reservation_service.dart';

class ReservationConfirmedScreen extends StatefulWidget {
  const ReservationConfirmedScreen({super.key, required this.reservationId});

  final String reservationId;

  @override
  State<ReservationConfirmedScreen> createState() =>
      _ReservationConfirmedScreenState();
}

class _ReservationConfirmedScreenState
    extends State<ReservationConfirmedScreen> {
  DateTime? _eventDateTime;

  int _duration = 0;
  int _guestCount = 0;

  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    _loadReservation();
  }

  Future<void> _loadReservation() async {
    try {
      final reservation = await ReservationService.getReservationById(
        reservationId: widget.reservationId,
      );

      if (!mounted) {
        return;
      }

      if (reservation == null) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Reservation could not be found.';
        });

        return;
      }

      if (reservation.eventDateTime == null) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Reservation data is invalid.';
        });

        return;
      }

      setState(() {
        _eventDateTime = reservation.eventDateTime;
        _duration = reservation.duration;
        _guestCount = reservation.guestCount;

        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
        _errorMessage = 'Reservation details could not be loaded.';
      });
    }
  }

  String get _formattedDate {
    final date = _eventDateTime;

    if (date == null) {
      return '-';
    }

    return '${date.month}/${date.day}/${date.year}';
  }

  String get _formattedTime {
    final date = _eventDateTime;

    if (date == null) {
      return '-';
    }

    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7FB),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage != null
            ? _buildErrorState()
            : _buildConfirmationContent(),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Color(0xFFB42318)),
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF1E2939), fontSize: 16),
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Back to Dashboard'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmationContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      child: Column(
        children: [
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
                Icon(Icons.check_circle, color: Color(0xFF0A0A0A), size: 18),
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
                      _buildDetailRow(label: 'Date:', value: _formattedDate),
                      _buildDetailRow(label: 'Time:', value: _formattedTime),
                      _buildDetailRow(
                        label: 'Duration:',
                        value:
                            '$_duration ${_duration == 1 ? 'hour' : 'hours'}',
                      ),
                      _buildDetailRow(
                        label: 'Guests:',
                        value:
                            '$_guestCount ${_guestCount == 1 ? 'person' : 'people'}',
                      ),
                    ],
                  ),
                ),

                const Spacer(),

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
