import 'package:demo/data/services/notification_service.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CartController extends GetxController {
  // Box dynamic, jangan pakai generic Box<Map>
  final Box cartBox = Hive.box('cart_box');

  final cartItems = <Map<String, dynamic>>[].obs;
  final isProcessing = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadCart();
  }

  void loadCart() {
    final raw = cartBox.get('items', defaultValue: []);

    print('RAW HIVE items = $raw');

    if (raw is List) {
      cartItems.value = raw
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();
    } else {
      cartItems.clear();
    }
  }

  void addItem(Map<String, dynamic> item) {
    cartItems.add(item);
    save();
  }

  void removeItem(String menuItemId) {
    cartItems.removeWhere((item) => item['menu_item_id'] == menuItemId);
    save();
  }

  void clearCart() {
    cartItems.clear();
    save();
  }

  int get totalPrice {
    int total = 0;
    for (var item in cartItems) {
      total += (item['price'] * item['qty']) as int;
    }
    return total;
  }

  void save() {
    cartBox.put('items', cartItems.toList());
    cartItems.refresh();

    print('SAVE HIVE items = ${cartBox.toMap()}');
  }

  Future<void> checkout() async {
    try {
      isProcessing.value = true;

      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        Get.snackbar("Error", "Kamu belum login");
        return;
      }

      if (cartItems.isEmpty) {
        Get.snackbar("Error", "Keranjang masih kosong");
        return;
      }

      // 1️⃣ INSERT ORDER
      final order = await Supabase.instance.client
          .from('orders')
          .insert({
            'user_id': user.id,
            'total_price': totalPrice,
            'status': 'pending',
            'items': cartItems.toList(),
          })
          .select()
          .single();

      // 2️⃣ SIMPAN NOTIFICATION (REMINDER)
      await Supabase.instance.client.from('notifications').insert({
        'user_id': user.id,
        'title': 'Pesanan Menunggu Pembayaran',
        'body': 'Segera selesaikan pembayaran sebesar Rp$totalPrice',
        'type': 'order_pending',
        'payload': {'order_id': order['id'], 'total_price': totalPrice},
      });

      // 3️⃣ LOCAL NOTIFICATION
      await NotificationService.showLocalNotification(
        title: 'Pesanan Berhasil',
        body: 'Total pembayaran Rp$totalPrice',
        payload: {'type': 'order', 'order_id': order['id']},
      );

      clearCart();
      Get.snackbar("Sukses", "Pesanan berhasil dibuat!");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isProcessing.value = false;
    }
  }
}
