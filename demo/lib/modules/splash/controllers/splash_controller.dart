// lib/modules/splash/controllers/splash_controller.dart
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../routes/app_routes.dart';

class SplashController extends GetxController {
  final SupabaseClient _client = Supabase.instance.client;

  @override
  void onReady() {
    super.onReady();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    try {
      // animasi loading 2 detik
      await Future.delayed(const Duration(seconds: 2));

      final user = _client.auth.currentUser;

      if (user == null) {
        Get.offAllNamed(AppRoutes.login);
      } else {
        Get.offAllNamed(AppRoutes.home);
      }
    } catch (e) {
      // Kalau ada error (misal Supabase belum init / .env salah),
      // kamu akan lihat ini, bukan stuck di splash.
      Get.snackbar(
        'Error',
        'Gagal cek login: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
