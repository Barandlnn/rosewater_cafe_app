import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'auth_gate.dart';
import '../services/account_service.dart';
import '../services/auth_service.dart';

class PrivacySecurityScreen extends StatefulWidget {
  const PrivacySecurityScreen({super.key});

  @override
  State<PrivacySecurityScreen> createState() => _PrivacySecurityScreenState();
}

class _PrivacySecurityScreenState extends State<PrivacySecurityScreen> {
  bool _biometricAuthentication = false;
  bool _twoFactorAuthentication = false;
  bool _autoLock = true;
  bool _showPasswordForm = false;

  bool _isUpdatingPassword = false;
  bool _isDeletingAccount = false;

  final TextEditingController _currentPasswordController =
      TextEditingController();

  final TextEditingController _newPasswordController = TextEditingController();

  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
  }

  String? _validatePasswordUpdate() {
    final currentPassword = _currentPasswordController.text;
    final newPassword = _newPasswordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (currentPassword.isEmpty) {
      return 'Please enter your current password';
    }

    if (newPassword.isEmpty) {
      return 'Please enter a new password';
    }

    if (confirmPassword.isEmpty) {
      return 'Please confirm your new password';
    }

    if (newPassword.length < 6) {
      return 'New password must be at least 6 characters';
    }

    if (newPassword != confirmPassword) {
      return 'New passwords do not match';
    }

    return null;
  }

  Future<void> _updatePassword() async {
    final validationError = _validatePasswordUpdate();

    if (validationError != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(validationError)));

      return;
    }

    if (_isUpdatingPassword) {
      return;
    }

    setState(() {
      _isUpdatingPassword = true;
    });

    try {
      await AuthService.updatePassword(
        currentPassword: _currentPasswordController.text,
        newPassword: _newPasswordController.text,
      );

      if (!mounted) {
        return;
      }

      _currentPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();

      setState(() {
        _isUpdatingPassword = false;
        _showPasswordForm = false;

        _obscureCurrentPassword = true;
        _obscureNewPassword = true;
        _obscureConfirmPassword = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password updated successfully.')),
      );
    } on FirebaseAuthException catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isUpdatingPassword = false;
      });

      String message;

      switch (error.code) {
        case 'wrong-password':
        case 'invalid-credential':
          message = 'Your current password is incorrect.';
          break;

        case 'weak-password':
          message = 'Your new password is too weak.';
          break;

        case 'too-many-requests':
          message = 'Too many attempts. Please try again later.';
          break;

        case 'network-request-failed':
          message = 'Please check your internet connection.';
          break;

        case 'requires-recent-login':
          message = 'Please sign in again before changing your password.';
          break;

        default:
          message = 'Password could not be updated (${error.code}).';
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isUpdatingPassword = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password could not be updated.')),
      );
    }
  }

  Future<String?> _deleteAccount(String currentPassword) async {
    if (_isDeletingAccount) {
      return 'Account deletion is already in progress.';
    }

    setState(() {
      _isDeletingAccount = true;
    });

    try {
      await AccountService.deleteAccount(currentPassword: currentPassword);

      return null;
    } on FirebaseAuthException catch (error) {
      switch (error.code) {
        case 'wrong-password':
        case 'invalid-credential':
          return 'Your current password is incorrect.';

        case 'too-many-requests':
          return 'Too many attempts. Please try again later.';

        case 'network-request-failed':
          return 'Please check your internet connection.';

        case 'requires-recent-login':
          return 'Please sign in again before deleting your account.';

        case 'user-not-found':
          return 'No signed-in user was found.';

        default:
          return 'Account could not be deleted (${error.code}).';
      }
    } on FirebaseException catch (error) {
      if (error.code == 'permission-denied') {
        return 'Some account data could not be deleted due to permissions.';
      }

      return 'Account data could not be deleted (${error.code}).';
    } catch (_) {
      return 'Account could not be deleted. Please try again.';
    } finally {
      if (mounted) {
        setState(() {
          _isDeletingAccount = false;
        });
      }
    }
  }

  Future<void> _showDeleteAccountDialog() async {
    if (_isDeletingAccount) {
      return;
    }

    final passwordController = TextEditingController();

    var obscurePassword = true;
    var isSubmitting = false;
    String? errorMessage;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text(
                'Delete Account',
                style: TextStyle(
                  color: Color(0xFFE7000B),
                  fontWeight: FontWeight.w600,
                ),
              ),
              content: SizedBox(
                width: 320,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'This action permanently deletes your account and associated data. It cannot be undone.',
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.4,
                        color: Color(0xFF4A5565),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Current Password',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1E2939),
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: passwordController,
                      obscureText: obscurePassword,
                      enabled: !isSubmitting,
                      decoration: InputDecoration(
                        hintText: 'Enter your current password',
                        filled: true,
                        fillColor: const Color(0xFFF3F4F6),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: IconButton(
                          onPressed: isSubmitting
                              ? null
                              : () {
                                  setDialogState(() {
                                    obscurePassword = !obscurePassword;
                                  });
                                },
                          icon: Icon(
                            obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                        ),
                      ),
                    ),
                    if (errorMessage != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        errorMessage!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFFE7000B),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isSubmitting
                      ? null
                      : () {
                          Navigator.of(dialogContext).pop();
                        },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: isSubmitting
                      ? null
                      : () async {
                          final password = passwordController.text;

                          if (password.isEmpty) {
                            setDialogState(() {
                              errorMessage =
                                  'Please enter your current password.';
                            });

                            return;
                          }

                          setDialogState(() {
                            isSubmitting = true;
                            errorMessage = null;
                          });

                          final error = await _deleteAccount(password);

                          if (!dialogContext.mounted) {
                            return;
                          }

                          if (error == null) {
                            Navigator.of(dialogContext).pop();

                            if (!mounted) {
                              return;
                            }

                            Navigator.pushAndRemoveUntil(
                              this.context,
                              MaterialPageRoute(
                                builder: (_) => const AuthGate(),
                              ),
                              (route) => false,
                            );

                            return;
                          }

                          setDialogState(() {
                            isSubmitting = false;
                            errorMessage = error;
                          });
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE7000B),
                    foregroundColor: Colors.white,
                  ),
                  child: isSubmitting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Delete Permanently'),
                ),
              ],
            );
          },
        );
      },
    );

    passwordController.dispose();
  }

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

              _buildSecurityOptionsHeader(),

              _buildSecurityOptionRow(
                icon: Icons.fingerprint,
                title: 'Biometric Authentication',
                subtitle: 'Use fingerprint or face ID to sign in',
                value: _biometricAuthentication,
                onChanged: (value) {
                  setState(() {
                    _biometricAuthentication = value;
                  });
                },
              ),

              _buildSecurityOptionRow(
                icon: Icons.phone_android_outlined,
                title: 'Two-Factor Authentication',
                subtitle: 'Add an extra layer of security',
                value: _twoFactorAuthentication,
                onChanged: (value) {
                  setState(() {
                    _twoFactorAuthentication = value;
                  });
                },
              ),

              _buildSecurityOptionRow(
                icon: Icons.lock_outline,
                title: 'Auto-Lock',
                subtitle: 'Automatically lock app\nwhen inactive',
                value: _autoLock,
                onChanged: (value) {
                  setState(() {
                    _autoLock = value;
                  });
                },
                isLast: true,
              ),

              const SizedBox(height: 20),

              _buildPasswordCard(),

              const SizedBox(height: 20),

              _buildPrivacyCard(),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return SizedBox(
      height: 48,
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
            'Privacy & Security',
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

  Widget _buildSecurityOptionsHeader() {
    return Container(
      width: double.infinity,
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
          Icon(Icons.shield_outlined, size: 20, color: Colors.white),

          SizedBox(width: 8),

          Text(
            'Security Options',
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

  Widget _buildSecurityOptionRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    bool isLast = false,
  }) {
    return Container(
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
            color: Colors.black.withValues(alpha: 0.06),
            width: 0.5,
          ),
          right: BorderSide(
            color: Colors.black.withValues(alpha: 0.06),
            width: 0.5,
          ),
          bottom: BorderSide(
            color: Colors.black.withValues(alpha: 0.06),
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 22, color: const Color(0xFF4A5565)),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1E2939),
                  ),
                ),
                const SizedBox(height: 3),
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

          Transform.scale(
            scale: 0.85,
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeThumbColor: Colors.white,
              activeTrackColor: const Color(0xFFF20D4F),
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: const Color(0xFFD1D5DB),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordCard() {
    return Container(
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
          const Text(
            'Password',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1E2939),
            ),
          ),

          const SizedBox(height: 56),

          if (!_showPasswordForm) ...[
            const Text(
              'Keep your account secure by using a\nstrong password',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Color(0xFF4A5565),
                height: 1.4,
              ),
            ),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              height: 40,
              child: OutlinedButton.icon(
                onPressed: () {
                  setState(() {
                    _showPasswordForm = true;
                  });
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF1E2939),
                  side: BorderSide(
                    color: Colors.black.withValues(alpha: 0.10),
                    width: 0.5,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: const Icon(Icons.lock_outline, size: 17),
                label: const Text(
                  'Change Password',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ] else ...[
            _buildPasswordField(
              label: 'Current Password',
              hintText: 'Enter current password',
              controller: _currentPasswordController,
              obscureText: _obscureCurrentPassword,
              onToggleVisibility: () {
                setState(() {
                  _obscureCurrentPassword = !_obscureCurrentPassword;
                });
              },
            ),

            const SizedBox(height: 12),
            _buildPasswordField(
              label: 'New Password',
              hintText: 'Enter new password',
              controller: _newPasswordController,
              obscureText: _obscureNewPassword,
              onToggleVisibility: () {
                setState(() {
                  _obscureNewPassword = !_obscureNewPassword;
                });
              },
            ),

            const SizedBox(height: 12),
            _buildPasswordField(
              label: 'Confirm New Password',
              hintText: 'Confirm new password',
              controller: _confirmPasswordController,
              obscureText: _obscureConfirmPassword,
              onToggleVisibility: () {
                setState(() {
                  _obscureConfirmPassword = !_obscureConfirmPassword;
                });
              },
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: OutlinedButton(
                      onPressed: _isUpdatingPassword
                          ? null
                          : () {
                              setState(() {
                                _showPasswordForm = false;

                                _currentPasswordController.clear();
                                _newPasswordController.clear();
                                _confirmPasswordController.clear();

                                _obscureCurrentPassword = true;
                                _obscureNewPassword = true;
                                _obscureConfirmPassword = true;
                              });
                            },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF1E2939),
                        side: BorderSide(
                          color: Colors.black.withValues(alpha: 0.10),
                          width: 0.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [Color(0xFFFF2056), Color(0xFF9810FA)],
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ElevatedButton(
                        onPressed: _isUpdatingPassword ? null : _updatePassword,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          _isUpdatingPassword
                              ? 'Updating...'
                              : 'Update Password',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPasswordField({
    required String label,
    required String hintText,
    required TextEditingController controller,
    required bool obscureText,
    required VoidCallback onToggleVisibility,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1E2939),
          ),
        ),

        const SizedBox(height: 6),

        SizedBox(
          height: 40,
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            style: const TextStyle(fontSize: 13, color: Color(0xFF1E2939)),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(
                fontSize: 13,
                color: Color(0xFF94A3B8),
              ),
              filled: true,
              fillColor: const Color(0xFFF3F4F6),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),

              suffixIcon: IconButton(
                onPressed: onToggleVisibility,
                icon: Icon(
                  obscureText
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  size: 18,
                  color: const Color(0xFF94A3B8),
                ),
              ),

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPrivacyAction({
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: isDestructive
                    ? const Color(0xFFE7000B)
                    : const Color(0xFF1E2939),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPrivacyCard() {
    return Container(
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
          const Text(
            'Privacy',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1E2939),
            ),
          ),

          const SizedBox(height: 28),

          _buildPrivacyAction(
            title: 'View Privacy Policy',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Privacy Policy will be connected later'),
                ),
              );
            },
          ),

          _buildPrivacyAction(
            title: 'Terms of Service',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Terms of Service will be connected later'),
                ),
              );
            },
          ),

          _buildPrivacyAction(
            title: 'Delete Account',
            isDestructive: true,
            onTap: _isDeletingAccount ? () {} : _showDeleteAccountDialog,
          ),
        ],
      ),
    );
  }
}
