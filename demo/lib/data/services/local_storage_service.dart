import 'package:hive_flutter/hive_flutter.dart';

class LocalStorageService {
  static const cartBoxName = 'cart_box';

  Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(cartBoxName);
  }

  Box get cartBox => Hive.box(cartBoxName);
}
