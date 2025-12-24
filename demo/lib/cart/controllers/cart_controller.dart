import 'dart:convert';

import 'package:demo/data/models/CartItem.dart';
import 'package:demo/data/services/notification_service.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CartController extends GetxController {
  final Box _cartBox = Hive.box('cart_box');

  // Menggunakan List<CartItem> agar lebih terstruktur
  final cartItems = <CartItem>[].obs;
  final isProcessing = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadCart();
  }

  // --- LOGIKA INTERNAL ---

  void loadCart() {
    final List<dynamic>? raw = _cartBox.get('items');
    if (raw != null) {

      final List<CartItem> loadedItems = raw.map((e) {
        return CartItem.fromMap(Map<String, dynamic>.from(e));
      }).toList();

      cartItems.assignAll(loadedItems);
    }
  }

  void _saveToHive() {
    _cartBox.put('items', cartItems.map((e) => e.toMap()).toList());
  }

  // --- LOGIKA ITEM ---

  void addItem(CartItem newItem) {
    // Cek apakah item sudah ada di keranjang
    int index = cartItems.indexWhere((item) => item.id == newItem.id);

    if (index != -1) {
      // Jika ada, tambahkan quantity-nya saja
      cartItems[index].qty += newItem.qty;
    } else {
      // Jika belum ada, tambah sebagai item baru
      cartItems.add(newItem);
    }

    _saveToHive();
    cartItems.refresh(); // Memicu update UI GetX
  }

  void updateQuantity(int id, int newQty) {
    int index = cartItems.indexWhere((item) => item.id == id);
    if (index != -1 && newQty > 0) {
      cartItems[index].qty = newQty;
      _saveToHive();
      cartItems.refresh();
    }
  }

  void removeItem(int id) {
    cartItems.removeWhere((item) => item.id == id);
    _saveToHive();
  }

  void clearCart() {
    cartItems.clear();
    _cartBox.delete('items');
  }

  // Menggunakan .fold untuk menghitung total lebih "clean"
  num get totalPrice => cartItems.fold(0, (sum, item) => sum + (item.price * item.qty));

  // --- LOGIKA CHECKOUT ---

  Future<void> checkout() async {
    if (cartItems.isEmpty) {
      Get.snackbar("Info", "Keranjang masih kosong");
      return;
    }

    try {
      isProcessing.value = true;
      final user = Supabase.instance.client.auth.currentUser;

      if (user == null) throw "Silahkan login terlebih dahulu";

      // 1. Simpan ke Supabase
      final order = await Supabase.instance.client.from('orders').insert({
        'user_id': user.id,
        'total_price': totalPrice,
        'status': 'pending',
        'items': cartItems.map((e) => e.toMap()).toList(),
      }).select().single();

      final orderId = order['id'];

      // 2. Notifikasi Database
      await Supabase.instance.client.from('notifications').insert({
        'user_id': user.id,
        'title': 'Pesanan Berhasil!',
        'body': 'Pesanan #${order['id']} sedang diproses.',
        'type': 'order_success',
        'payload': {
          'order_id': orderId,
          'screen': 'order_detail', // Petunjuk untuk navigasi
          'total_amount': totalPrice,
        },
      });

      Map<String, dynamic> localPayload = {
        'type': 'order',
        'order_id': orderId,
        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      };

      // 3. Notifikasi Lokal
      await NotificationService.showLocalNotification(
        title: 'Miko Catering',
        body: 'Hore! Pesananmu senilai Rp$totalPrice berhasil dibuat.',
        payload: localPayload
      );

      clearCart();
      Get.offAllNamed('/home'); // Kembali ke home agar fresh
      Get.snackbar("Sukses", "Pesanan berhasil dikirim!");

    } catch (e) {
      Get.snackbar("Oops!", e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isProcessing.value = false;
    }
  }
}
