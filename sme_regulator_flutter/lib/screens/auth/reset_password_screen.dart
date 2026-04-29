import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../repositories/auth_repository.dart';
import '../../routes/app_routes.dart';
import '../../core/theme.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _otp = TextEditingController();
  final _newPassword = TextEditingController();
  final _confirmPassword = TextEditingController();
  late String _email;
  bool _isLoading = false;
  bool _passwordsMatch = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _email = ModalRoute.of(context)?.settings.arguments as String? ?? '';
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);
    try {
      await context.read<AuthRepository>().resetPassword(_email, _otp.text, _newPassword.text);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password reset! Please log in.'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (r) => false);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Reset failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  bool _validatePasswords() {
    if (_newPassword.text.isEmpty || _confirmPassword.text.isEmpty) return false;
    if (_newPassword.text != _confirmPassword.text) {
      _passwordsMatch = false;
      return false;
    }
    _passwordsMatch = true;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Reset Password',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Enter your new password below',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 32),
              
              // New Password field
              TextFormField(
                controller: _newPassword,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                  border: const OutlineInputBorder(
                    borderRadius: AppTheme.kInputRadius,
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: AppTheme.kInputRadius,
                    borderSide: BorderSide(color: AppTheme.kPrimaryColor, width: 1.5),
                  ),
                  prefixIcon: Icon(Icons.lock_outlined, color: Colors.grey.shade400),
                  hintText: 'Enter new password',
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 24),

              // Confirm Password field
              TextFormField(
                controller: _confirmPassword,
                obscureText: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                  border: const OutlineInputBorder(
                    borderRadius: AppTheme.kInputRadius,
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: AppTheme.kInputRadius,
                    borderSide: BorderSide(color: AppTheme.kPrimaryColor, width: 1.5),
                  ),
                  prefixIcon: Icon(Icons.lock_outlined, color: Colors.grey.shade400),
                  hintText: 'Confirm new password',
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  helperText: _passwordsMatch 
                    ? 'Passwords match ✓'
                    : 'Passwords do not match',
                  helperStyle: TextStyle(
                    color: _passwordsMatch ? Colors.green : Colors.red,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Reset button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _validatePasswords() ? _submit : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.kPrimaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    shape: const RoundedRectangleBorder(borderRadius: AppTheme.kButtonRadius),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_isLoading)
                        const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(color: Colors.white),
                        ),
                      const Text('Reset Password'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
