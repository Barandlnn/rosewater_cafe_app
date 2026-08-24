import 'package:flutter/material.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  String _defaultCard = 'Visa';

  bool _showVisa = true;
  bool _showMastercard = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7FB),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              _buildHeader(),

              const SizedBox(height: 8),

              _buildAddPaymentButton(),

              const SizedBox(height: 16),

              // VISA
              if (_showVisa)
                _buildPaymentCard(
                  cardName: 'Visa',
                  lastFourDigits: '4242',
                  expiryDate: '12/25',
                  isDefault: _defaultCard == 'Visa',
                  onSetDefault: () {
                    setState(() {
                      _defaultCard = 'Visa';
                    });
                  },
                  onDelete: () {
                    setState(() {
                      _showVisa = false;

                      // Silinen kart default ise kalan kartı default yap.
                      if (_defaultCard == 'Visa' && _showMastercard) {
                        _defaultCard = 'Mastercard';
                      }
                    });
                  },
                ),

              // İki kart da varsa aralarında boşluk göster.
              if (_showVisa && _showMastercard) const SizedBox(height: 16),

              // MASTERCARD
              if (_showMastercard)
                _buildPaymentCard(
                  cardName: 'Mastercard',
                  lastFourDigits: '8888',
                  expiryDate: '08/26',
                  isDefault: _defaultCard == 'Mastercard',
                  onSetDefault: () {
                    setState(() {
                      _defaultCard = 'Mastercard';
                    });
                  },
                  onDelete: () {
                    setState(() {
                      _showMastercard = false;

                      // Silinen kart default ise kalan kartı default yap.
                      if (_defaultCard == 'Mastercard' && _showVisa) {
                        _defaultCard = 'Visa';
                      }
                    });
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // HEADER
  // ---------------------------------------------------------------------------

  Widget _buildHeader() {
    return SizedBox(
      height: 45,
      child: Row(
        children: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            borderRadius: BorderRadius.circular(20),
            child: const SizedBox(
              width: 32,
              height: 40,
              child: Icon(Icons.arrow_back, size: 18, color: Color(0xFF1E2939)),
            ),
          ),

          const SizedBox(width: 8),

          const Text(
            'Payment Methods',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1E2939),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // ADD PAYMENT BUTTON
  // ---------------------------------------------------------------------------

  Widget _buildAddPaymentButton() {
    return SizedBox(
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
        child: ElevatedButton.icon(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Add payment method will be connected next'),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          icon: const Icon(Icons.add, size: 18),
          label: const Text(
            'Add New Payment Method',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // REUSABLE PAYMENT CARD
  // ---------------------------------------------------------------------------

  Widget _buildPaymentCard({
    required String cardName,
    required String lastFourDigits,
    required String expiryDate,
    required bool isDefault,
    required VoidCallback onSetDefault,
    required VoidCallback onDelete,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.90),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.10),
          width: 0.5,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // CARD ICON
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.credit_card,
              size: 26,
              color: Color(0xFF6A7282),
            ),
          ),

          const SizedBox(width: 16),

          // CARD INFORMATION
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      cardName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1E2939),
                      ),
                    ),

                    const SizedBox(width: 8),

                    if (isDefault)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDCFCE7),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Default',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF016630),
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 8),

                Text(
                  '•••• •••• •••• $lastFourDigits',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF4A5565),
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  'Expires $expiryDate',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF6A7282),
                  ),
                ),
              ],
            ),
          ),

          // SET DEFAULT ICON
          if (!isDefault)
            Padding(
              padding: const EdgeInsets.only(top: 4, right: 8),
              child: InkWell(
                onTap: onSetDefault,
                borderRadius: BorderRadius.circular(20),
                child: const Padding(
                  padding: EdgeInsets.all(4),
                  child: Icon(
                    Icons.check_circle_outline,
                    size: 19,
                    color: Color(0xFF00A63E),
                  ),
                ),
              ),
            ),

          // DELETE ICON
          InkWell(
            onTap: onDelete,
            borderRadius: BorderRadius.circular(20),
            child: const Padding(
              padding: EdgeInsets.all(4),
              child: Icon(
                Icons.delete_outline,
                size: 19,
                color: Color(0xFFE7000B),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
