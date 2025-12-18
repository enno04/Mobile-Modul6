import 'package:get/get.dart';
import '../../../data/models/menu_item_model.dart';
import '../../../data/services/menu_service.dart';

class MenuListController extends GetxController {
  final menuService = MenuService();

  final isLoading = false.obs;
  final items = <MenuItem>[].obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // untuk sekarang, pakai dummy dulu
    loadDummyMenu();
    // kalau nanti mau pakai Supabase:
    // fetchMenu();
  }

  Future<void> fetchMenu() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final data = await menuService.fetchMenuItems();

      if (data.isEmpty) {
        // kalau di Supabase belum ada data, isi dummy
        loadDummyMenu();
      } else {
        items.assignAll(data);
      }
    } catch (e) {
      errorMessage.value = 'Gagal memuat menu, pakai dummy.';
      loadDummyMenu();
    } finally {
      isLoading.value = false;
    }
  }

  void loadDummyMenu() {
    items.assignAll([
      MenuItem(
        id: '1',
        name: 'Nasi Box Ayam Bakar',
        description: 'Nasi box dengan ayam bakar, sambal, lalapan.',
        imageUrl: '',
        price: 25000,
        isAvailable: true,
      ),
      MenuItem(
        id: '2',
        name: 'Nasi Box Rendang',
        description: 'Nasi box dengan rendang sapi khas Padang.',
        imageUrl: '',
        price: 30000,
        isAvailable: true,
      ),
      MenuItem(
        id: '3',
        name: 'Snack Box',
        description: 'Isi 3 kue basah + 1 air mineral.',
        imageUrl: '',
        price: 15000,
        isAvailable: true,
      ),
    ]);
  }
}
