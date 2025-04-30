import 'package:flutter/foundation.dart';
import '../models/material.dart';

class MaterialProvider with ChangeNotifier {
  final List<MaterialItem> _materials = [];
  bool? _stockFilter;

  List<MaterialItem> get materials {
    if (_stockFilter == null) {
      return _materials;
    }
    return _materials.where((material) {
      final isInStock = material.quantity >= material.minStockLevel;
      return _stockFilter == isInStock;
    }).toList();
  }

  void addMaterial(MaterialItem material) {
    _materials.add(material);
    notifyListeners();
  }

  void updateMaterial(MaterialItem material) {
    final index = _materials.indexWhere((m) => m.id == material.id);
    if (index != -1) {
      _materials[index] = material;
      notifyListeners();
    }
  }

  void deleteMaterial(String id) {
    _materials.removeWhere((material) => material.id == id);
    notifyListeners();
  }

  void filterMaterials(bool? inStock) {
    _stockFilter = inStock;
    notifyListeners();
  }
} 