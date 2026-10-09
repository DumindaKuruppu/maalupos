import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_provider.dart';
import 'register_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      await ref
          .read(authControllerProvider.notifier)
          .signIn(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );

      if (mounted) {
        final state = ref.read(authControllerProvider);
        if (state.hasError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${'login_failed'.tr()}: ${state.error}')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.phishing, size: 80, color: Colors.blue),
                const SizedBox(height: 10),
                Text(
                  'app_title'.tr(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'subtitle_desc'.tr(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 35),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'email_label'.tr(),
                    prefixIcon: const Icon(Icons.email),
                    border: const OutlineInputBorder(),
                  ),
                  validator: (v) =>
                      v!.isEmpty ? 'email_empty_error'.tr() : null,
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'password_label'.tr(),
                    prefixIcon: const Icon(Icons.lock),
                    border: const OutlineInputBorder(),
                  ),
                  validator: (v) =>
                      v!.isEmpty ? 'password_empty_error'.tr() : null,
                ),
                const SizedBox(height: 25),
                ElevatedButton(
                  onPressed: authState.isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: authState.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          'login_button'.tr(),
                          style: const TextStyle(fontSize: 16),
                        ),
                ),
                const SizedBox(height: 15),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const RegisterScreen()),
                    );
                  },
                  child: Text('register_here'.tr()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
