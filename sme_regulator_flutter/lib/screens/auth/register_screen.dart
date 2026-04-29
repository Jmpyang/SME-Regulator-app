import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import '../../providers/auth_provider.dart';
import '../../routes/app_routes.dart';
import '../../utils/error_handler.dart';
import '../../utils/snackbar_utils.dart';
import '../../core/theme.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  
  // Error states for each field
  String? _nameError;
  String? _emailError;
  String? _phoneError;
  String? _passwordError;
  String? _confirmPasswordError;

  bool _isFormValid() {
    return _name.text.isNotEmpty &&
           _email.text.contains('@') && _email.text.contains('.') &&
           _phone.text.isNotEmpty &&
           _password.text.length >= 8 &&
           _password.text == _confirmPassword.text &&
           _nameError == null &&
           _emailError == null &&
           _phoneError == null &&
           _passwordError == null &&
           _confirmPasswordError == null;
  }

  void _validateAndSubmit() {
    // Clear previous errors
    setState(() {
      _nameError = null;
      _emailError = null;
      _phoneError = null;
      _passwordError = null;
      _confirmPasswordError = null;
    });

    // Validate each field
    bool hasError = false;
    
    if (_name.text.isEmpty) {
      setState(() => _nameError = 'Full name is required');
      hasError = true;
    }
    
    if (!_email.text.contains('@') || !_email.text.contains('.')) {
      setState(() => _emailError = 'Please enter a valid email address');
      hasError = true;
    }
    
    if (_phone.text.isEmpty) {
      setState(() => _phoneError = 'Phone number is required');
      hasError = true;
    }
    
    if (_password.text.length < 8) {
      setState(() => _passwordError = 'Password must be at least 8 characters');
      hasError = true;
    }
    
    if (_password.text != _confirmPassword.text) {
      setState(() => _confirmPasswordError = 'Passwords do not match');
      hasError = true;
    }
    
    if (hasError) return;
    
    _submitForm();
  }

  Future<void> _submitForm() async {
    try {
      final data = {
        'name': _name.text,
        'email': _email.text,
        'phone': _phone.text,
        'password': _password.text,
      };
      
      final success = await context.read<AuthProvider>().register(data);
      if (success && mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.verifyOtp, arguments: _email.text);
      }
    } catch (e) {
      if (mounted) {
        String errorMessage = 'Registration failed. Please try again.';
        if (e is DioException) {
          errorMessage = friendlyError(e);
          debugPrint('Register DioException: ${e.response?.data} - ${e.message}');
        } else {
          debugPrint('Register unexpected error: $e');
        }
        SnackBarUtils.showError(context, errorMessage);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthProvider>().isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Full Name field
                TextFormField(
                  controller: _name,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5),
                    border: const OutlineInputBorder(
                      borderRadius: AppTheme.kInputRadius,
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: AppTheme.kInputRadius,
                      borderSide: BorderSide(color: AppTheme.kPrimaryColor, width: 1.5),
                    ),
                    prefixIcon: Icon(Icons.person_outlined, color: Colors.grey.shade400),
                    hintText: 'e.g. John Doe',
                    hintStyle: TextStyle(color: Colors.grey.shade400),
                    errorText: _nameError,
                  ),
                  onChanged: (value) {
                    if (_nameError != null) {
                      setState(() => _nameError = null);
                    }
                  },
                ),
                const SizedBox(height: 24),

                // Email field
                TextFormField(
                  controller: _email,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5),
                    border: const OutlineInputBorder(
                      borderRadius: AppTheme.kInputRadius,
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: AppTheme.kInputRadius,
                      borderSide: BorderSide(color: AppTheme.kPrimaryColor, width: 1.5),
                    ),
                    prefixIcon: Icon(Icons.email_outlined, color: Colors.grey.shade400),
                    hintText: 'e.g. john@example.com',
                    hintStyle: TextStyle(color: Colors.grey.shade400),
                    errorText: _emailError,
                  ),
                  onChanged: (value) {
                    if (_emailError != null) {
                      setState(() => _emailError = null);
                    }
                  },
                ),
                const SizedBox(height: 24),

                // Phone field
                TextFormField(
                  controller: _phone,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5),
                    border: const OutlineInputBorder(
                      borderRadius: AppTheme.kInputRadius,
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: AppTheme.kInputRadius,
                      borderSide: BorderSide(color: AppTheme.kPrimaryColor, width: 1.5),
                    ),
                    prefixIcon: Icon(Icons.phone_outlined, color: Colors.grey.shade400),
                    hintText: '+1 (555) 123-4567',
                    hintStyle: TextStyle(color: Colors.grey.shade400),
                    helperText: 'Used for SMS compliance alerts',
                    errorText: _phoneError,
                  ),
                  onChanged: (value) {
                    if (_phoneError != null) {
                      setState(() => _phoneError = null);
                    }
                  },
                ),
                const SizedBox(height: 24),

                // Password field
                TextFormField(
                  controller: _password,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5),
                    border: const OutlineInputBorder(
                      borderRadius: AppTheme.kInputRadius,
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: AppTheme.kInputRadius,
                      borderSide: BorderSide(color: AppTheme.kPrimaryColor, width: 1.5),
                    ),
                    prefixIcon: Icon(Icons.lock_outlined, color: Colors.grey.shade400),
                    hintText: 'Min. 8 characters',
                    hintStyle: TextStyle(color: Colors.grey.shade400),
                    helperText: 'Use letters, numbers, and symbols',
                    errorText: _passwordError,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  onChanged: (value) {
                    if (_passwordError != null) {
                      setState(() => _passwordError = null);
                    }
                    if (_confirmPassword.text.isNotEmpty) {
                      setState(() {});
                    }
                  },
                ),
                const SizedBox(height: 24),

                // Confirm Password field
                TextFormField(
                  controller: _confirmPassword,
                  obscureText: _obscureConfirmPassword,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5),
                    border: const OutlineInputBorder(
                      borderRadius: AppTheme.kInputRadius,
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: AppTheme.kInputRadius,
                      borderSide: BorderSide(color: AppTheme.kPrimaryColor, width: 1.5),
                    ),
                    prefixIcon: Icon(Icons.lock_outlined, color: Colors.grey.shade400),
                    hintText: 'Confirm password',
                    hintStyle: TextStyle(color: Colors.grey.shade400),
                    helperText: _password.text == _confirmPassword.text && _confirmPassword.text.isNotEmpty
                        ? 'Passwords match ✓'
                        : _confirmPassword.text.isNotEmpty
                            ? 'Passwords do not match'
                            : null,
                    helperStyle: TextStyle(
                      color: _password.text == _confirmPassword.text && _confirmPassword.text.isNotEmpty
                          ? Colors.green
                          : Colors.red,
                    ),
                    errorText: _confirmPasswordError,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                  ),
                  onChanged: (value) {
                    if (_confirmPasswordError != null) {
                      setState(() => _confirmPasswordError = null);
                    }
                  },
                ),
                const SizedBox(height: 24),

                // Register button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isFormValid() ? _validateAndSubmit : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isFormValid() ? AppTheme.kPrimaryColor : Colors.grey,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      shape: const RoundedRectangleBorder(borderRadius: AppTheme.kButtonRadius),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (isLoading)
                          const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(color: Colors.white),
                          ),
                        const Text('Register'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Login link at bottom
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, AppRoutes.login),
                      child: const Text(
                        "Sign in",
                        style: TextStyle(
                          color: AppTheme.kPrimaryColor,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
