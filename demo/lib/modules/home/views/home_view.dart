import 'package:demo/core/widgets/dropdown_notification.dart';
import 'package:demo/modules/home/controllers/notification_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Import Controller dan Service
import 'package:demo/data/services/theme_service.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../../routes/app_routes.dart';

// Import View Peta GPS (Pastikan path package ini sesuai dengan nama project Anda 'demo')
import 'package:demo/modules/gps_location/views/gps_location_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = Get.find<ThemeService>();
    final authController = Get.find<AuthController>();
    final notificationController = Get.put(NotificationController());

    // Catatan: Baris homeController dihapus karena tombol sekarang
    // langsung mengarah ke GpsLocationView tanpa perlu controller ini di sini.

    final userEmail = authController.user.value?.email ?? 'Tamu';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Miko Catering'),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {
                  notificationController.fetchNotifications();
                  _showNotificationSheet(context);
                },
              ),
              Obx(() {
                final count = notificationController.unreadCount.value;
                if (count == 0) return const SizedBox();

                return Positioned(
                  right: 8,
                  top: 8,
                  child: CircleAvatar(
                    radius: 7,
                    backgroundColor: Colors.red,
                    child: Text(
                      '$count',
                      style: const TextStyle(fontSize: 10, color: Colors.white),
                    ),
                  ),
                );
              }),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: themeService.toggleTheme,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: authController.logout,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Halo, $userEmail',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Selamat datang di Miko Catering.\nSilakan pilih menu yang kamu inginkan.',
              ),

              const SizedBox(height: 20),

              // ============================================
              // --- MULAI BAGIAN TOMBOL LOKASI (GPS) ---
              // ============================================
              GestureDetector(
                onTap: () {
                  // Arahkan ke halaman Peta GPS
                  Get.to(() => const GpsLocationView());
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.blue),
                  ),
                  child: Row(
                    children: [
                      // Ikon Peta Bulat
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.map,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Teks Keterangan
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Lokasi Terkini",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              "Klik untuk lihat di Peta Full",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      // Panah kecil di kanan
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.blue,
                      ),
                    ],
                  ),
                ),
              ),

              // ============================================
              // --- AKHIR BAGIAN TOMBOL LOKASI ---
              // ============================================
              const SizedBox(height: 24),

              // Tombol ke menu
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => Get.toNamed(AppRoutes.menu),
                  icon: const Icon(Icons.restaurant_menu),
                  label: const Text('Lihat Menu'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Tombol ke keranjang
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => Get.toNamed(AppRoutes.cart),
                  icon: const Icon(Icons.shopping_cart),
                  label: const Text('Keranjang'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Tombol ke pesanan
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => Get.toNamed(AppRoutes.orders),
                  icon: const Icon(Icons.receipt_long),
                  label: const Text('Riwayat Pesanan'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void _showNotificationSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (_) {
      return const NotificationSheet();
    },
  );
}
