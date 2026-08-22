import 'package:flutter/material.dart';
import 'onboarding_events.dart';
import 'welcome_screen.dart';

class OnboardingAllowancesScreen extends StatelessWidget {
  const OnboardingAllowancesScreen({super.key});

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
              top: 198,
              left: 0,
              right: 0,
              child: Center(
                child: SizedBox(
                  width: 343,
                  child: Image.asset(
                    'assets/images/onboarding_allowances_card.png',
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 681,
              left: 0,
              right: 0,
              child: Center(
                child: SizedBox(
                  width: 343,
                  child: Image.asset(
                    'assets/images/onboarding_allowances_bottom.png',
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 713,
              left: 16,
              width: 163,
              height: 51,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Positioned(
              top: 713,
              right: 16,
              width: 163,
              height: 48,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const OnboardingEventsScreen(),
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
