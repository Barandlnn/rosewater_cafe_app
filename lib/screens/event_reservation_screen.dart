import 'package:flutter/material.dart';
import 'reservation_confirmed_screen.dart';

class EventReservationScreen extends StatefulWidget {
  const EventReservationScreen({super.key});

  @override
  State<EventReservationScreen> createState() => _EventReservationScreenState();
}

class _EventReservationScreenState extends State<EventReservationScreen> {
  static const double _baseRate = 150;

  final TextEditingController _eventTypeController = TextEditingController();

  final TextEditingController _durationController = TextEditingController(
    text: '2',
  );

  final TextEditingController _guestController = TextEditingController(
    text: '10',
  );

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  int get _duration {
    return int.tryParse(_durationController.text) ?? 0;
  }

  int get _guestCount {
    return int.tryParse(_guestController.text) ?? 0;
  }

  double get _estimatedTotal {
    return _baseRate * _duration;
  }

  String get _formattedDate {
    if (_selectedDate == null) return '';

    return '${_selectedDate!.month}/${_selectedDate!.day}/${_selectedDate!.year}';
  }

  String get _formattedTime {
    if (_selectedTime == null) return '';

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

    if (pickedDate == null) return;

    setState(() {
      _selectedDate = pickedDate;
    });
  }

  Future<void> _pickTime() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime == null) return;

    setState(() {
      _selectedTime = pickedTime;
    });
  }

  void _confirmReservation() {
    if (_eventTypeController.text.trim().isEmpty) {
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

    if (_guestCount < 5 || _guestCount > 100) {
      _showMessage('Guest count must be between 5 and 100');
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ReservationConfirmedScreen(
          date: _selectedDate!,
          time: _selectedTime!,
          duration: _duration,
          guestCount: _guestCount,
        ),
      ),
    );
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
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Event Package Includes:',
            style: TextStyle(
              color: Color(0xFF6E11B0),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '• Exclusive use of the café\n'
            '• Complimentary hookah for'
            ' all guests\n'
            '• Special event menu available\n'
            '• Dedicated staff service\n'
            '• Sound system and music control',
            style: TextStyle(
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
            '\$${_baseRate.toStringAsFixed(0)}',
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
                '\$${_estimatedTotal.toStringAsFixed(0)}',
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

                    const Text(
                      'Book the café for your private\n'
                      'event. Perfect for parties, meetings,\n'
                      'and special occasions.',
                      style: TextStyle(
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

                    const Text(
                      'Minimum 5 guests, maximum 100 guests',
                      style: TextStyle(color: Color(0xFF6A7282), fontSize: 12),
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
                          onPressed: _confirmReservation,
                          child: const Text(
                            'Confirm Reservation',
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
