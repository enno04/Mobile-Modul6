import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../data/models/order_model.dart';

class OrdersController extends GetxController {
  final SupabaseClient _client = Supabase.instance.client;

  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final orders = <Order>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final user = _client.auth.currentUser;
      if (user == null) {
        errorMessage.value = 'Silahkan login untuk melihat riwayat pesanan';
        return;
      }

      final response = await _client
          .from('orders')
          .select()
          .eq('user_id', user.id)
          .order('created_at', ascending: false);

      if (response != null) {
        orders.assignAll((response as List)
            .map((item) => Order.fromMap(item as Map<String, dynamic>))
            .toList());
      }
    } catch (e) {
      errorMessage.value = 'Gagal memuat pesanan. Periksa koneksi internet Anda.';
      print("Error Fetch Orders: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
