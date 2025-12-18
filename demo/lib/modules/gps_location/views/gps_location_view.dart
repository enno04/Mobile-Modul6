import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import '../controllers/gps_location_controller.dart';

class GpsLocationView extends StatelessWidget {
  const GpsLocationView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(GpsLocationController());

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Eksperimen Modul 5",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          // Tombol Ganti Mode (GPS/NET)
          Obx(
            () => Container(
              margin: const EdgeInsets.only(right: 10),
              child: TextButton.icon(
                onPressed: controller.switchMode,
                icon: Icon(
                  controller.isGpsMode.value ? Icons.satellite_alt : Icons.wifi,
                  color: controller.isGpsMode.value
                      ? Colors.red
                      : Colors.blueGrey,
                ),
                label: Text(
                  controller.isGpsMode.value ? "GPS HIGH" : "NET LOW",
                  style: TextStyle(
                    color: controller.isGpsMode.value
                        ? Colors.red
                        : Colors.blueGrey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: TextButton.styleFrom(backgroundColor: Colors.white),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // ===================================
          // 1. PETA (Bagian Atas)
          // ===================================
          Expanded(
            flex: 6, // Peta lebih besar sedikit
            child: Stack(
              children: [
                Obx(
                  () => FlutterMap(
                    mapController: controller.mapController,
                    options: MapOptions(
                      initialCenter: controller.currentPosition.value,
                      initialZoom: 17.0,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://{s}.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.miko.catering.app',
                      ),
                      CircleLayer(
                        circles: [
                          CircleMarker(
                            point: controller.currentPosition.value,
                            radius: controller.accuracy.value,
                            useRadiusInMeter: true,
                            color: controller.isGpsMode.value
                                ? Colors.red.withOpacity(0.1)
                                : Colors.blue.withOpacity(0.2),
                            borderColor: controller.isGpsMode.value
                                ? Colors.red
                                : Colors.blue,
                            borderStrokeWidth: 1,
                          ),
                        ],
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: controller.currentPosition.value,
                            width: 80,
                            height: 80,
                            child: Icon(
                              Icons.accessibility_new_rounded,
                              color: controller.isGpsMode.value
                                  ? Colors.red
                                  : Colors.blue,
                              size: 50,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Info Overlay Kecil (Data Live)
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Obx(
                      () => Text(
                        "Speed: ${controller.speed.value.toStringAsFixed(1)} m/s | Acc: ${controller.accuracy.value.toStringAsFixed(1)} m",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ===================================
          // 2. PANEL DATA & TABEL (Bagian Bawah)
          // ===================================
          Expanded(
            flex: 4,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10,
                    color: Colors.black12,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // TOMBOL KONTROL UTAMA
                  Row(
                    children: [
                      // Tombol 1: Mulai Live Tracking (Wajib untuk jalan)
                      Expanded(
                        child: Obx(
                          () => ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: controller.isLiveTracking.value
                                  ? Colors.red.shade100
                                  : Colors.green,
                              foregroundColor: controller.isLiveTracking.value
                                  ? Colors.red
                                  : Colors.white,
                            ),
                            onPressed: controller.toggleTracking,
                            child: Text(
                              controller.isLiveTracking.value
                                  ? "STOP LIVE"
                                  : "MULAI LIVE",
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Tombol 2: Catat Data ke Tabel
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: controller.logData, // <--- Ini kuncinya
                          icon: const Icon(Icons.add_circle_outline, size: 18),
                          label: const Text("CATAT DATA"),
                        ),
                      ),
                      // Tombol 3: Hapus
                      IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.grey,
                        ),
                        onPressed: controller.clearLogs,
                        tooltip: "Hapus Data",
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  const Divider(),

                  // HEADER TABEL
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    color: Colors.grey.shade200,
                    child: const Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            "Waktu",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            "Lat",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            "Long",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            "Speed",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ISI TABEL (List yang bisa discroll)
                  Expanded(
                    child: Obx(
                      () => ListView.builder(
                        itemCount: controller.logs.length,
                        itemBuilder: (context, index) {
                          final log = controller.logs[index];
                          return Container(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: Colors.grey.shade100),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    log['time']!,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 11),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    log['lat']!,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 11),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    log['long']!,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 11),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    log['speed']!,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
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
}
