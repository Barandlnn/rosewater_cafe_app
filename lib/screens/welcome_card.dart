import 'package:flutter/material.dart';

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
        child: Stack(
          children: [
            Positioned(
              top: 92,
              left: 0,
              right: 0,
              child: Center(
                child: SizedBox(
                  width: 343,
                  child: Image.asset(
                    'assets/images/welcome_card.png',
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            ),

            // Sign In tıklama alanı
            Positioned(
              top: 512,
              left: 49,
              width: 278,
              height: 48,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Sign In button pressed')),
                  );
                },
              ),
            ),

            // Create Account tıklama alanı
            Positioned(
              top: 572,
              left: 49,
              width: 278,
              height: 51,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Create Account button pressed'),
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
