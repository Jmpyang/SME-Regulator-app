import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../routes/app_routes.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();

  void _register() async {
    final data = {
      'name': _name.text,
      'email': _email.text,
      'phone': _phone.text,
      'password': _password.text,
    };
    
    final success = await context.read<AuthProvider>().register(data);
    if (success && mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.verifyOtp, arguments: _email.text);
    } else if (mounted) {
      final err = context.read<AuthProvider>().error;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err ?? 'Error registering')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthProvider>().isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextField(controller: _name, decoration: const InputDecoration(labelText: 'Full Name')),
            const SizedBox(height: 16),
            TextField(controller: _email, decoration: const InputDecoration(labelText: 'Email')),
            const SizedBox(height: 16),
            TextField(controller: _phone, decoration: const InputDecoration(labelText: 'Phone Number')),
            const SizedBox(height: 16),
            TextField(controller: _password, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
            const SizedBox(height: 24),
            isLoading
                ? const CircularProgressIndicator()
                : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _register,
                      child: const Text('Register'),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
