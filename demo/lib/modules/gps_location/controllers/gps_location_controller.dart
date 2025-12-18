import 'dart:async';
import 'package:flutter/foundation.dart'; // Untuk debugPrint
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../data/services/location_service.dart';

class GpsLocationController extends GetxController {
  final LocationService _locationService = LocationService();
  final MapController mapController = MapController();
  StreamSubscription<Position>? _positionStream;

  // Data UI (Real-time)
  var currentPosition = LatLng(-7.9214, 112.5991).obs;
  var address = '-'.obs;
  var isLoading = false.obs;

  // Data Eksperimen
  var accuracy = 0.0.obs;
  var speed = 0.0.obs;
  var timestamp = '-'.obs;

  // Status Mode
  var isGpsMode = true.obs;
  var isLiveTracking = false.obs;

  // Logger (Tabel Laporan)
  var logs = <Map<String, String>>[].obs;

  @override
  void onInit() {
    super.onInit();
    getLocation(); // Ambil data awal sekali
  }

  @override
  void onClose() {
    _positionStream?.cancel();
    super.onClose();
  }

  // --- FITUR 1: LIVE TRACKING (STREAM) ---
  void toggleTracking() {
    if (isLiveTracking.value) {
      stopTracking();
    } else {
      startTracking();
    }
  }

  void startTracking() {
    isLiveTracking.value = true;
    _positionStream?.cancel();

    // Memulai stream lokasi dari service
    _positionStream = _locationService
        .getPositionStream(useGps: isGpsMode.value)
        .listen(
          (Position position) {
            // Update UI (Angka berubah real-time)
            _updateUI(position);

            // Pindahkan kamera peta mengikuti user
            mapController.move(
              currentPosition.value,
              mapController.camera.zoom,
            );
          },
          onError: (e) {
            debugPrint("Stream Error: $e");
          },
        );
  }

  void stopTracking() {
    isLiveTracking.value = false;
    _positionStream?.cancel();
    _positionStream = null;
  }

  // --- FITUR 2: PENCATAT DATA (LOGGER) ---
  // Perbaikan: Sekarang speed sudah dimasukkan ke sini!
  void logData() {
    final now = DateTime.now();
    final timeString =
        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";

    // Masukkan data saat ini ke tabel
    logs.insert(0, {
      "lat": currentPosition.value.latitude.toStringAsFixed(6),
      "long": currentPosition.value.longitude.toStringAsFixed(6),
      "acc": "${accuracy.value.toStringAsFixed(1)} m",
      "speed":
          "${speed.value.toStringAsFixed(1)} m/s", // <--- INI YANG HILANG SEBELUMNYA
      "time": timeString,
    });
  }

  void clearLogs() {
    logs.clear();
  }

  // --- UTILS ---
  Future<void> getLocation() async {
    isLoading.value = true;
    try {
      Position? position = await _locationService.getCurrentPosition(
        useGps: isGpsMode.value,
      );

      if (position != null) {
        _updateUI(position);
        mapController.move(currentPosition.value, mapController.camera.zoom);
      }
    } catch (e) {
      Get.snackbar("Error", "Gagal ambil lokasi: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void switchMode() {
    isGpsMode.value = !isGpsMode.value;

    // Restart tracking jika sedang jalan agar mode berubah
    if (isLiveTracking.value) {
      stopTracking();
      startTracking();
    } else {
      getLocation();
    }
  }

  void _updateUI(Position position) async {
    currentPosition.value = LatLng(position.latitude, position.longitude);
    accuracy.value = position.accuracy;
    speed.value = position.speed; // Pastikan ini juga terisi

    final now = DateTime.now();
    timestamp.value =
        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";

    if (!isLiveTracking.value) {
      address.value = await _locationService.getAddressFromCoordinates(
        position.latitude,
        position.longitude,
      );
    } else {
      address.value = "Live Tracking Aktif...";
    }
  }
}
