// lib/modules/auth/views/login_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Miko Catering - Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Selamat datang di Miko Catering',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),

              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              if (controller.errorMessage.isNotEmpty)
                Text(
                  controller.errorMessage.value,
                  style: const TextStyle(color: Colors.red),
                ),

              const SizedBox(height: 16),

              ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : () {
                        controller.login(
                          emailController.text.trim(),
                          passwordController.text.trim(),
                        );
                      },
                child: controller.isLoading.value
                    ? const CircularProgressIndicator()
                    : const Text('Login'),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : () {
                        controller.register(
                          emailController.text.trim(),
                          passwordController.text.trim(),
                        );
                      },
                child: const Text('Register'),
              ),
            ],
          );
        }),
      ),
    );
  }
}
