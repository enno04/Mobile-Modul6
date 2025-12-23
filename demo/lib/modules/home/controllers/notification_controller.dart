import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationController extends GetxController {
  final notifications = <Map<String, dynamic>>[].obs;
  final unreadCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    final data = await Supabase.instance.client
        .from('notifications')
        .select()
        .eq('user_id', user.id)
        .order('created_at', ascending: false);

    notifications.value = List<Map<String, dynamic>>.from(data);
    unreadCount.value = notifications
        .where((e) => e['is_read'] == false)
        .length;
  }

  Future<void> markAllAsRead() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) return;

      // Update semua notifikasi milik user tersebut yang belum dibaca
      await Supabase.instance.client
          .from('notifications')
          .update({'is_read': true})
          .eq('user_id', user.id)
          .eq('is_read', false);

      // Refresh data lokal agar UI terupdate
      fetchNotifications();
    } catch (e) {
      print("Error markAllAsRead: $e");
    }
  }
}
