import 'package:flutter/material.dart';
import 'welcome_screen.dart';

class OnboardingEventsScreen extends StatelessWidget {
  const OnboardingEventsScreen({super.key});

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
              top: 198,
              left: 0,
              right: 0,
              child: Center(
                child: SizedBox(
                  width: 343,
                  child: Image.asset(
                    'assets/images/onboarding_events_card.png',
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
                    'assets/images/onboarding_events_bottom.png',
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
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WelcomeScreen(),
                    ),
                    (route) => false,
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
