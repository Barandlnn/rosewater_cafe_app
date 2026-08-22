import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
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
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back, size: 18),
                    label: const Text('Back to Sign In'),
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: Container(
                    width: 343,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x1A000000),
                          offset: Offset(0, 20),
                          blurRadius: 25,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 32,
                          backgroundColor: Color(0xFFE43DAD),
                          child: Icon(
                            Icons.lock_outline,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Forgot Password?',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF1E2939),
                          ),
                        ),
                        SizedBox(height: 24),
                        Text(
                          "No worries! Enter your email address\nand we'll send you a verification\ncode to reset your password.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF4A5565),
                            height: 1.45,
                          ),
                        ),
                        const SizedBox(height: 36),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Email Address',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            hintText: 'your.email@example.com',
                            prefixIcon: Icon(Icons.email_outlined),
                            filled: true,
                            fillColor: Color(0xFFF3F3F5),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: DecoratedBox(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFFFF2056), Color(0xFF9810FA)],
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                            child: TextButton(
                              onPressed: () {
                                final email = _emailController.text.trim();

                                if (email.isEmpty ||
                                    !email.contains('@') ||
                                    !email.contains('.')) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Please enter a valid email address.',
                                      ),
                                    ),
                                  );
                                  return;
                                }

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Verification code request sent',
                                    ),
                                  ),
                                );
                              },
                              child: const Text(
                                'Send Verification Code',
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
