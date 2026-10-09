import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _businessController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _businessController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      await ref
          .read(authControllerProvider.notifier)
          .signUp(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
            fullName: _nameController.text.trim(),
            phoneNumber: _phoneController.text.trim(),
            businessName: _businessController.text.trim(),
          );

      if (mounted) {
        final state = ref.read(authControllerProvider);
        if (state.hasError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${'register_failed'.tr()}: ${state.error}')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('register_success'.tr())),
          );
          Navigator.of(context).pop();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text('create_account_title'.tr())),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'full_name_label'.tr(),
                  prefixIcon: const Icon(Icons.person),
                  border: const OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? 'full_name_empty_error'.tr() : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _businessController,
                decoration: InputDecoration(
                  labelText: 'business_name_label'.tr(),
                  prefixIcon: const Icon(Icons.store),
                  border: const OutlineInputBorder(),
                ),
                validator: (v) =>
                    v!.isEmpty ? 'business_name_empty_error'.tr() : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'phone_number_label'.tr(),
                  prefixIcon: const Icon(Icons.phone),
                  border: const OutlineInputBorder(),
                ),
                validator: (v) =>
                    v!.isEmpty ? 'phone_empty_error'.tr() : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'email_label'.tr(),
                  prefixIcon: const Icon(Icons.email),
                  border: const OutlineInputBorder(),
                ),
                validator: (v) =>
                    v!.isEmpty ? 'email_invalid_error'.tr() : null,
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
                validator: (v) => v!.length < 6
                    ? 'password_length_error'.tr()
                    : null,
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                onPressed: authState.isLoading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: authState.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        'register_button'.tr(),
                        style: const TextStyle(fontSize: 16),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
