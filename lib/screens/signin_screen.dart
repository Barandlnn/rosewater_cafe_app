import 'package:flutter/material.dart';
import 'forgot_password_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _isPasswordVisible = false;
  bool _rememberMe = false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
                    label: const Text('Back'),
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
                          'Welcome Back',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF1E2939),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Sign in to your account',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF4A5565),
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
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Password',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        TextFormField(
                          controller: _passwordController,
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
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  value: _rememberMe,
                                  activeColor: const Color(0xFFFF2056),
                                  onChanged: (value) {
                                    setState(() {
                                      _rememberMe = value ?? false;
                                    });
                                  },
                                ),
                                const Text(
                                  'Remember me',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF4A5565),
                                  ),
                                ),
                              ],
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ForgotPasswordScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  height: 20 / 14,
                                  letterSpacing: -.15,
                                  color: Color(0xFFFF2056),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
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
                                final password = _passwordController.text;

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

                                if (password.length < 8) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Password must be at least 8 characters.',
                                      ),
                                    ),
                                  );
                                  return;
                                }

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Sign in successful — demo mode',
                                    ),
                                  ),
                                );
                              },
                              child: const Text(
                                'Sign In',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 56),
                        const Text(
                          'Demo: Use any email and password to\nsign in',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF4A5565),
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
