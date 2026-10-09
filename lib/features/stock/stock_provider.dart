import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../auth/auth_provider.dart';

// Stock Models
class VehicleStockItem {
  final String id;
  final String productName;
  final double loadedKg;
  final double currentKg;
  final double costPricePerKg;

  VehicleStockItem({
    required this.id,
    required this.productName,
    required this.loadedKg,
    required this.currentKg,
    required this.costPricePerKg,
  });
}

// Future Provider for Today's Stock (replacing StreamProvider to prevent reload loops)
final todayStockProvider = FutureProvider<List<VehicleStockItem>>((ref) async {
  final client = ref.watch(supabaseClientProvider);
  final userId = client.auth.currentUser?.id;

  if (userId == null) return [];

  final today = DateTime.now().toIso8601String().split('T')[0];

  final response = await client
      .from('vehicle_stock')
      .select('*, products(name)')
      .eq('user_id', userId)
      .eq('stock_date', today);

  return (response as List).map((item) {
    final productMap = item['products'];
    final productName = productMap is Map ? productMap['name'] : 'Unknown';
    return VehicleStockItem(
      id: item['id'],
      productName: productName,
      loadedKg: (item['loaded_kg'] as num).toDouble(),
      currentKg: (item['current_kg'] as num).toDouble(),
      costPricePerKg: (item['cost_price_per_kg'] as num).toDouble(),
    );
  }).toList();
});

// Stock Controller
final stockControllerProvider =
    StateNotifierProvider<StockController, AsyncValue<void>>((ref) {
      return StockController(ref.watch(supabaseClientProvider), ref);
    });

class StockController extends StateNotifier<AsyncValue<void>> {
  final SupabaseClient _client;
  final Ref _ref;

  StockController(this._client, this._ref) : super(const AsyncValue.data(null));

  // (Add Stock)
  Future<void> loadStock({
    required String fishName,
    required double loadedKg,
    required double costPricePerKg,
  }) async {
    final userId = _client.auth.currentUser!.id;
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      // Check existing product
      final existingProduct = await _client
          .from('products')
          .select()
          .eq('user_id', userId)
          .eq('name', fishName)
          .maybeSingle();

      String productId;
      if (existingProduct == null) {
        final newProduct = await _client
            .from('products')
            .insert({'user_id': userId, 'name': fishName})
            .select()
            .single();
        productId = newProduct['id'];
      } else {
        productId = existingProduct['id'];
      }

      // Adding today stocks
      final today = DateTime.now().toIso8601String().split('T')[0];

      await _client.from('vehicle_stock').insert({
        'user_id': userId,
        'product_id': productId,
        'loaded_kg': loadedKg,
        'current_kg': loadedKg, // on start current = loaded
        'cost_price_per_kg': costPricePerKg,
        'stock_date': today,
      });

      // Invalidate provider so stock list refreshes with new data
      _ref.invalidate(todayStockProvider);
    });
  }
}
