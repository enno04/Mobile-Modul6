import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';

class CartView extends GetView<CartController> {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Keranjang")),
      body: Obx(() {
        if (controller.cartItems.isEmpty) {
          return const Center(
            child: Text(
              "Keranjang masih kosong",
              style: TextStyle(fontSize: 18),
            ),
          );
        }

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: controller.cartItems.length,
                itemBuilder: (context, index) {
                  final item = controller.cartItems[index];

                  return ListTile(
                    leading: CircleAvatar(child: Text(item['name'][0])),
                    title: Text(item['name']),
                    subtitle: Text("Rp ${item['price']} x ${item['qty']}"),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        controller.removeItem(item['menu_item_id']);
                      },
                    ),
                  );
                },
              ),
            ),

            // Total & Checkout Button
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.grey.shade200),
              child: Column(
                children: [
                  Obx(() {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Total:",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Rp ${controller.totalPrice}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    );
                  }),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: controller.isProcessing.value
                        ? null
                        : () => controller.checkout(),
                    child: controller.isProcessing.value
                        ? const CircularProgressIndicator()
                        : const Text("Checkout"),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
