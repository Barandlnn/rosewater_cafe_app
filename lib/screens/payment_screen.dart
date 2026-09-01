import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../services/auth_service.dart';
import '../services/membership_service.dart';
import 'member_dashboard_screen.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key, required this.selectedPlan});

  final String selectedPlan;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _formKey = GlobalKey<FormState>();

  final _cardNumberController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _cvvController = TextEditingController();

  bool _isLoading = false;

  String get _price {
    switch (widget.selectedPlan) {
      case 'Premium':
        return '199';
      case 'VIP':
        return '399';
      default:
        return '99';
    }
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();

    super.dispose();
  }

  String? _validateCardNumber(String? value) {
    final cardNumber = value?.replaceAll(' ', '') ?? '';

    if (cardNumber.isEmpty) {
      return 'Please enter your card number.';
    }

    if (cardNumber.length != 16) {
      return 'Card number must contain 16 digits.';
    }

    if (!RegExp(r'^\d{16}$').hasMatch(cardNumber)) {
      return 'Please enter a valid card number.';
    }

    return null;
  }

  String? _validateExpiryDate(String? value) {
    final expiryDate = value?.trim() ?? '';

    if (expiryDate.isEmpty) {
      return 'Please enter the expiry date.';
    }

    if (!RegExp(r'^\d{2}/\d{2}$').hasMatch(expiryDate)) {
      return 'Use MM/YY format.';
    }

    final parts = expiryDate.split('/');

    final month = int.tryParse(parts[0]);
    final year = int.tryParse(parts[1]);

    if (month == null || month < 1 || month > 12) {
      return 'Please enter a  \n valid month.';
    }

    if (year == null) {
      return 'Please enter a \n valid year.';
    }

    final now = DateTime.now();

    final currentYear = now.year % 100;
    final currentMonth = now.month;

    if (year < currentYear || (year == currentYear && month < currentMonth)) {
      return 'This card \n has expired.';
    }

    return null;
  }

  String? _validateCvv(String? value) {
    final cvv = value?.trim() ?? '';

    if (cvv.isEmpty) {
      return 'Please enter CVV.';
    }

    if (!RegExp(r'^\d{3,4}$').hasMatch(cvv)) {
      return 'CVV must be 3 or 4 digits.';
    }

    return null;
  }

  Future<void> _submitPayment() async {
    final isFormValid = _formKey.currentState?.validate() ?? false;

    if (!isFormValid || _isLoading) {
      return;
    }

    final user = AuthService.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You must be signed in to create a membership.'),
        ),
      );

      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await MembershipService.createMembershipWithUsage(
        uid: user.uid,
        plan: widget.selectedPlan,
      );

      if (!mounted) {
        return;
      }

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MemberDashboardScreen()),
        (route) => false,
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Membership creation failed: $error')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFFF1F2), Color(0xFFFDF2F8), Color(0xFFFAF5FF)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.arrow_back,
                    size: 18,
                    color: Color(0xFF1E2939),
                  ),
                  label: const Text(
                    'Back',
                    style: TextStyle(color: Color(0xFF1E2939), fontSize: 14),
                  ),
                ),
                const SizedBox(height: 24),

                Center(
                  child: Container(
                    width: 343,
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.90),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x260F172A),
                          blurRadius: 20,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const Icon(
                            Icons.credit_card_outlined,
                            size: 48,
                            color: Color(0xFFEC003F),
                          ),
                          const SizedBox(height: 24),

                          const Text(
                            'Complete Payment',
                            style: TextStyle(
                              color: Color(0xFF1E2939),
                              fontSize: 28,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            '${widget.selectedPlan} Plan',
                            style: const TextStyle(
                              color: Color(0xFF4A5565),
                              fontSize: 16,
                            ),
                          ),

                          const SizedBox(height: 32),

                          // Payment Summary
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Monthly Subscription'),
                                    Text('\$$_price'),
                                  ],
                                ),
                                const Divider(height: 24),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Total',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      '\$$_price',
                                      style: const TextStyle(
                                        color: Color(0xFF1E2939),
                                        fontSize: 24,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 32),

                          // Card Number
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Card Number',
                              style: TextStyle(
                                color: Color(0xFF1E2939),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),

                          const SizedBox(height: 6),

                          TextFormField(
                            controller: _cardNumberController,
                            keyboardType: TextInputType.number,
                            validator: _validateCardNumber,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'[0-9 ]'),
                              ),
                              LengthLimitingTextInputFormatter(19),
                            ],
                            decoration: InputDecoration(
                              hintText: '1234 5678 9012 3456',
                              filled: true,
                              fillColor: const Color(0xFFF3F4F6),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Expiry Date
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Expiry Date',
                                      style: TextStyle(
                                        color: Color(0xFF1E2939),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    TextFormField(
                                      controller: _expiryDateController,
                                      keyboardType: TextInputType.number,
                                      validator: _validateExpiryDate,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                          RegExp(r'[0-9/]'),
                                        ),
                                        LengthLimitingTextInputFormatter(5),
                                      ],
                                      decoration: InputDecoration(
                                        hintText: 'MM/YY',
                                        filled: true,
                                        fillColor: const Color(0xFFF3F4F6),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          borderSide: BorderSide.none,
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 14,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(width: 16),

                              // CVV
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'CVV',
                                      style: TextStyle(
                                        color: Color(0xFF1E2939),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    TextFormField(
                                      controller: _cvvController,
                                      keyboardType: TextInputType.number,
                                      obscureText: true,
                                      validator: _validateCvv,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(4),
                                      ],
                                      decoration: InputDecoration(
                                        hintText: '123',
                                        filled: true,
                                        fillColor: const Color(0xFFF3F4F6),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          borderSide: BorderSide.none,
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 14,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 32),

                          Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 48,
                                  child: OutlinedButton(
                                    onPressed: () => Navigator.pop(context),
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(
                                        color: Color(0xFFE2E8F0),
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Text(
                                      'Back',
                                      style: TextStyle(
                                        color: Color(0xFF1E2939),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(width: 12),

                              Expanded(
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFFFF2056),
                                        Color(0xFF9810FA),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: SizedBox(
                                    height: 48,
                                    child: TextButton(
                                      onPressed: _isLoading
                                          ? null
                                          : _submitPayment,
                                      child: _isLoading
                                          ? const SizedBox(
                                              width: 22,
                                              height: 22,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: Colors.white,
                                              ),
                                            )
                                          : Text(
                                              'Pay \$$_price',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
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
      ),
    );
  }
}
