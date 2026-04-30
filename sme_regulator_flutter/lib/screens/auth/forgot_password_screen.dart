import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import '../../repositories/auth_repository.dart';
import '../../utils/error_handler.dart';
import '../../routes/app_routes.dart';
import '../../core/theme.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  bool _isLoading = false;

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);
    try {
      await context.read<AuthRepository>().forgotPassword(_email.text);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Reset link sent! Check your email.'),
            backgroundColor: Colors.green,
          ),
        );
        // Navigate to Step 2 - Verify OTP
        Navigator.pushNamed(
          context,
          AppRoutes.verifyOtp,
          arguments: {'email': _email.text},
        );
      }
    } catch (e) {
      if (mounted) {
        String errorMessage = 'Something went wrong. Please try again.';
        if (e is DioException) {
          errorMessage = friendlyError(e);
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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
                'Forgot Password',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Enter your registered email',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 24),
              
              // Email input field
              TextFormField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                 decoration: InputDecoration(
                   filled: true,
                   fillColor: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha:0.5),
                   border: const OutlineInputBorder(
                     borderRadius: AppTheme.kInputRadius,
                     borderSide: BorderSide.none,
                   ),
                   focusedBorder: const OutlineInputBorder(
                     borderRadius: AppTheme.kInputRadius,
                     borderSide: BorderSide(color: AppTheme.kPrimaryColor, width: 1.5),
                   ),
                   prefixIcon: Icon(Icons.email_outlined, color: Colors.grey.shade600),
                   hintText: 'Enter your registered email',
                   hintStyle: const TextStyle(color: Colors.black45),
                 ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              
              // Send OTP button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
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
                      const Text('Send OTP'),
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
