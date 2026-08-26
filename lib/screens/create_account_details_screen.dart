import 'package:flutter/material.dart';

import 'payment_screen.dart';

class AccountDetailsScreen extends StatefulWidget {
  const AccountDetailsScreen({super.key, required this.selectedPlan});

  final String selectedPlan;

  @override
  State<AccountDetailsScreen> createState() => _AccountDetailsScreenState();
}

class _AccountDetailsScreenState extends State<AccountDetailsScreen> {
  final _formKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _isIdDocumentSelected = false;
  bool _showIdDocumentError = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();

    super.dispose();
  }

  void _selectDemoIdDocument() {
    setState(() {
      _isIdDocumentSelected = true;
      _showIdDocumentError = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Demo ID selected. Real file upload will be connected later.',
        ),
      ),
    );
  }

  void _continueToPayment() {
    final isFormValid = _formKey.currentState?.validate() ?? false;

    setState(() {
      _showIdDocumentError = !_isIdDocumentSelected;
    });

    if (!isFormValid || !_isIdDocumentSelected) {
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentScreen(selectedPlan: widget.selectedPlan),
      ),
    );
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
                    'Back to Plans',
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Create Your Account',
                            style: TextStyle(
                              color: Color(0xFF1E2939),
                              fontSize: 28,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 28),

                          // Full Name
                          const Text(
                            'Full Name *',
                            style: TextStyle(
                              color: Color(0xFF1E2939),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _fullNameController,
                            textCapitalization: TextCapitalization.words,
                            validator: (value) {
                              final fullName = value?.trim() ?? '';

                              if (fullName.isEmpty) {
                                return 'Please enter your full name.';
                              }

                              if (fullName.length < 5) {
                                return 'Name must be at least 5 characters.';
                              }

                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: 'John Doe',
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

                          const SizedBox(height: 20),

                          // Email
                          const Text(
                            'Email Address *',
                            style: TextStyle(
                              color: Color(0xFF1E2939),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              final email = value?.trim() ?? '';

                              if (email.isEmpty) {
                                return 'Please enter your email address.';
                              }

                              if (!email.contains('@') ||
                                  !email.contains('.')) {
                                return 'Please enter a valid email address.';
                              }

                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: 'you@email.com',
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

                          const SizedBox(height: 20),

                          // Phone
                          const Text(
                            'Phone Number *',
                            style: TextStyle(
                              color: Color(0xFF1E2939),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              final phone = value?.trim() ?? '';

                              final digitCount = phone
                                  .replaceAll(RegExp(r'\D'), '')
                                  .length;

                              if (phone.isEmpty) {
                                return 'Please enter your phone number.';
                              }

                              if (digitCount < 7) {
                                return 'Please enter a valid phone number.';
                              }

                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: '+1 (555) 000-0000',
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

                          const SizedBox(height: 20),

                          // Subscription Plan
                          const Text(
                            'Subscription Plan *',
                            style: TextStyle(
                              color: Color(0xFF1E2939),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F4F6),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              widget.selectedPlan,
                              style: const TextStyle(
                                color: Color(0xFF4A5565),
                                fontSize: 16,
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // ID Document
                          const Text(
                            'Upload ID Document *',
                            style: TextStyle(
                              color: Color(0xFF1E2939),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 6),

                          InkWell(
                            onTap: _selectDemoIdDocument,
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              width: double.infinity,
                              height: 128,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: _showIdDocumentError
                                      ? Colors.red
                                      : _isIdDocumentSelected
                                      ? const Color(0xFF22C55E)
                                      : const Color(0xFFCBD5E1),
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    _isIdDocumentSelected
                                        ? Icons.check_circle_outline
                                        : Icons.file_upload_outlined,
                                    size: 34,
                                    color: _isIdDocumentSelected
                                        ? const Color(0xFF22C55E)
                                        : const Color(0xFF94A3B8),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    _isIdDocumentSelected
                                        ? 'ID document selected'
                                        : 'Click to upload ID',
                                    style: const TextStyle(
                                      color: Color(0xFF4A5565),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _isIdDocumentSelected
                                        ? 'Demo selection'
                                        : 'PNG, JPG, PDF (max 10MB)',
                                    style: const TextStyle(
                                      color: Color(0xFF94A3B8),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          if (_showIdDocumentError)
                            const Padding(
                              padding: EdgeInsets.only(top: 8),
                              child: Text(
                                'Please upload your ID document.',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                ),
                              ),
                            ),

                          const SizedBox(height: 6),

                          const Text(
                            'Required for membership verification and security',
                            style: TextStyle(
                              color: Color(0xFF64748B),
                              fontSize: 12,
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Continue Button
                          DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFFF2056), Color(0xFF9810FA)],
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: TextButton(
                                onPressed: _continueToPayment,
                                child: const Text(
                                  'Continue to Payment',
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
