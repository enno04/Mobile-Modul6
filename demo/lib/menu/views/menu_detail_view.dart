import 'package:demo/data/models/CartItem.dart';
import 'package:demo/data/models/MenuItems.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart'; // Import Maps
import 'package:latlong2/latlong.dart'; // Import LatLong
import 'package:get/get.dart';
import '../../cart/controllers/cart_controller.dart';
// Jangan lupa import controller lokasi yang baru dibuat
import 'package:demo/app/modules/location_controller.dart'; 

class MenuDetailView extends StatefulWidget {
  const MenuDetailView({super.key});

  @override
  State<MenuDetailView> createState() => _MenuDetailViewState();
}

class _MenuDetailViewState extends State<MenuDetailView> {
  int qty = 1;
  // Inisialisasi controller lokasi
  final LocationController locationController = Get.put(LocationController());

  @override
  Widget build(BuildContext context) {
    final MenuItems item = Get.arguments;
    final CartController cart = Get.find<CartController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // 1. HEADER IMAGE (Sama seperti kodemu)
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                leading: CircleAvatar(
                  backgroundColor: Colors.white.withOpacity(0.7),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Get.back(),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Hero(
                    tag: 'menu-${item.itemID}',
                    child: Image.network(
                      item.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(color: Colors.grey[200]),
                    ),
                  ),
                ),
              ),

              // 2. CONTENT SECTION
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- Bagian Judul & Harga (Sama seperti kodemu) ---
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              item.itemName,
                              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Text(
                            "Rp ${item.itemPrice}",
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.orange),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      
                      // --- Bagian Deskripsi ---
                      const Text("Deskripsi", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(
                        item.itemDescription.isEmpty ? "Deskripsi default..." : item.itemDescription,
                        style: TextStyle(fontSize: 15, color: Colors.grey[700], height: 1.6),
                      ),
                      
                      const SizedBox(height: 30), // Jarak sebelum maps

                      // ============================================
                      // 3. BAGIAN MAPS & LOKASI (BARU)
                      // ============================================
                      const Text("Lokasi Pengiriman", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      
                      // Box Alamat
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey[300]!)
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.location_on, color: Colors.orange),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Obx(() => Text(
                                locationController.currentAddress.value,
                                style: const TextStyle(fontSize: 14),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              )),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Tampilan Peta
                      SizedBox(
                        height: 250, // Tinggi Peta
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Stack(
                            children: [
                              Obx(() {
                                // Menggunakan MapController untuk update posisi jika diperlukan
                                return FlutterMap(
                                  options: MapOptions(
                                    initialCenter: locationController.selectedLocation.value,
                                    initialZoom: 15.0,
                                    onTap: (tapPosition, point) {
                                      locationController.updateLocation(point);
                                    },
                                  ),
                                  children: [
                                    TileLayer(
                                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                      userAgentPackageName: 'com.mikocatering.app',
                                    ),
                                    MarkerLayer(
                                      markers: [
                                        Marker(
                                          point: locationController.selectedLocation.value,
                                          width: 80,
                                          height: 80,
                                          child: const Icon(
                                            Icons.location_pin,
                                            color: Colors.red,
                                            size: 40,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              }),
                              
                              // Tombol "Lokasi Saya" di pojok kanan bawah peta
                              Positioned(
                                bottom: 10,
                                right: 10,
                                child: FloatingActionButton.small(
                                  backgroundColor: Colors.white,
                                  onPressed: () => locationController.getCurrentLocation(),
                                  child: Obx(() => locationController.isLoading.value 
                                      ? const Padding(padding: EdgeInsets.all(8.0), child: CircularProgressIndicator(strokeWidth: 2)) 
                                      : const Icon(Icons.my_location, color: Colors.black)),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      // ============================================
                      // END MAPS
                      // ============================================

                      const SizedBox(height: 100), // Ruang untuk bottom bar
                    ],
                  ),
                ),
              ),
            ],
          ),

          // 3. STICKY BOTTOM BAR (Quantity & Add to Cart)
          // ... (Bagian ini biarkan sama seperti kodemu sebelumnya) ...
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)]),
              child: Row(
                children: [
                   // ... Qty Buttons ...
                   Container(
                    decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      children: [
                        _buildQtyBtn(Icons.remove, () { if (qty > 1) setState(() => qty--); }),
                        Text("$qty", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        _buildQtyBtn(Icons.add, () => setState(() => qty++)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  
                  // Tombol Tambah (Update Logic Disini untuk bawa data lokasi)
                  Expanded(
                    child: SizedBox(
                      height: 54,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                        onPressed: () {
                          // Pastikan user sudah pilih lokasi valid (opsional)
                          // if(locationController.currentAddress.value.contains("Belum")) {
                          //   Get.snackbar("Info", "Pilih lokasi pengiriman dulu");
                          //   return;
                          // }
                          
                          // TODO: Masukkan data lokasi ke CartItem jika model CartItem-mu sudah support,
                          // Atau simpan di Global Controller untuk dipakai pas Checkout nanti.
                          
                          cart.addItem(CartItem(
                            id: item.itemID,
                            name: item.itemName,
                            price: item.itemPrice,
                            qty: qty,
                            image: item.imageUrl,
                            // Tambahkan field ini di model CartItem-mu jika ingin disimpan per item,
                            // atau cukup simpan di CartController secara global.
                          ));
                          Get.snackbar("Berhasil", "Masuk keranjang", snackPosition: SnackPosition.TOP, backgroundColor: Colors.orange, colorText: Colors.white);
                        },
                        child: const Text("Tambah", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQtyBtn(IconData icon, VoidCallback onTap) {
    return IconButton(icon: Icon(icon, size: 20), onPressed: onTap);
  }
}