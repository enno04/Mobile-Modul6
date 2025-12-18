import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:demo/data/services/auth_service.dart';
import '../../../routes/app_routes.dart';

class AuthController extends GetxController {
  final authService = Get.put(AuthService());
  final user = Rxn<User>();
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    user.value = authService.currentUser;

    // Dengarkan perubahan auth (login / logout)
    authService.authStateChanges.listen((data) {
      final session = data.session;
      user.value = session?.user;
    });
  }

  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await authService.signIn(email, password);

      // kalau login berhasil, session tidak null -> pindah ke Home
      if (result.session != null) {
        Get.offAllNamed(AppRoutes.home);
      }
    } on AuthException catch (e) {
      errorMessage.value = e.message;
    } catch (e) {
      errorMessage.value = 'Terjadi kesalahan. Coba lagi.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register(String email, String password) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      await authService.signUp(email, password);
      // setelah register bisa langsung login atau tetap di halaman ini
      Get.snackbar('Berhasil', 'Registrasi berhasil, silakan login.');
    } on AuthException catch (e) {
      errorMessage.value = e.message;
    } catch (e) {
      errorMessage.value = 'Terjadi kesalahan. Coba lagi.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await authService.signOut();
    user.value = null;
    Get.offAllNamed(AppRoutes.login);
  }
}
