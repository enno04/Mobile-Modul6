import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/menu_list_controller.dart';
import '../../../routes/app_routes.dart';

class MenuListView extends GetView<MenuListController> {
  const MenuListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Menu Miko Catering')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(child: Text(controller.errorMessage.value));
        }

        if (controller.items.isEmpty) {
          return const Center(child: Text('Belum ada menu'));
        }

        return ListView.builder(
          itemCount: controller.items.length,
          itemBuilder: (context, index) {
            final item = controller.items[index];

            return ListTile(
              leading: CircleAvatar(child: Text(item.name[0])),
              title: Text(item.name),
              subtitle: Text('Rp ${item.price}'),
              onTap: () {
                Get.toNamed(AppRoutes.menuDetail, arguments: item);
              },
            );
          },
        );
      }),
    );
  }
}
