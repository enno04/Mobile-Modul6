import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/menu_item_model.dart';

class MenuService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<MenuItem>> fetchMenuItems() async {
    final response = await _client
        .from('menu_items') // nama tabel di Supabase
        .select()
        .eq('is_active', true);

    return (response as List)
        .map((e) => MenuItem.fromMap(e as Map<String, dynamic>))
        .toList();
  }
}
