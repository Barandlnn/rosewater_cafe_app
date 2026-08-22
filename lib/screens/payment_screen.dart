import 'package:flutter/material.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key, required this.selectedPlan});

  final String selectedPlan;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _cardNumberController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _cvvController = TextEditingController();

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
                          children: [
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
                                    decoration: InputDecoration(
                                      hintText: 'MM/YY',
                                      filled: true,
                                      fillColor: const Color(0xFFF3F4F6),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
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
                                    decoration: InputDecoration(
                                      hintText: '123',
                                      filled: true,
                                      fillColor: const Color(0xFFF3F4F6),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
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
                                    onPressed: () {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Payment of \$$_price will be connected securely later',
                                          ),
                                        ),
                                      );
                                    },
                                    child: Text(
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
