import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:demo/data/models/CartItem.dart';
import 'package:demo/data/services/notification_service.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Import Controller Lokasi untuk mengambil alamat saat checkout
// Pastikan path-nya sesuai dengan folder project kamu
import 'package:demo/app/modules/location_controller.dart'; 

// Import View Sukses
import 'package:demo/cart/views/payment_success_view.dart'; 

class CartController extends GetxController {
  final Box _cartBox = Hive.box('cart_box');

  final cartItems = <CartItem>[].obs;
  final isProcessing = false.obs;
  
  // State untuk Metode Pembayaran (Default: QRIS)
  var selectedPaymentMethod = 'qris'.obs; 

  @override
  void onInit() {
    super.onInit();
    loadCart();
  }

  // --- LOGIKA INTERNAL CART (HIVE) ---

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

  // --- LOGIKA ITEM (TAMBAH/KURANG) ---

  void addItem(CartItem newItem) {
    int index = cartItems.indexWhere((item) => item.id == newItem.id);
    if (index != -1) {
      cartItems[index].qty += newItem.qty;
    } else {
      cartItems.add(newItem);
    }
    _saveToHive();
    cartItems.refresh(); 
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

  num get totalPrice => cartItems.fold(0, (sum, item) => sum + (item.price * item.qty));


  // --- LOGIKA CHECKOUT & PEMBAYARAN ---

  // 1. Fungsi Ganti Metode Pembayaran (Dipanggil dari UI BottomSheet)
  void selectPaymentMethod(String method) {
    selectedPaymentMethod.value = method;
  }

  // 2. Fungsi Utama: Proses Pembayaran
  Future<void> processPayment() async {
    if (cartItems.isEmpty) return;
    
    try {
      isProcessing.value = true;
      
      // Simulasi Loading (2 Detik) agar terlihat seperti memproses transaksi
      await Future.delayed(const Duration(seconds: 2));

      // Simpan data ke Supabase
      await _createOrderInSupabase();

      // Pindah ke Halaman Sukses
      // Pastikan PaymentSuccessView sudah dibuat filenya
      Get.off(() => const PaymentSuccessView()); 

    } catch (e) {
      Get.snackbar("Gagal", "Terjadi kesalahan: $e", 
        backgroundColor: Colors.red, colorText: Colors.white);
      print(e); // Print error di console untuk debugging
    } finally {
      isProcessing.value = false;
    }
  }

  // 3. Fungsi Private: Insert ke Database
  Future<void> _createOrderInSupabase() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) throw "Silahkan login terlebih dahulu";

    // --- INTEGRASI LOKASI (BARU) ---
    // Kita coba ambil data dari LocationController.
    // Menggunakan Get.put untuk memastikan controller ada, meski user belum buka map.
    final locationController = Get.put(LocationController());
    
    String savedAddress = locationController.currentAddress.value;
    // Jika user belum set lokasi, beri default agar tidak error
    if (savedAddress == "Belum ada lokasi dipilih" || savedAddress.isEmpty) {
      savedAddress = "Alamat default (Belum diset)";
    }
    
    double lat = locationController.selectedLocation.value.latitude;
    double lng = locationController.selectedLocation.value.longitude;
    // -------------------------------

    // Insert Order
    final order = await Supabase.instance.client.from('orders').insert({
      'user_id': user.id,
      'total_price': totalPrice,
      'status': 'pending', 
      'items': cartItems.map((e) => e.toMap()).toList(),
      
      // Simpan Metode Pembayaran
      // NOTE: Pastikan kamu sudah buat kolom 'payment_method' di tabel orders Supabase.
      // Jika belum, hapus baris ini agar tidak error saat demo.
      // 'payment_method': selectedPaymentMethod.value, 

      // // Simpan Lokasi Pengiriman (Maps)
      // 'delivery_address': savedAddress,
      // 'latitude': lat,
      // 'longitude': lng,

    }).select().single();

    final orderId = order['id'];

    // Insert Notification ke Database
    await Supabase.instance.client.from('notifications').insert({
      'user_id': user.id,
      'title': 'Pembayaran Berhasil!',
      'body': 'Pesanan #${orderId.toString().substring(0,8)} via ${selectedPaymentMethod.value.toUpperCase()} diterima.',
      'type': 'order_success',
      'payload': {
        'order_id': orderId,
        'screen': 'order_detail', 
        'total_amount': totalPrice,
      },
    });

    // Tampilkan Notifikasi Lokal di HP
    await NotificationService.showLocalNotification(
      title: 'Miko Catering',
      body: 'Hore! Pembayaran Rp$totalPrice berhasil.',
      payload: {
        'type': 'order',
        'order_id': orderId,
        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      }
    );

    clearCart(); // Kosongkan keranjang setelah sukses
  }
}