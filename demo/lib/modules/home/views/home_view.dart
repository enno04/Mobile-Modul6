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

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final notificationController = Get.put(NotificationController());
    final userEmail = authController.user.value?.email?.split('@')[0] ?? 'Tamu';

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          // 1. MODERN APP BAR & GREETING
          SliverAppBar(
            expandedHeight: 120,
            floating: true,
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              title: Row(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Miko Catering',
                          style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 18)),
                      Text('Halo, $userEmail!',
                          style: const TextStyle(color: Colors.black54, fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              _buildNotificationIcon(notificationController, context),
              IconButton(
                icon: const Icon(Icons.logout, color: Colors.grey),
                onPressed: authController.logout,
              ),
            ],
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 2. SEARCH BAR (Dummy)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        hintText: "Mau makan apa hari ini?",
                        prefixIcon: Icon(Icons.search),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 3. LOKASI BAR (Minimalist)
                  _buildLocationCard(),

                  const SizedBox(height: 24),

                  // 4. PROMO BANNER
                  _buildPromoCard(),

                  const SizedBox(height: 24),

                  // 5. QUICK MENU / CATEGORIES
                  const Text('Kategori Terpopuler',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  _buildCategories(),

                  const SizedBox(height: 24),

                  // 6. ACTION BUTTONS (Dibuat Grid atau Card)
                  const Text('Layanan Kami',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  _buildMainActions(),
                ],
              ),
            ),
          ),
        ],
      ),
      // Pindahkan Cart ke FloatingActionButton atau BottomNav
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.toNamed('/cart'),
        backgroundColor: Colors.orange,
        icon: const Icon(Icons.shopping_cart),
        label: const Text("Keranjang"),
      ),
    );
  }

  // Widget Helper: Location Card
  Widget _buildLocationCard() {
    return InkWell(
      onTap: () => Get.to(() => const GpsLocationView()),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.orange.shade50,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.location_on, color: Colors.orange),
            const SizedBox(width: 8),
            const Expanded(
              child: Text("Kirim ke: Lokasi Terkini Anda...",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.w500)),
            ),
            const Icon(Icons.chevron_right, color: Colors.orange),
          ],
        ),
      ),
    );
  }

  // Widget Helper: Promo Card
  Widget _buildPromoCard() {
    return Container(
      width: double.infinity,
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(colors: [Colors.orange, Colors.deepOrange]),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20, bottom: -20,
            child: Icon(Icons.fastfood, size: 150, color: Colors.white.withOpacity(0.2)),
          ),
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Diskon Akhir Bulan!", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                Text("Potongan hingga 30% untuk\nsemua menu catering.", style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget Helper: Categories
  Widget _buildCategories() {
    List<Map<String, dynamic>> cats = [
      {'name': 'Nasi Box', 'icon': Icons.inventory_2},
      {'name': 'Prasmanan', 'icon': Icons.flatware},
      {'name': 'Minuman', 'icon': Icons.local_drink},
      {'name': 'Snack', 'icon': Icons.bakery_dining},
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: cats.map((c) => Column(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.white,
            child: Icon(c['icon'], color: Colors.orange),
          ),
          const SizedBox(height: 8),
          Text(c['name'], style: const TextStyle(fontSize: 12)),
        ],
      )).toList(),
    );
  }

  Widget _buildMainActions() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 2.5,
      children: [
        _actionCard('Daftar Menu', Icons.restaurant_menu, () => Get.toNamed('/menu')),
        _actionCard('Pesanan saya', Icons.receipt_long, () => Get.toNamed('/orders')),
      ],
    );
  }

  Widget _actionCard(String title, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.orange, size: 20),
            const SizedBox(width: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationIcon(notificationController, context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        IconButton(
          // Menggunakan notifications_outlined agar terlihat lebih clean
          icon: const Icon(Icons.notifications_outlined, color: Colors.black87, size: 28),
          onPressed: () => _showNotificationSheet(context),
          splashRadius: 24,
        ),


        Obx(() {
          final count = notificationController.unreadCount.value;
          if (count == 0) return const SizedBox();

          return Positioned(
            right: 8, // Menggeser posisi agar lebih pas di sudut ikon
            top: 8,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.redAccent,
                shape: BoxShape.circle,
                // Menambahkan border putih agar badge lebih kontras dari ikon di bawahnya
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  )
                ],
              ),
              constraints: const BoxConstraints(
                minWidth: 18,
                minHeight: 18,
              ),
              child: Center(
                child: Text(
                  // Jika lebih dari 9, tampilkan 9+ agar tidak merusak bentuk lingkaran
                  count > 9 ? '9+' : '$count',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.bold
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}

void _showNotificationSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent, // Agar rounded corner terlihat jelas
    builder: (_) => DraggableScrollableSheet(
      initialChildSize: 0.7, // Muncul setinggi 70% layar
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (_, scrollController) => NotificationSheet(scrollController: scrollController),
    ),
  );
}
