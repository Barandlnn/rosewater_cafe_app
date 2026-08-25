import 'package:flutter/material.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  bool _isQrFaqExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7FB),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              _buildHeader(),

              const SizedBox(height: 8),

              // LIVE CHAT
              _buildSupportCard(
                icon: Icons.chat_bubble_outline,
                iconColor: const Color(0xFFFF0054),
                title: 'Live Chat',
                subtitle: 'Chat with our team',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Live Chat will be connected later'),
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              // EMAIL US
              _buildSupportCard(
                icon: Icons.email_outlined,
                iconColor: const Color(0xFF9810FA),
                title: 'Email Us',
                subtitle: 'Get help via email',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Email support will be connected later'),
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              // CALL US
              _buildSupportCard(
                icon: Icons.phone_outlined,
                iconColor: const Color(0xFF00A63E),
                title: 'Call Us',
                subtitle: 'Speak to support',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Call support will be connected later'),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              // FAQ
              _buildFaqHeader(),
              _buildFaqItem(
                question: 'How do I use my QR code to enter the café?',
                answer:
                    'Simply open the QR Code section from your dashboard, '
                    'show it to the scanner at the entrance, and specify how '
                    'many guests are with you.',
                isExpanded: _isQrFaqExpanded,
                onTap: () {
                  setState(() {
                    _isQrFaqExpanded = !_isQrFaqExpanded;
                  });
                },
              ),

              _buildCollapsedFaqItem(
                question: 'What happens when my monthly allowance runs out?',
              ),

              _buildCollapsedFaqItem(
                question: 'Can I bring guests to the café?',
              ),

              _buildCollapsedFaqItem(
                question:
                    'What\'s the difference between full service and self-service hours?',
              ),

              const SizedBox(height: 24),

              _buildResourcesCard(),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // HEADER
  // ---------------------------------------------------------------------------

  Widget _buildHeader() {
    return SizedBox(
      height: 40,
      child: Row(
        children: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            borderRadius: BorderRadius.circular(20),
            child: const SizedBox(
              width: 32,
              height: 40,
              child: Icon(Icons.arrow_back, size: 18, color: Color(0xFF1E2939)),
            ),
          ),

          const SizedBox(width: 8),

          const Text(
            'Help & Support',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1E2939),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // SUPPORT CARD
  // ---------------------------------------------------------------------------

  Widget _buildSupportCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.90),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Colors.black.withValues(alpha: 0.10),
              width: 0.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 28, color: iconColor),

              const SizedBox(height: 36),

              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1E2939),
                ),
              ),

              const SizedBox(height: 32),

              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF6A7282),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCollapsedFaqItem({required String question}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.90),
        border: Border(
          left: BorderSide(
            color: Colors.black.withValues(alpha: 0.08),
            width: 0.5,
          ),
          right: BorderSide(
            color: Colors.black.withValues(alpha: 0.08),
            width: 0.5,
          ),
          bottom: BorderSide(
            color: Colors.black.withValues(alpha: 0.08),
            width: 0.5,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Text(
                question,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1E2939),
                  height: 1.4,
                ),
              ),
            ),

            const SizedBox(width: 8),

            const Icon(Icons.chevron_right, size: 20, color: Color(0xFF94A3B8)),
          ],
        ),
      ),
    );
  }

  Widget _buildResourceRow({
    required String title,
    required VoidCallback onTap,
    bool isLast = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: isLast
            ? const BorderRadius.only(
                bottomLeft: Radius.circular(14),
                bottomRight: Radius.circular(14),
              )
            : BorderRadius.zero,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.90),
            borderRadius: isLast
                ? const BorderRadius.only(
                    bottomLeft: Radius.circular(14),
                    bottomRight: Radius.circular(14),
                  )
                : BorderRadius.zero,
            border: Border(
              left: BorderSide(
                color: Colors.black.withValues(alpha: 0.08),
                width: 0.5,
              ),
              right: BorderSide(
                color: Colors.black.withValues(alpha: 0.08),
                width: 0.5,
              ),
              bottom: BorderSide(
                color: Colors.black.withValues(alpha: 0.08),
                width: 0.5,
              ),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF1E2939),
                  ),
                ),
              ),

              const Icon(
                Icons.chevron_right,
                size: 20,
                color: Color(0xFF94A3B8),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResourcesCard() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.90),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(14),
              topRight: Radius.circular(14),
            ),
            border: Border(
              top: BorderSide(
                color: Colors.black.withValues(alpha: 0.08),
                width: 0.5,
              ),
              left: BorderSide(
                color: Colors.black.withValues(alpha: 0.08),
                width: 0.5,
              ),
              right: BorderSide(
                color: Colors.black.withValues(alpha: 0.08),
                width: 0.5,
              ),
            ),
          ),
          child: const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Resources',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E2939),
              ),
            ),
          ),
        ),

        _buildResourceRow(
          title: 'User Guide',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('User Guide will be connected later'),
              ),
            );
          },
        ),

        _buildResourceRow(
          title: 'Membership Benefits',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Membership Benefits will be connected later'),
              ),
            );
          },
        ),

        _buildResourceRow(
          title: 'Community Guidelines',
          isLast: true,
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Community Guidelines will be connected later'),
              ),
            );
          },
        ),
      ],
    );
  }
  // ---------------------------------------------------------------------------
  // FAQ HEADER
  // ---------------------------------------------------------------------------

  Widget _buildFaqHeader() {
    return Container(
      width: double.infinity,
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFFFF2056), Color(0xFF9810FA)],
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(14),
          topRight: Radius.circular(14),
        ),
      ),
      child: const Row(
        children: [
          Icon(Icons.help_outline, size: 20, color: Colors.white),

          SizedBox(width: 8),

          Text(
            'Frequently Asked Questions',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // FAQ ITEM
  // ---------------------------------------------------------------------------

  Widget _buildFaqItem({
    required String question,
    required String answer,
    required bool isExpanded,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.90),
        border: Border(
          left: BorderSide(
            color: Colors.black.withValues(alpha: 0.08),
            width: 0.5,
          ),
          right: BorderSide(
            color: Colors.black.withValues(alpha: 0.08),
            width: 0.5,
          ),
          bottom: BorderSide(
            color: Colors.black.withValues(alpha: 0.08),
            width: 0.5,
          ),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        question,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF1E2939),
                          height: 1.4,
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),

                    Icon(
                      isExpanded
                          ? Icons.keyboard_arrow_down
                          : Icons.chevron_right,
                      size: 20,
                      color: const Color(0xFF94A3B8),
                    ),
                  ],
                ),

                if (isExpanded) ...[
                  const SizedBox(height: 14),

                  Text(
                    answer,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF6A7282),
                      height: 1.5,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
