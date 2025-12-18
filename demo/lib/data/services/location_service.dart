import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  // Helper Cek Izin
  Future<bool> _checkPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return false;
    }
    if (permission == LocationPermission.deniedForever) return false;
    return true;
  }

  // 1. Ambil Lokasi Sekali (One-Time)
  Future<Position?> getCurrentPosition({bool useGps = true}) async {
    if (!await _checkPermission()) return null;

    return await Geolocator.getCurrentPosition(
      // PERBAIKAN: Ganti 'low' ke 'balanced' agar Network Mode bisa mendeteksi
      // pergerakan antar gedung/blok (sekitar 100m), bukan antar kota.
      desiredAccuracy: useGps
          ? LocationAccuracy.bestForNavigation
          : LocationAccuracy.medium,
    );
  }

  // 2. Stream Lokasi (Live Tracking)
  Stream<Position> getPositionStream({bool useGps = true}) {
    late LocationSettings locationSettings;

    if (useGps) {
      // MODE GPS (HIGH ACCURACY)
      locationSettings = AndroidSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 0, // Update terus tiap gerak dikit
        forceLocationManager: true,
        intervalDuration: const Duration(seconds: 1),
      );
    } else {
      // MODE NETWORK (BALANCED / MEDIUM ACCURACY)
      // Kita pakai 'balanced' supaya masih bisa update kalau jalan agak jauh (10-20m)
      locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.medium,
        distanceFilter: 10, // Update tiap pindah 10 meter
      );
    }

    return Geolocator.getPositionStream(locationSettings: locationSettings);
  }

  // 3. Reverse Geocoding
  Future<String> getAddressFromCoordinates(double lat, double long) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);
      Placemark place = placemarks[0];
      return "${place.street}, ${place.subLocality}";
    } catch (e) {
      return "Alamat tidak ditemukan";
    }
  }
}
