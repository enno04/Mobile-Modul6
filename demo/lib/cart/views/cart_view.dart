import 'package:demo/data/models/CartItem.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';

class CartView extends GetView<CartController> {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Keranjang Saya",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.cartItems.isEmpty) {
          return _buildEmptyState();
        }

        return Column(
          children: [
            // 1. LIST ITEM KERANJANG
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: controller.cartItems.length,
                itemBuilder: (context, index) {
                  final CartItem item = controller.cartItems[index];
                  return _buildCartItem(item);
                },
              ),
            ),

            // 2. RINGKASAN PEMBAYARAN & TOMBOL PESAN
            _buildCheckoutSection(),
          ],
        );
      }),
    );
  }

  // --- WIDGET COMPONENTS ---

  Widget _buildCartItem(CartItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          // Gambar Thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              item.image,
              width: 70,
              height: 70,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 70,
                height: 70,
                color: Colors.grey[100],
                child: const Icon(Icons.fastfood, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Info Teks
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text("Rp ${item.price}",
                    style: const TextStyle(
                        color: Colors.orange, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                // Kontrol Quantity
                Row(
                  children: [
                    _qtyAction(Icons.remove, () {
                      if (item.qty > 1) {
                        controller.updateQuantity(item.id, item.qty - 1);
                      }
                    }),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text("${item.qty}",
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    _qtyAction(Icons.add, () {
                      controller.updateQuantity(item.id, item.qty + 1);
                    }),
                  ],
                ),
              ],
            ),
          ),
          // Hapus Item
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
            onPressed: () => controller.removeItem(item.id),
          ),
        ],
      ),
    );
  }

  Widget _qtyAction(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 16, color: Colors.black87),
      ),
    );
  }

  // --- BAGIAN CHECKOUT (MODIFIKASI UTAMA) ---
  Widget _buildCheckoutSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5)),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Total Pembayaran",
                    style: TextStyle(fontSize: 16, color: Colors.grey)),
                Text("Rp ${controller.totalPrice}",
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange)),
              ],
            ),
            const SizedBox(height: 20),
            
            // TOMBOL PESAN -> MEMUNCULKAN BOTTOM SHEET
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                // Jika keranjang kosong tombol mati, jika isi munculkan PaymentBottomSheet
                onPressed: controller.cartItems.isEmpty 
                    ? null 
                    : () {
                        Get.bottomSheet(
                          PaymentBottomSheet(),
                          isScrollControlled: true, // Agar tinggi menyesuaikan konten
                          backgroundColor: Colors.transparent, // Transparan agar sudut membulat terlihat
                        );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: const Text("Pesan Sekarang",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_basket_outlined,
              size: 100, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text("Wah, keranjangmu kosong!",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54)),
          const SizedBox(height: 8),
          const Text("Yuk, cari menu lezat untukmu!",
              style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Get.back(),
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange.shade50,
                foregroundColor: Colors.orange,
                elevation: 0),
            child: const Text("Lihat Menu"),
          ),
        ],
      ),
    );
  }
}

// =========================================================
// CLASS BARU: PAYMENT BOTTOM SHEET (DI LUAR CARTVIEW)
// =========================================================

class PaymentBottomSheet extends StatelessWidget {
  // Kita ambil controller yang sudah ada menggunakan Get.find()
  final CartController controller = Get.find<CartController>();

  PaymentBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle Bar
          Center(
            child: Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10)),
            ),
          ),
          const SizedBox(height: 24),

          const Text("Metode Pembayaran",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),

          // Pilihan QRIS
          Obx(() => _buildPaymentOption(
                id: 'qris',
                title: "QRIS",
                subtitle: "Scan & Bayar Instan",
                icon: Icons.qr_code_scanner_rounded,
                isSelected: controller.selectedPaymentMethod.value == 'qris',
              )),

          const SizedBox(height: 12),

          // Pilihan Transfer
          Obx(() => _buildPaymentOption(
                id: 'transfer',
                title: "Bank Transfer",
                subtitle: "BCA, Mandiri, BRI",
                icon: Icons.account_balance_rounded,
                isSelected: controller.selectedPaymentMethod.value == 'transfer',
              )),

          const SizedBox(height: 30),

          // Tombol Bayar Akhir
          SizedBox(
            width: double.infinity,
            height: 56,
            child: Obx(() => ElevatedButton(
                  // Panggil fungsi processPayment di controller
                  onPressed: controller.isProcessing.value
                      ? null
                      : () => controller.processPayment(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: controller.isProcessing.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.lock_outline, size: 20),
                            const SizedBox(width: 8),
                            Text("Bayar Rp ${controller.totalPrice}",
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                          ],
                        ),
                )),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption({
    required String id,
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => controller.selectPaymentMethod(id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange.withOpacity(0.1) : Colors.white,
          border: Border.all(
              color: isSelected ? Colors.orange : Colors.grey.shade200,
              width: 2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected ? Colors.orange : Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: Icon(icon,
                  color: isSelected ? Colors.white : Colors.grey, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: isSelected ? Colors.orange[900] : Colors.black87)),
                  Text(subtitle,
                      style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: Colors.orange),
          ],
        ),
      ),
    );
  }
}