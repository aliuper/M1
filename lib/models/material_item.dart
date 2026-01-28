import 'dart:convert';

class MaterialItem {
  final String id;
  final String name;
  final String? description;
  final String? imagePath;
  final DateTime createdAt;

  MaterialItem({
    required this.id,
    required this.name,
    this.description,
    this.imagePath,
    required this.createdAt,
  });

  MaterialItem copyWith({
    String? id,
    String? name,
    String? description,
    String? imagePath,
    DateTime? createdAt,
  }) {
    return MaterialItem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imagePath': imagePath,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory MaterialItem.fromMap(Map<String, dynamic> map) {
    return MaterialItem(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'],
      imagePath: map['imagePath'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory MaterialItem.fromJson(String source) =>
      MaterialItem.fromMap(json.decode(source));

  @override
  String toString() {
    return 'MaterialItem(id: $id, name: $name, description: $description, imagePath: $imagePath)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MaterialItem && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
