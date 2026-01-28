import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/material_item.dart';

class MaterialProvider with ChangeNotifier {
  List<MaterialItem> _materials = [];
  bool _isLoading = false;
  String? _error;

  List<MaterialItem> get materials => _materials;
  bool get isLoading => _isLoading;
  String? get error => _error;

  MaterialProvider() {
    loadMaterials();
  }

  Future<void> loadMaterials() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final materialsJson = prefs.getString('materials');
      
      if (materialsJson != null) {
        final List<dynamic> decoded = json.decode(materialsJson);
        _materials = decoded.map((m) => MaterialItem.fromMap(m)).toList();
        _materials.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      }
    } catch (e) {
      _error = 'Malzemeler yüklenirken hata oluştu: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _saveMaterials() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final materialsJson = json.encode(_materials.map((m) => m.toMap()).toList());
      await prefs.setString('materials', materialsJson);
    } catch (e) {
      _error = 'Malzemeler kaydedilirken hata oluştu: $e';
      notifyListeners();
    }
  }

  Future<void> addMaterial({
    required String name,
    String? description,
    String? imagePath,
  }) async {
    final material = MaterialItem(
      id: const Uuid().v4(),
      name: name,
      description: description,
      imagePath: imagePath,
      createdAt: DateTime.now(),
    );

    _materials.insert(0, material);
    notifyListeners();
    await _saveMaterials();
  }

  Future<void> updateMaterial(MaterialItem material) async {
    final index = _materials.indexWhere((m) => m.id == material.id);
    if (index != -1) {
      _materials[index] = material;
      notifyListeners();
      await _saveMaterials();
    }
  }

  Future<void> deleteMaterial(String id) async {
    // Delete image file if exists
    final material = _materials.firstWhere((m) => m.id == id);
    if (material.imagePath != null) {
      try {
        final file = File(material.imagePath!);
        if (await file.exists()) {
          await file.delete();
        }
      } catch (e) {
        // Ignore file deletion errors
      }
    }

    _materials.removeWhere((m) => m.id == id);
    notifyListeners();
    await _saveMaterials();
  }

  MaterialItem? getMaterialById(String id) {
    try {
      return _materials.firstWhere((m) => m.id == id);
    } catch (e) {
      return null;
    }
  }

  List<MaterialItem> searchMaterials(String query) {
    if (query.isEmpty) return _materials;
    final lowerQuery = query.toLowerCase();
    return _materials.where((m) => 
      m.name.toLowerCase().contains(lowerQuery) ||
      (m.description?.toLowerCase().contains(lowerQuery) ?? false)
    ).toList();
  }

  Future<void> exportMaterials(String filePath) async {
    try {
      final file = File(filePath);
      final data = json.encode(_materials.map((m) => m.toMap()).toList());
      await file.writeAsString(data);
    } catch (e) {
      _error = 'Dışa aktarma hatası: $e';
      notifyListeners();
    }
  }

  Future<void> importMaterials(String filePath) async {
    try {
      final file = File(filePath);
      final content = await file.readAsString();
      final List<dynamic> decoded = json.decode(content);
      final imported = decoded.map((m) => MaterialItem.fromMap(m)).toList();
      
      for (var material in imported) {
        if (!_materials.any((m) => m.id == material.id)) {
          _materials.add(material);
        }
      }
      
      _materials.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      notifyListeners();
      await _saveMaterials();
    } catch (e) {
      _error = 'İçe aktarma hatası: $e';
      notifyListeners();
    }
  }
}
