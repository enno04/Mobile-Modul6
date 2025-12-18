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

      final data = {
        'user_id': user.id,
        'total_price': totalPrice,
        'status': 'pending',
        'notes': null,
        'items': cartItems.toList(), // akan masuk ke jsonb
      };

      await Supabase.instance.client.from('orders').insert(data);

      clearCart();

      Get.snackbar("Sukses", "Pesanan berhasil dibuat!");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isProcessing.value = false;
    }
  }
}
