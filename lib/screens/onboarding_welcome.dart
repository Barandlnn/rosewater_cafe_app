import 'package:flutter/material.dart';
import 'onboarding_qr.dart';
import 'welcome_screen.dart';

class OnboardingWelcomeScreen extends StatelessWidget {
  const OnboardingWelcomeScreen({super.key});
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
        child: Stack(
          children: [
            Positioned(
              top: 32,
              right: 16,
              child: TextButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WelcomeScreen(),
                    ),
                    (route) => false,
                  );
                },
                style: TextButton.styleFrom(
                  minimumSize: const Size(61, 36),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'Skip',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF4A5565),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 181,
              left: 0,
              right: 0,
              child: Center(
                child: SizedBox(
                  width: 343,
                  child: Image.asset(
                    'assets/images/wine_glass.png',
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 684,
              left: 0,
              right: 0,
              child: Center(
                child: SizedBox(
                  width: 343,
                  child: Image.asset(
                    'assets/images/arrow_right.png',
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 711,
              left: 16,
              right: 16,
              height: 48,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const OnboardingQrScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
