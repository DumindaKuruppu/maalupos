import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth/auth_provider.dart';
import '../stock/load_stock_screen.dart';
import '../stock/stock_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todayStockAsync = ref.watch(todayStockProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('dashboard_title'.tr()),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () =>
                ref.read(authControllerProvider.notifier).signOut(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Quick Actions Cards
            Row(
              children: [
                Expanded(
                  child: ActionCard(
                    title: 'load_stock'.tr(),
                    icon: Icons.unarchive,
                    color: Colors.orange.shade700,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LoadStockScreen(),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ActionCard(
                    title: 'new_bill'.tr(),
                    icon: Icons.receipt_long,
                    color: Colors.green.shade700,
                    onTap: () {
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),

            Text(
              'today_stock_title'.tr(),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Stock Table Display
            todayStockAsync.when(
              data: (stockList) {
                if (stockList.isEmpty) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Center(
                        child: Text(
                          'empty_stock_message'.tr(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  );
                }

                return Card(
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: stockList.length,
                    separatorBuilder: (context, index) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final item = stockList[index];
                      return ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Colors.blueAccent,
                          child: Icon(Icons.set_meal, color: Colors.white),
                        ),
                        title: Text(
                          item.productName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          'cost_price_label_format'.tr(args: [item.costPricePerKg.toString()]),
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'remaining_format'.tr(args: [item.currentKg.toString()]),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            Text(
                              'loaded_format'.tr(args: [item.loadedKg.toString()]),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Text('${'error'.tr()}: $e'),
            ),
          ],
        ),
      ),
    );
  }
}

class ActionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const ActionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, size: 36, color: Colors.white),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
