import 'package:demo/modules/home/controllers/notification_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationSheet extends StatelessWidget {
  const NotificationSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NotificationController>();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Notifikasi',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Get.back(),
              ),
            ],
          ),

          const SizedBox(height: 8),
          const Divider(),

          // Content
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: Obx(() {
              if (controller.notifications.isEmpty) {
                return const Center(child: Text('Belum ada notifikasi'));
              }

              return ListView.separated(
                itemCount: controller.notifications.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (_, index) {
                  final n = controller.notifications[index];
                  final isRead = n['is_read'] == true;

                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      n['title'],
                      style: TextStyle(
                        fontWeight: isRead
                            ? FontWeight.normal
                            : FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      n['body'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () {
                      controller.markAsRead(n['id']);
                      Get.back();

                      // contoh routing
                      if (n['type'] == 'order_pending') {
                        Get.toNamed('/order');
                      }
                    },
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
