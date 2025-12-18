// lib/routes/app_pages.dart
import 'package:get/get.dart';

import '../modules/splash/views/splash_view.dart';
import '../modules/auth/views/login_view.dart';
import '../modules/home/views/home_view.dart';
import 'package:demo/menu/views/menu_list_view.dart';
import 'package:demo/cart/views/cart_view.dart';
import 'package:demo/orders/views/orders_list_view.dart';
import '../modules/splash/controllers/splash_controller.dart';
import 'app_routes.dart';
import 'package:demo/orders/views/order_detail_view.dart';

import 'package:demo/menu/controllers/menu_list_controller.dart';
import 'package:demo/menu/views/menu_detail_view.dart';

class AppPages {
  static final pages = <GetPage>[
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashView(),
      binding: BindingsBuilder(() {
        Get.put(SplashController());
      }),
    ),
    GetPage(name: AppRoutes.login, page: () => const LoginView()),
    GetPage(name: AppRoutes.home, page: () => const HomeView()),
    GetPage(name: AppRoutes.splash, page: () => const SplashView()),
    GetPage(name: AppRoutes.orderDetail, page: () => const OrderDetailView()),
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashView(),
      binding: BindingsBuilder(() {
        Get.put(SplashController());
      }),
    ),
    GetPage(name: AppRoutes.login, page: () => const LoginView()),
    GetPage(name: AppRoutes.home, page: () => const HomeView()),
    GetPage(name: AppRoutes.cart, page: () => const CartView()),
    GetPage(name: AppRoutes.orders, page: () => const OrdersListView()),
    GetPage(name: AppRoutes.menuDetail, page: () => const MenuDetailView()),
    GetPage(
      name: AppRoutes.menu,
      page: () => const MenuListView(),
      binding: BindingsBuilder(() {
        Get.put(MenuListController());
      }),
    ),
  ];
}
