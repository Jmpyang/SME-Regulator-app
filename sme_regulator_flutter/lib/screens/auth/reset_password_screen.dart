import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../repositories/auth_repository.dart';
import '../../routes/app_routes.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _otp = TextEditingController();
  final _newPassword = TextEditingController();
  late String _email;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _email = ModalRoute.of(context)?.settings.arguments as String? ?? '';
  }

  void _submit() async {
    setState(() => _isLoading = true);
    try {
      await context.read<AuthRepository>().resetPassword(_email, _otp.text, _newPassword.text);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password Reset Successful')));
        Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (r) => false);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reset Password')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text('Resetting password for $_email'),
            const SizedBox(height: 16),
            TextField(controller: _otp, decoration: const InputDecoration(labelText: 'OTP')),
            const SizedBox(height: 16),
            TextField(
              controller: _newPassword,
              decoration: const InputDecoration(labelText: 'New Password'),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(onPressed: _submit, child: const Text('Set New Password')),
          ],
        ),
      ),
    );
  }
}
