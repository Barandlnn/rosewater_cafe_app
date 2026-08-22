import 'package:flutter/material.dart';
import 'signin_screen.dart';
import 'membership_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _hasAcceptedTerms = false;

  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignInScreen(),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      size: 16,
                      color: Color(0xFF0A0A0A),
                    ),
                    label: const Text(
                      'Back',
                      style: TextStyle(
                        color: Color(0xFF0A0A0A),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  width: 343,
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x1A000000),
                        blurRadius: 25,
                        offset: Offset(0, 20),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Center(
                          child: CircleAvatar(
                            radius: 32,
                            backgroundColor: Color(0xFFFF637E),
                            child: Icon(
                              Icons.person_outline,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Center(
                          child: Text(
                            'Create Account',
                            style: TextStyle(
                              color: Color(0xFF1E2939),
                              fontSize: 30,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Center(
                          child: Text(
                            'Join Rosewater Café today',
                            style: TextStyle(
                              color: Color(0xFF4A5565),
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        const Text(
                          'Full Name',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        TextFormField(
                          controller: _fullNameController,
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
                          decoration: const InputDecoration(
                            hintText: 'John Doe',
                            prefixIcon: Icon(Icons.person_outline),
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
                        const SizedBox(height: 20),
                        const Text(
                          'Email Address',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            final email = value?.trim() ?? '';

                            if (email.isEmpty) {
                              return 'Please enter your email address.';
                            }

                            if (!email.contains('@') || !email.contains('.')) {
                              return 'Please enter a valid email address.';
                            }

                            return null;
                          },
                          decoration: const InputDecoration(
                            hintText: 'your@email.com',
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
                        const SizedBox(height: 20),
                        const Text(
                          'Phone Number',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
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
                          decoration: const InputDecoration(
                            hintText: '+1 (555) 000-0000',
                            prefixIcon: Icon(Icons.phone_outlined),
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
                        const SizedBox(height: 20),
                        const Text(
                          'Password',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        TextFormField(
                          controller: _passwordController,
                          validator: (value) {
                            final password = value ?? '';

                            if (password.isEmpty) {
                              return 'Please enter a password.';
                            }

                            if (password.length < 8) {
                              return 'Password must be at least 8 characters.';
                            }

                            return null;
                          },
                          obscureText: !_isPasswordVisible,
                          decoration: InputDecoration(
                            hintText: '••••••••',
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                              ),
                            ),
                            filled: true,
                            fillColor: const Color(0xFFF3F3F5),
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Must be at least 8 characters',
                          style: TextStyle(
                            color: Color(0xFF6A7282),
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Confirm Password',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        TextFormField(
                          controller: _confirmPasswordController,
                          validator: (value) {
                            final confirmPassword = value ?? '';

                            if (confirmPassword.isEmpty) {
                              return 'Please confirm your password.';
                            }

                            if (confirmPassword != _passwordController.text) {
                              return 'Passwords do not match.';
                            }

                            return null;
                          },
                          obscureText: !_isConfirmPasswordVisible,
                          decoration: InputDecoration(
                            hintText: '••••••••',
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _isConfirmPasswordVisible =
                                      !_isConfirmPasswordVisible;
                                });
                              },
                              icon: Icon(
                                _isConfirmPasswordVisible
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                              ),
                            ),
                            filled: true,
                            fillColor: const Color(0xFFF3F3F5),
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Checkbox(
                              value: _hasAcceptedTerms,
                              activeColor: const Color(0xFFEC003F),
                              onChanged: (value) {
                                setState(() {
                                  _hasAcceptedTerms = value ?? false;
                                });
                              },
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Wrap(
                                  children: const [
                                    Text(
                                      'I agree to the ',
                                      style: TextStyle(
                                        color: Color(0xFF4A5565),
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      'Terms of Service',
                                      style: TextStyle(
                                        color: Color(0xFFEC003F),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      ' and ',
                                      style: TextStyle(
                                        color: Color(0xFF4A5565),
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      'Privacy Policy',
                                      style: TextStyle(
                                        color: Color(0xFFEC003F),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

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
                                if (!_hasAcceptedTerms) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Please accept the Terms of Service and Privacy Policy.',
                                      ),
                                    ),
                                  );
                                  return;
                                }
                                if (!(_formKey.currentState?.validate() ??
                                    false)) {
                                  return;
                                }

                               Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const MembershipScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                'Create Account',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Already have an account?',
                              style: TextStyle(
                                color: Color(0xFF4A5565),
                                fontSize: 14,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SignInScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                'Sign In',
                                style: TextStyle(
                                  color: Color(0xFFEC003F),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
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
