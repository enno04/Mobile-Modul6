import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import '../../../data/services/location_service.dart';

class HomeController extends GetxController {
  final LocationService _locationService = LocationService();

  // Variabel untuk UI
  var currentAddress = 'Mencari lokasi...'.obs;
  var latitude = 0.0.obs;
  var longitude = 0.0.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getUserLocation(); // Panggil saat aplikasi dibuka
  }

  Future<void> getUserLocation() async {
    try {
      isLoading.value = true;

      // PERBAIKAN DI SINI:
      // 1. Tambahkan tanda tanya '?' (Position?) karena hasilnya bisa null
      // 2. Panggil tanpa parameter (default useGps = true)
      Position? position = await _locationService.getCurrentPosition();

      // 3. Cek apakah posisi berhasil didapatkan
      if (position != null) {
        latitude.value = position.latitude;
        longitude.value = position.longitude;

        // 4. Ambil Alamat
        String address = await _locationService.getAddressFromCoordinates(
          position.latitude,
          position.longitude,
        );
        currentAddress.value = address;
      } else {
        currentAddress.value = "Gagal mendapatkan koordinat GPS.";
      }
    } catch (e) {
      currentAddress.value = "Gagal memuat lokasi: $e";
    } finally {
      isLoading.value = false;
    }
  }
}
