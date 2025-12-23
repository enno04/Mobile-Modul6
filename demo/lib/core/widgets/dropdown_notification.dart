import 'package:demo/modules/home/controllers/notification_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationSheet extends StatelessWidget {
  final ScrollController scrollController;
  const NotificationSheet({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {

    final notificationController = Get.find<NotificationController>();

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [

          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            height: 5, width: 40,
            decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Notifikasi", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: () => notificationController.markAllAsRead(),
                  child: const Text("Tandai Dibaca", style: TextStyle(color: Colors.orange)),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          Expanded(
            child: Obx(() {
              if (notificationController.notifications.isEmpty) {
                return _buildEmptyState();
              }

              return ListView.separated(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: notificationController.notifications.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final notif = notificationController.notifications[index];
                  return _buildNotificationItem(notif);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(dynamic notif) {
    bool isUnread = notif['is_read'] == false;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isUnread ? Colors.orange.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isUnread ? Colors.orange.withOpacity(0.2) : Colors.grey.shade100),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon Indikator
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isUnread ? Colors.orange : Colors.grey[200],
              shape: BoxShape.circle,
            ),
            child: Icon(
              isUnread ? Icons.notifications_active : Icons.notifications_none,
              size: 20, color: isUnread ? Colors.white : Colors.grey,
            ),
          ),
          const SizedBox(width: 16),
          // Konten Teks
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(notif['title'] ?? 'Info Catering',
                    style: TextStyle(fontWeight: isUnread ? FontWeight.bold : FontWeight.normal, fontSize: 15)),
                const SizedBox(height: 4),
                Text(notif['body'] ?? '',
                    style: TextStyle(color: Colors.grey[600], fontSize: 13, height: 1.4)),
              ],
            ),
          ),
          // Titik merah jika belum dibaca
          if (isUnread)
            const CircleAvatar(radius: 4, backgroundColor: Colors.orange),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_off_outlined, size: 60, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text("Belum ada notifikasi", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
