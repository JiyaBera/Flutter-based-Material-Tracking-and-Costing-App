import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/material_provider.dart';
import '../models/material.dart';
import 'package:image_picker/image_picker.dart';

class MaterialsScreen extends StatelessWidget {
  const MaterialsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Materials'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(context),
          ),
        ],
      ),
      body: Consumer<MaterialProvider>(
        builder: (context, materialProvider, child) {
          final materials = materialProvider.materials;
          
          if (materials.isEmpty) {
            return const Center(
              child: Text('No materials found. Add some materials to get started.'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: materials.length,
            itemBuilder: (context, index) {
              final material = materials[index];
              return _MaterialCard(material: material);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _pickImage(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Materials'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('All Materials'),
              onTap: () {
                context.read<MaterialProvider>().filterMaterials(null);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('In Stock'),
              onTap: () {
                context.read<MaterialProvider>().filterMaterials(true);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Low Stock'),
              onTap: () {
                context.read<MaterialProvider>().filterMaterials(false);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    
    if (image != null) {
      // TODO: Implement barcode scanning logic
      // For now, we'll just show a dialog to add material details manually
      _showAddMaterialDialog(context);
    }
  }

  void _showAddMaterialDialog(BuildContext context) {
    final nameController = TextEditingController();
    final quantityController = TextEditingController();
    final minStockController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Material'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Material Name',
              ),
            ),
            TextField(
              controller: quantityController,
              decoration: const InputDecoration(
                labelText: 'Current Stock',
              ),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: minStockController,
              decoration: const InputDecoration(
                labelText: 'Minimum Stock Level',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final name = nameController.text;
              final quantity = int.tryParse(quantityController.text) ?? 0;
              final minStock = int.tryParse(minStockController.text) ?? 0;

              if (name.isNotEmpty && quantity >= 0 && minStock >= 0) {
                context.read<MaterialProvider>().addMaterial(
                  MaterialItem(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: name,
                    quantity: quantity,
                    minStockLevel: minStock,
                  ),
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}

class _MaterialCard extends StatelessWidget {
  final MaterialItem material;

  const _MaterialCard({required this.material});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    material.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                _StockStatusChip(material: material),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Current Stock: ${material.quantity}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
              'Minimum Stock Level: ${material.minStockLevel}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () => _showUpdateStockDialog(context),
                  icon: const Icon(Icons.edit),
                  label: const Text('Update Stock'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showUpdateStockDialog(BuildContext context) {
    final controller = TextEditingController(
      text: material.quantity.toString(),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Stock'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'New Stock Level',
          ),
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final newQuantity = int.tryParse(controller.text);
              if (newQuantity != null && newQuantity >= 0) {
                context.read<MaterialProvider>().updateMaterial(
                  material.copyWith(quantity: newQuantity),
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }
}

class _StockStatusChip extends StatelessWidget {
  final MaterialItem material;

  const _StockStatusChip({required this.material});

  @override
  Widget build(BuildContext context) {
    final isInStock = material.quantity >= material.minStockLevel;
    final color = isInStock ? Colors.green : Colors.orange;

    return Chip(
      label: Text(
        isInStock ? 'In Stock' : 'Low Stock',
        style: TextStyle(color: color),
      ),
      backgroundColor: color.withOpacity(0.1),
      side: BorderSide(color: color),
    );
  }
} 