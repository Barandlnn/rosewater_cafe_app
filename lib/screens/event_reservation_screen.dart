import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../services/event_service.dart';
import '../services/reservation_service.dart';
import 'reservation_confirmed_screen.dart';

class EventReservationScreen extends StatefulWidget {
  const EventReservationScreen({super.key});

  @override
  State<EventReservationScreen> createState() => _EventReservationScreenState();
}

class _EventReservationScreenState extends State<EventReservationScreen> {
  double _baseRate = 150;
  int _minGuests = 5;
  int _maxGuests = 100;

  String _currency = 'USD';

  String _eventDescription =
      'Book the café for your private event. Perfect for parties, meetings, and special occasions.';

  List<String> _packageIncludes = [
    'Exclusive use of the café',
    'Complimentary hookah for all guests',
    'Special event menu available',
    'Dedicated staff service',
    'Sound system and music control',
  ];

  bool _isEventActive = true;
  bool _isSubmitting = false;

  final TextEditingController _eventTypeController = TextEditingController();

  final TextEditingController _durationController = TextEditingController(
    text: '2',
  );

  final TextEditingController _guestController = TextEditingController(
    text: '10',
  );

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();

    _loadEvent();
  }

  Future<void> _loadEvent() async {
    final event = await EventService.getPrivateEvent();

    if (event == null || !mounted) {
      return;
    }

    final packageIncludes = event['packageIncludes'];

    setState(() {
      _baseRate = (event['baseRate'] as num?)?.toDouble() ?? _baseRate;

      _minGuests = (event['minGuests'] as num?)?.toInt() ?? _minGuests;

      _maxGuests = (event['maxGuests'] as num?)?.toInt() ?? _maxGuests;

      _currency = event['currency'] as String? ?? _currency;

      _eventDescription = event['description'] as String? ?? _eventDescription;

      _isEventActive = event['isActive'] as bool? ?? _isEventActive;

      if (packageIncludes is List) {
        _packageIncludes = packageIncludes.whereType<String>().toList();
      }
    });
  }

  int get _duration {
    return int.tryParse(_durationController.text) ?? 0;
  }

  int get _guestCount {
    return int.tryParse(_guestController.text) ?? 0;
  }

  double get _estimatedTotal {
    return _baseRate * _duration;
  }

  String get _currencySymbol {
    switch (_currency) {
      case 'EUR':
        return '€';

      case 'GBP':
        return '£';

      case 'TRY':
        return '₺';

      case 'USD':
      default:
        return '\$';
    }
  }

  String get _formattedDate {
    if (_selectedDate == null) {
      return '';
    }

    return '${_selectedDate!.month}/${_selectedDate!.day}/${_selectedDate!.year}';
  }

  String get _formattedTime {
    if (_selectedTime == null) {
      return '';
    }

    final hour = _selectedTime!.hour.toString().padLeft(2, '0');
    final minute = _selectedTime!.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
    );

    if (pickedDate == null || !mounted) {
      return;
    }

    setState(() {
      _selectedDate = pickedDate;
    });
  }

  Future<void> _pickTime() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime == null || !mounted) {
      return;
    }

    setState(() {
      _selectedTime = pickedTime;
    });
  }

  Future<void> _confirmReservation() async {
    if (_isSubmitting) {
      return;
    }

    if (!_isEventActive) {
      _showMessage('Event reservations are currently unavailable');
      return;
    }

    final eventType = _eventTypeController.text.trim();

    if (eventType.isEmpty) {
      _showMessage('Please enter an event type');
      return;
    }

    if (_selectedDate == null) {
      _showMessage('Please select an event date');
      return;
    }

    if (_selectedTime == null) {
      _showMessage('Please select a start time');
      return;
    }

    if (_duration <= 0) {
      _showMessage('Please enter a valid duration');
      return;
    }

    if (_guestCount < _minGuests || _guestCount > _maxGuests) {
      _showMessage('Guest count must be between $_minGuests and $_maxGuests');
      return;
    }

    final user = AuthService.currentUser;

    if (user == null) {
      _showMessage('You must be signed in to make a reservation');
      return;
    }

    final eventDateTime = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );

    if (!eventDateTime.isAfter(DateTime.now())) {
      _showMessage('Please select a future date and time');
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final reservationId = await ReservationService.createReservation(
        uid: user.uid,
        eventType: eventType,
        eventDateTime: eventDateTime,
        duration: _duration,
        guestCount: _guestCount,
        baseRate: _baseRate,
        estimatedTotal: _estimatedTotal,
        currency: _currency,
      );
      if (!mounted) {
        return;
      }

      setState(() {
        _isSubmitting = false;
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ReservationConfirmedScreen(reservationId: reservationId),
        ),
      );
    } on FirebaseException catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isSubmitting = false;
      });

      _showMessage('Reservation could not be created (${error.code}).');
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isSubmitting = false;
      });

      _showMessage('Reservation could not be created. Please try again.');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    _eventTypeController.dispose();
    _durationController.dispose();
    _guestController.dispose();

    super.dispose();
  }

  Widget _buildTextField({
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    ValueChanged<String>? onChanged,
  }) {
    return SizedBox(
      height: 34,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        onChanged: onChanged,
        style: const TextStyle(color: Color(0xFF101828), fontSize: 14),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFD1D5DC), width: 0.52),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF9810FA), width: 1),
          ),
        ),
      ),
    );
  }

  Widget _buildPickerField({
    required VoidCallback onTap,
    required String value,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: double.infinity,
        height: 34,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: const Color(0xFFF3F3F5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          value,
          style: const TextStyle(color: Color(0xFF101828), fontSize: 14),
        ),
      ),
    );
  }

  Widget _buildFieldLabel({required String text, IconData? icon}) {
    return Row(
      children: [
        if (icon != null) ...[
          Icon(icon, size: 16, color: const Color(0xFF0A0A0A)),
          const SizedBox(width: 10),
        ],
        Text(
          text,
          style: const TextStyle(
            color: Color(0xFF0A0A0A),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildPackageCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF5FF),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE9D4FF), width: 0.52),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Event Package Includes:',
            style: TextStyle(
              color: Color(0xFF6E11B0),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _packageIncludes.map((item) => '• $item').join('\n'),
            style: const TextStyle(
              color: Color(0xFF5916B8),
              fontSize: 14,
              height: 1.45,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceSummary() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          _buildPriceRow(
            'Base rate (per hour)',
            '$_currencySymbol${_baseRate.toStringAsFixed(0)}',
          ),
          const SizedBox(height: 8),
          _buildPriceRow(
            'Duration',
            '$_duration ${_duration == 1 ? 'hour' : 'hours'}',
          ),
          const Divider(height: 16, color: Color(0xFFE5E7EB)),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Estimated Total',
                  style: TextStyle(
                    color: Color(0xFF101828),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Text(
                '$_currencySymbol${_estimatedTotal.toStringAsFixed(0)}',
                style: const TextStyle(
                  color: Color(0xFF101828),
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String value) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(color: Color(0xFF4A5565), fontSize: 16),
          ),
        ),
        Text(
          value,
          style: const TextStyle(color: Color(0xFF101828), fontSize: 16),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
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
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Reserve an Event',
                      style: TextStyle(
                        color: Color(0xFF1E2939),
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 48),
                    Text(
                      _eventDescription,
                      style: const TextStyle(
                        color: Color(0xFF4A5565),
                        fontSize: 16,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 48),
                    _buildFieldLabel(text: 'Event Type'),
                    const SizedBox(height: 4),
                    _buildTextField(controller: _eventTypeController),
                    const SizedBox(height: 16),
                    _buildFieldLabel(
                      text: 'Event Date *',
                      icon: Icons.calendar_today_outlined,
                    ),
                    const SizedBox(height: 4),
                    _buildPickerField(onTap: _pickDate, value: _formattedDate),
                    const SizedBox(height: 16),
                    _buildFieldLabel(
                      text: 'Start Time *',
                      icon: Icons.schedule_outlined,
                    ),
                    const SizedBox(height: 4),
                    _buildPickerField(onTap: _pickTime, value: _formattedTime),
                    const SizedBox(height: 16),
                    _buildFieldLabel(text: 'Duration (hours)'),
                    const SizedBox(height: 4),
                    _buildTextField(
                      controller: _durationController,
                      keyboardType: TextInputType.number,
                      onChanged: (_) {
                        setState(() {});
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildFieldLabel(
                      text: 'Number of Guests *',
                      icon: Icons.people_outline,
                    ),
                    const SizedBox(height: 4),
                    SizedBox(
                      height: 34,
                      child: TextField(
                        controller: _guestController,
                        keyboardType: TextInputType.number,
                        onChanged: (_) {
                          setState(() {});
                        },
                        style: const TextStyle(
                          color: Color(0xFF6A7282),
                          fontSize: 14,
                        ),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF3F3F5),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Minimum $_minGuests guests, maximum $_maxGuests guests',
                      style: const TextStyle(
                        color: Color(0xFF6A7282),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildPackageCard(),
                    const SizedBox(height: 24),
                    _buildPriceSummary(),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
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
                          onPressed: _isSubmitting ? null : _confirmReservation,
                          child: Text(
                            _isSubmitting
                                ? 'Creating Reservation...'
                                : 'Confirm Reservation',
                            style: const TextStyle(
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
