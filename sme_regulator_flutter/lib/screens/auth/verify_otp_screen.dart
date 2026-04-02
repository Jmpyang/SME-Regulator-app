import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../routes/app_routes.dart';

class VerifyOtpScreen extends StatefulWidget {
  const VerifyOtpScreen({super.key});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final _otp = TextEditingController();
  late String _email;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _email = ModalRoute.of(context)?.settings.arguments as String? ?? '';
  }

  void _verify() async {
    final success = await context.read<AuthProvider>().verifyOtp(_email, _otp.text);
    if (success && mounted) {
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.dashboard, (r) => false);
    } else if (mounted) {
      final err = context.read<AuthProvider>().error;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err ?? 'Invalid OTP')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthProvider>().isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Verify OTP')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text('Enter the OTP sent to $_email'),
            const SizedBox(height: 24),
            TextField(
              controller: _otp,
              decoration: const InputDecoration(labelText: 'OTP'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            isLoading
                ? const CircularProgressIndicator()
                : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _verify,
                      child: const Text('Verify'),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
