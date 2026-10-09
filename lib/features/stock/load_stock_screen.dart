import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'stock_provider.dart';

class LoadStockScreen extends ConsumerStatefulWidget {
  const LoadStockScreen({super.key});

  @override
  ConsumerState<LoadStockScreen> createState() => _LoadStockScreenState();
}

class _LoadStockScreenState extends ConsumerState<LoadStockScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fishNameController = TextEditingController();
  final _weightController = TextEditingController();
  final _costController = TextEditingController();

  final List<String> _commonFish = [
    'කෙළවල් (Kelawalla)',
    'බලයා (Balaya)',
    'තලපත් (Thalapath)',
    'සාලයා (Salaya)',
    'හුරුල්ලා (Hurulla)',
    'ලින්නා (Linna)',
    'පරා (Para)',
    'කූනිස්සෝ (Prawns)',
  ];

  void _saveStock() async {
    if (_formKey.currentState!.validate()) {
      await ref
          .read(stockControllerProvider.notifier)
          .loadStock(
            fishName: _fishNameController.text.trim(),
            loadedKg: double.parse(_weightController.text.trim()),
            costPricePerKg: double.parse(_costController.text.trim()),
          );

      if (mounted) {
        final state = ref.read(stockControllerProvider);
        if (!state.hasError) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('තොග එකතු කිරීම සාර්ථකයි!')),
          );
          _fishNameController.clear();
          _weightController.clear();
          _costController.clear();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final stockState = ref.watch(stockControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('උදෑසන මාළු තොග ඇතුළත් කිරීම')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Autocomplete<String>(
                optionsBuilder: (textEditingValue) {
                  if (textEditingValue.text.isEmpty)
                    return const Iterable<String>.empty();
                  return _commonFish.where(
                    (fish) => fish.toLowerCase().contains(
                      textEditingValue.text.toLowerCase(),
                    ),
                  );
                },
                onSelected: (selection) => _fishNameController.text = selection,
                fieldViewBuilder:
                    (context, controller, focusNode, onFieldSubmitted) {
                      _fishNameController.text = controller.text;
                      return TextFormField(
                        controller: controller,
                        focusNode: focusNode,
                        decoration: const InputDecoration(
                          labelText: 'මාළු වර්ගයේ නම',
                          prefixIcon: Icon(Icons.set_meal),
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) =>
                            v!.isEmpty ? 'මාළු වර්ගයක් තෝරන්න/ලියන්න' : null,
                      );
                    },
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _weightController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'ප්‍රමාණය (Kg)',
                        prefixIcon: Icon(Icons.scale),
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) => v!.isEmpty ? 'Kg ගාණ දාන්න' : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _costController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'ගැනුම් මිල 1Kg (Rs.)',
                        prefixIcon: Icon(Icons.payments),
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) => v!.isEmpty ? 'ගැනුම් මිල දාන්න' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: stockState.isLoading ? null : _saveStock,
                icon: const Icon(Icons.add_shopping_cart),
                label: stockState.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('වාහනයට ඇතුළත් කරන්න (Add to Vehicle)'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
