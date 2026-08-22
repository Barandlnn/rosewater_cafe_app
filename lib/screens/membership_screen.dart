import 'package:flutter/material.dart';
import 'create_account_details_screen.dart';

class MembershipScreen extends StatefulWidget {
  const MembershipScreen({super.key});

  @override
  State<MembershipScreen> createState() => _MembershipScreenState();
}

class _MembershipScreenState extends State<MembershipScreen> {

  
  String _selectedPlan = 'Premium';

  void _selectPlan(String plan) {
    setState(() {
      _selectedPlan = plan;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AccountDetailsScreen(selectedPlan: plan),
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
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Choose Your\nMembership',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF1E2939),
                    fontSize: 36,
                    fontWeight: FontWeight.w600,
                    height: 1.12,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Select the plan that fits your lifestyle',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFF6A7282), fontSize: 16),
                ),
                const SizedBox(height: 32),
                Center(
                  child: _PlanCard(
                    imagePath: 'assets/images/membership_basic_idle.png',
                    height: 507,
                    selected: _selectedPlan == 'Basic',
                    onSelect: () => _selectPlan('Basic'),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: _PlanCard(
                    imagePath: 'assets/images/membership_premium_idle.png',
                    height: 570,
                    selected: _selectedPlan == 'Premium',
                    onSelect: () => _selectPlan('Premium'),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: _PlanCard(
                    imagePath: 'assets/images/membership_vip_idle.png',
                    height: 575,
                    selected: _selectedPlan == 'VIP',
                    onSelect: () => _selectPlan('VIP'),
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: Image.asset(
                    'assets/images/Paragraph.png',
                    width: 343,
                    fit: BoxFit.fitWidth,
                    filterQuality: FilterQuality.high,
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

class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.imagePath,
    required this.height,
    required this.selected,
    required this.onSelect,
  });

  final String imagePath;
  final double height;
  final bool selected;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      width: 343,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        boxShadow: selected
            ? const [
                BoxShadow(
                  color: Color(0x669810FA),
                  blurRadius: 20,
                  spreadRadius: 2,
                  offset: Offset(0, 6),
                ),
              ]
            : const [],
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              imagePath,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.high,
            ),
          ),
          Positioned(
            left: 24,
            right: 24,
            bottom: 32,
            height: 48,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onSelect,
            ),
          ),
        ],
      ),
    );
  }
}
