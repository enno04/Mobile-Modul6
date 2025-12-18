// lib/main.dart
import 'package:demo/data/services/notification_service.dart';
import 'package:demo/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'routes/app_routes.dart';
import 'routes/app_pages.dart';
import 'package:demo/cart/controllers/cart_controller.dart';
import 'modules/auth/controllers/auth_controller.dart';
import 'package:demo/data/services/theme_service.dart';
import 'modules/auth/views/login_view.dart';
import 'modules/home/views/home_view.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:demo/orders/controllers/orders_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Load .env
  await dotenv.load(fileName: ".env");

  await NotificationService.init();

  // Init Supabase
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );
  await Hive.initFlutter();
  await Hive.openBox('cart_box'); //
  // Init ThemeService
  final themeService = ThemeService();
  await themeService.init();

  runApp(MyApp(themeService: themeService));
}

class MyApp extends StatelessWidget {
  final ThemeService themeService;

  const MyApp({super.key, required this.themeService});

  @override
  Widget build(BuildContext context) {
    // Daftarkan ThemeService & AuthController ke GetX
    Get.put(themeService);
    Get.put(AuthController()); // kita buat sebentar lagi
    Get.put(CartController(), permanent: true);
    Get.put(OrdersController(), permanent: true);
    return Obx(() {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Miko Catering',
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        themeMode: themeService.themeMode.value,
        initialRoute: AppRoutes.splash,
        getPages: AppPages.pages,
      );
    });
  }
}

/// Widget kecil untuk mengarahkan user:
/// - kalau belum login -> LoginView
/// - kalau sudah login -> HomeView
class AuthGate extends GetView<AuthController> {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.user.value == null) {
        return const LoginView();
      } else {
        return const HomeView();
      }
    });
  }
}
