import 'package:flutter/material.dart';
import 'payment_screen.dart';

class AccountDetailsScreen extends StatefulWidget {
  const AccountDetailsScreen({super.key, required this.selectedPlan});

  final String selectedPlan;

  @override
  State<AccountDetailsScreen> createState() => _AccountDetailsScreenState();
}

class _AccountDetailsScreenState extends State<AccountDetailsScreen> {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
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
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'File selection will be added next',
                                ),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            width: double.infinity,
                            height: 128,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: const Color(0xFFCBD5E1),
                              ),
                            ),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.file_upload_outlined,
                                  size: 34,
                                  color: Color(0xFF94A3B8),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Click to upload ID',
                                  style: TextStyle(
                                    color: Color(0xFF4A5565),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'PNG, JPG, PDF (max 10MB)',
                                  style: TextStyle(
                                    color: Color(0xFF94A3B8),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
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
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PaymentScreen(
                                      selectedPlan: widget.selectedPlan,
                                    ),
                                  ),
                                );
                              },
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
