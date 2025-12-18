import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:demo/orders/controllers/orders_controller.dart';
import '../../../routes/app_routes.dart';

class OrdersListView extends GetView<OrdersController> {
  const OrdersListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pesanan Saya')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(child: Text(controller.errorMessage.value));
        }

        if (controller.orders.isEmpty) {
          return const Center(
            child: Text('Belum ada pesanan', style: TextStyle(fontSize: 18)),
          );
        }

        return ListView.builder(
          itemCount: controller.orders.length,
          itemBuilder: (context, index) {
            final order = controller.orders[index];

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                title: Text(
                  'Status: ${order.status}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  'Tanggal: ${order.createdAt.toLocal()}\n'
                  'Total: Rp ${order.totalPrice}',
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Get.toNamed(AppRoutes.orderDetail, arguments: order);
                },
              ),
            );
          },
        );
      }),
    );
  }
}
