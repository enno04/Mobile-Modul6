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
    final MenuItem item = Get.arguments;
    final CartController cart = Get.find<CartController>();

    return Scaffold(
      appBar: AppBar(title: Text(item.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Placeholder / Actual Image
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey.shade200,
                image: item.imageUrl.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(item.imageUrl),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: item.imageUrl.isEmpty
                  ? const Center(child: Icon(Icons.fastfood, size: 50))
                  : null,
            ),

            const SizedBox(height: 20),

            Text(
              item.name,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Text(
              "Rp ${item.price}",
              style: const TextStyle(
                fontSize: 22,
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              item.description.isEmpty
                  ? "Tidak ada deskripsi"
                  : item.description,
              style: const TextStyle(fontSize: 16, height: 1.4),
            ),

            const SizedBox(height: 30),

            // Quantity selector
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    if (qty > 1) {
                      setState(() {
                        qty--;
                      });
                    }
                  },
                  icon: const Icon(Icons.remove_circle_outline),
                ),
                Text(qty.toString(), style: const TextStyle(fontSize: 20)),
                IconButton(
                  onPressed: () {
                    setState(() {
                      qty++;
                    });
                  },
                  icon: const Icon(Icons.add_circle_outline),
                ),
              ],
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  cart.addItem({
                    "menu_item_id": item.id,
                    "name": item.name,
                    "price": item.price,
                    "qty": qty,
                  });

                  Get.snackbar(
                    "Berhasil",
                    "Ditambahkan ke keranjang!",
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text(
                  "Tambah ke Keranjang",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
