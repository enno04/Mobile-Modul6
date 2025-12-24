import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class LocationController extends GetxController {
  var currentAddress = 'Belum ada lokasi dipilih'.obs;
  var selectedLocation = LatLng(-6.200000, 106.816666).obs; // Default Jakarta
  var isLoading = false.obs;

  // Fungsi untuk mendapatkan lokasi GPS saat ini
  Future<void> getCurrentLocation() async {
    isLoading.value = true;
    try {
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Get.snackbar("Error", "Layanan lokasi tidak aktif");
        return;
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.snackbar("Error", "Izin lokasi ditolak");
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      selectedLocation.value = LatLng(position.latitude, position.longitude);
      await getAddressFromLatLng(position.latitude, position.longitude);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Fungsi saat user tap di peta manual
  void updateLocation(LatLng point) async {
    selectedLocation.value = point;
    await getAddressFromLatLng(point.latitude, point.longitude);
  }

  // Convert LatLong jadi Alamat Teks (Reverse Geocoding)
  Future<void> getAddressFromLatLng(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        // Format alamat simpel: Jalan, Kecamatan, Kota
        currentAddress.value = "${place.street}, ${place.subLocality}, ${place.locality}";
      }
    } catch (e) {
      currentAddress.value = "Alamat tidak ditemukan";
    }
  }
}