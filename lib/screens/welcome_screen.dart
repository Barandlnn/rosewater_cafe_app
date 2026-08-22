import 'package:flutter/material.dart';
import 'signup_screen.dart';
import 'signin_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

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
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: 343,
                height: 628,
                child: Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: const Color(0xFFFFCCD3),
                      width: 0.5,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x40000000),
                        blurRadius: 25,
                        offset: Offset(0, 20),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 80),
                      const Text(
                        'Rosewater Café',
                        style: TextStyle(
                          color: Color(0xFF1E2939),
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          fontFamily: 'serif',
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'VIP Membership & Lounge',
                        style: TextStyle(
                          color: Color(0xFFEC003F),
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 56),
                      const _BenefitRow(
                        icon: Icons.wifi,
                        text: 'Premium Lounge',
                      ),
                      const SizedBox(height: 16),
                      const _BenefitRow(
                        icon: Icons.music_note,
                        text: 'Exclusive Services',
                      ),
                      const SizedBox(height: 16),
                      const _BenefitRow(
                        icon: Icons.group_outlined,
                        text: 'Bring Guests',
                      ),
                      const Spacer(),
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
                                  builder: (context) => const SignInScreen(),
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
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: 51,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignUpScreen(),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: Color(0xFFFFA1AD),
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Create Account',
                            style: TextStyle(
                              color: Color(0xFFEC003F),
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 56),
                      const Text(
                        'Premium hookah lounge & café experience',
                        style: TextStyle(
                          color: Color(0xFF6A7282),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BenefitRow extends StatelessWidget {
  const _BenefitRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 20, color: const Color(0xFFEC003F)),
        const SizedBox(width: 12),
        Text(
          text,
          style: const TextStyle(color: Color(0xFF4A5565), fontSize: 14),
        ),
      ],
    );
  }
}
