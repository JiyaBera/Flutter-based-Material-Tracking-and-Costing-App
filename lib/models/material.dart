class MaterialItem {
  final String id;
  final String name;
  final int quantity;
  final int minStockLevel;

  const MaterialItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.minStockLevel,
  });

  MaterialItem copyWith({
    String? id,
    String? name,
    int? quantity,
    int? minStockLevel,
  }) {
    return MaterialItem(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      minStockLevel: minStockLevel ?? this.minStockLevel,
    );
  }
} 