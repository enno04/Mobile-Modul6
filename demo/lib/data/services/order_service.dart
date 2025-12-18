import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/order_model.dart';

class OrderService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<void> createOrder(Order order) async {
    await _client.from('orders').insert(order.toMap());
  }

  Future<List<Order>> fetchUserOrders(String userId) async {
    final response = await _client
        .from('orders')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return (response as List)
        .map((e) => Order.fromMap(e as Map<String, dynamic>))
        .toList();
  }
}
