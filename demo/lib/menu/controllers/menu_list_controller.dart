import 'package:demo/data/models/MenuItems.dart';
import 'package:get/get.dart';
import '../../../data/services/menu_service.dart';

class MenuListController extends GetxController {
  final menuService = MenuService();

  var items = <MenuItems>[].obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMenuItems();
  }

  void fetchMenuItems() async {
    try {
      isLoading(true);
      errorMessage('');
      var result = await menuService.fetchMenu();
      if(result.isNotEmpty) {
        items.assignAll(result);
      }
    } catch (e) {
      errorMessage(e.toString());
    } finally {
      isLoading(false);
    }
  }

}
