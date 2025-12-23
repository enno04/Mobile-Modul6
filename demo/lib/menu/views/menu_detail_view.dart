import 'package:demo/data/models/CartItem.dart';
import 'package:demo/data/models/MenuItems.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/menu_item_model.dart';
import '../../cart/controllers/cart_controller.dart';

class MenuDetailView extends StatefulWidget {
  const MenuDetailView({super.key});

  @override
  State<MenuDetailView> createState() => _MenuDetailViewState();
}

class _MenuDetailViewState extends State<MenuDetailView> {
  int qty = 1;

  @override
  Widget build(BuildContext context) {
    // Pastikan casting model sesuai dengan nama class di project kamu (contoh: MenuItem atau RestaurantItem)
    final MenuItems item = Get.arguments;
    final CartController cart = Get.find<CartController>();

    return Scaffold(
      backgroundColor: Colors.white,
      // Menggunakan CustomScrollView untuk efek header yang modern
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // 1. HEADER IMAGE
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                leading: CircleAvatar(
                  backgroundColor: Colors.white.withOpacity(0.7),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Get.back(),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Hero(
                    tag: 'menu-${item.itemID}', // Animasi hero dari list ke detail
                    child: Image.network(
                      item.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.grey[200],
                        child: const Icon(Icons.fastfood, size: 100, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
              ),

              // 2. CONTENT SECTION
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              item.itemName,
                              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Text(
                            "Rp ${item.itemPrice}",
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: Colors.orange
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.storefront, size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            item.restaurantName,
                            style: const TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        "Deskripsi",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item.itemDescription.isEmpty
                            ? "Menu lezat buatan Miko Catering yang disiapkan dengan bahan berkualitas tinggi."
                            : item.itemDescription,
                        style: TextStyle(fontSize: 15, color: Colors.grey[700], height: 1.6),
                      ),
                      const SizedBox(height: 100), // Memberi ruang agar tidak tertutup bottom bar
                    ],
                  ),
                ),
              ),
            ],
          ),

          // 3. STICKY BOTTOM BAR (Quantity & Add to Cart)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Quantity Selector
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        _buildQtyBtn(Icons.remove, () {
                          if (qty > 1) setState(() => qty--);
                        }),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text("$qty", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                        _buildQtyBtn(Icons.add, () => setState(() => qty++)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Add to Cart Button
                  Expanded(
                    child: SizedBox(
                      height: 54,
                      child: ElevatedButton(
                        onPressed: () {
                          cart.addItem(
                            CartItem(
                              id: item.itemID,
                              name: item.itemName,
                              price: item.itemPrice,
                              qty: qty,
                              image: item.imageUrl,
                            ),
                          );
                          Get.snackbar(
                            "Berhasil",
                            "${item.itemName} ditambahkan ke keranjang",
                            snackPosition: SnackPosition.TOP,
                            backgroundColor: Colors.orange,
                            colorText: Colors.white,
                            margin: const EdgeInsets.all(10),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text("Tambah", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQtyBtn(IconData icon, VoidCallback onTap) {
    return IconButton(
      icon: Icon(icon, size: 20, color: Colors.black87),
      onPressed: onTap,
    );
  }
}