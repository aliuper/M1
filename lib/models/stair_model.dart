import 'dart:convert';

class StairMaterial {
  final String materialId;
  final int quantity;
  final String? note;

  StairMaterial({
    required this.materialId,
    this.quantity = 1,
    this.note,
  });

  Map<String, dynamic> toMap() {
    return {
      'materialId': materialId,
      'quantity': quantity,
      'note': note,
    };
  }

  factory StairMaterial.fromMap(Map<String, dynamic> map) {
    return StairMaterial(
      materialId: map['materialId'] ?? '',
      quantity: map['quantity'] ?? 1,
      note: map['note'],
    );
  }

  StairMaterial copyWith({
    String? materialId,
    int? quantity,
    String? note,
  }) {
    return StairMaterial(
      materialId: materialId ?? this.materialId,
      quantity: quantity ?? this.quantity,
      note: note ?? this.note,
    );
  }
}

class StairModel {
  final String id;
  final String name;
  final String barcode;
  final String? description;
  final String? imagePath;
  final List<StairMaterial> materials;
  final DateTime createdAt;

  StairModel({
    required this.id,
    required this.name,
    required this.barcode,
    this.description,
    this.imagePath,
    required this.materials,
    required this.createdAt,
  });

  StairModel copyWith({
    String? id,
    String? name,
    String? barcode,
    String? description,
    String? imagePath,
    List<StairMaterial>? materials,
    DateTime? createdAt,
  }) {
    return StairModel(
      id: id ?? this.id,
      name: name ?? this.name,
      barcode: barcode ?? this.barcode,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
      materials: materials ?? this.materials,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'barcode': barcode,
      'description': description,
      'imagePath': imagePath,
      'materials': materials.map((m) => m.toMap()).toList(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory StairModel.fromMap(Map<String, dynamic> map) {
    return StairModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      barcode: map['barcode'] ?? '',
      description: map['description'],
      imagePath: map['imagePath'],
      materials: List<StairMaterial>.from(
        (map['materials'] as List?)?.map((m) => StairMaterial.fromMap(m)) ?? [],
      ),
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory StairModel.fromJson(String source) =>
      StairModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'StairModel(id: $id, name: $name, barcode: $barcode, materials: ${materials.length})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StairModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
