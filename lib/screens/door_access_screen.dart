import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../services/auth_service.dart';
import '../services/door_access_service.dart';

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

  String? _accessRequestId;
  DateTime? _accessExpiresAt;

  bool _isCreatingAccessRequest = false;
  String? _accessError;

  Timer? _expiryTimer;
  int _remainingSeconds = 0;

  int get _maxGuests {
    return widget.membershipPlan == 'Basic' ? 1 : 2;
  }

  bool get _hasActiveAccessRequest {
    return _accessRequestId != null && _remainingSeconds > 0;
  }

  String get _formattedRemainingTime {
    final minutes = _remainingSeconds ~/ 60;
    final seconds = _remainingSeconds % 60;

    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  void _changeGuests(int amount) {
    if (_hasActiveAccessRequest || _isCreatingAccessRequest) {
      return;
    }

    final nextCount = _guestCount + amount;

    if (nextCount < 0 || nextCount > _maxGuests) {
      return;
    }

    setState(() {
      _guestCount = nextCount;
    });
  }

  void _startExpiryTimer() {
    _expiryTimer?.cancel();

    _updateRemainingTime();

    _expiryTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateRemainingTime();
    });
  }

  void _updateRemainingTime() {
    final expiresAt = _accessExpiresAt;

    if (expiresAt == null || !mounted) {
      return;
    }

    final remainingSeconds = expiresAt.difference(DateTime.now()).inSeconds;

    if (remainingSeconds <= 0) {
      _expiryTimer?.cancel();

      setState(() {
        _remainingSeconds = 0;
        _accessRequestId = null;
        _accessExpiresAt = null;
      });

      return;
    }

    setState(() {
      _remainingSeconds = remainingSeconds;
    });
  }

  Future<void> _createAccessRequest() async {
    final user = AuthService.currentUser;

    if (user == null) {
      setState(() {
        _accessError = 'You must be signed in to prepare door access.';
      });

      return;
    }

    if (_isCreatingAccessRequest || _hasActiveAccessRequest) {
      return;
    }

    setState(() {
      _isCreatingAccessRequest = true;
      _accessError = null;
    });

    try {
      final accessRequest = await DoorAccessService.createAccessRequest(
        uid: user.uid,
        memberId: widget.memberId,
        membershipPlan: widget.membershipPlan,
        guestCount: _guestCount,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _accessRequestId = accessRequest.id;
        _accessExpiresAt = accessRequest.expiresAt;
        _isCreatingAccessRequest = false;
        _accessError = null;
      });

      _startExpiryTimer();
    } on FirebaseException catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isCreatingAccessRequest = false;
        _accessError = 'Door access could not be prepared (${error.code}).';
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isCreatingAccessRequest = false;
        _accessError = 'Door access could not be prepared.';
      });
    }
  }

  @override
  void dispose() {
    _expiryTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String? qrData = _hasActiveAccessRequest
        ? 'rosewater-access:$_accessRequestId'
        : null;

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
                      child: qrData == null
                          ? const SizedBox(
                              width: 220,
                              height: 220,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.qr_code_2,
                                    size: 72,
                                    color: Color(0xFF9CA3AF),
                                  ),
                                  SizedBox(height: 12),
                                  Text(
                                    'Prepare door access\n'
                                    'to generate your QR code',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xFF6A7282),
                                      fontSize: 14,
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : QrImageView(
                              data: qrData,
                              version: QrVersions.auto,
                              size: 220,
                              backgroundColor: Colors.white,
                            ),
                    ),

                    if (_hasActiveAccessRequest) ...[
                      const SizedBox(height: 12),
                      Text(
                        'QR expires in $_formattedRemainingTime',
                        style: const TextStyle(
                          color: Color(0xFF6A7282),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],

                    const SizedBox(height: 24),

                    const Text(
                      'Scan this QR code at the entrance\n'
                      'to unlock the door',
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
                      'You can bring up to $_maxGuests guests with your '
                      '${widget.membershipPlan.toLowerCase()} membership',
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
                          onPressed:
                              _guestCount > 0 &&
                                  !_hasActiveAccessRequest &&
                                  !_isCreatingAccessRequest
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
                          onPressed:
                              _guestCount < _maxGuests &&
                                  !_hasActiveAccessRequest &&
                                  !_isCreatingAccessRequest
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
                                  'Your monthly allowance covers your orders '
                                  'only. Guest orders will receive member '
                                  'discounts but are paid separately.',
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
                          onPressed:
                              _isCreatingAccessRequest ||
                                  _hasActiveAccessRequest
                              ? null
                              : _createAccessRequest,
                          child: Text(
                            _isCreatingAccessRequest
                                ? 'Preparing...'
                                : _hasActiveAccessRequest
                                ? 'Door Access Active'
                                : 'Prepare Door Access',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),

                    if (_accessError != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        _accessError!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFFB42318),
                          fontSize: 13,
                        ),
                      ),
                    ],
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
