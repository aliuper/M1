import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/stair_model.dart';

class StairProvider with ChangeNotifier {
  List<StairModel> _stairs = [];
  bool _isLoading = false;
  String? _error;

  List<StairModel> get stairs => _stairs;
  bool get isLoading => _isLoading;
  String? get error => _error;

  StairProvider() {
    loadStairs();
  }

  Future<void> loadStairs() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final stairsJson = prefs.getString('stairs');
      
      if (stairsJson != null) {
        final List<dynamic> decoded = json.decode(stairsJson);
        _stairs = decoded.map((s) => StairModel.fromMap(s)).toList();
        _stairs.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      }
    } catch (e) {
      _error = 'Merdivenler yüklenirken hata oluştu: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _saveStairs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final stairsJson = json.encode(_stairs.map((s) => s.toMap()).toList());
      await prefs.setString('stairs', stairsJson);
    } catch (e) {
      _error = 'Merdivenler kaydedilirken hata oluştu: $e';
      notifyListeners();
    }
  }

  Future<void> addStair({
    required String name,
    required String barcode,
    String? description,
    String? imagePath,
    required List<StairMaterial> materials,
  }) async {
    final stair = StairModel(
      id: const Uuid().v4(),
      name: name,
      barcode: barcode,
      description: description,
      imagePath: imagePath,
      materials: materials,
      createdAt: DateTime.now(),
    );

    _stairs.insert(0, stair);
    notifyListeners();
    await _saveStairs();
  }

  Future<void> updateStair(StairModel stair) async {
    final index = _stairs.indexWhere((s) => s.id == stair.id);
    if (index != -1) {
      _stairs[index] = stair;
      notifyListeners();
      await _saveStairs();
    }
  }

  Future<void> deleteStair(String id) async {
    final stair = _stairs.firstWhere((s) => s.id == id);
    if (stair.imagePath != null) {
      try {
        final file = File(stair.imagePath!);
        if (await file.exists()) {
          await file.delete();
        }
      } catch (e) {
        // Ignore file deletion errors
      }
    }

    _stairs.removeWhere((s) => s.id == id);
    notifyListeners();
    await _saveStairs();
  }

  StairModel? getStairById(String id) {
    try {
      return _stairs.firstWhere((s) => s.id == id);
    } catch (e) {
      return null;
    }
  }

  StairModel? getStairByBarcode(String barcode) {
    try {
      return _stairs.firstWhere((s) => s.barcode == barcode);
    } catch (e) {
      return null;
    }
  }

  List<StairModel> searchStairs(String query) {
    if (query.isEmpty) return _stairs;
    final lowerQuery = query.toLowerCase();
    return _stairs.where((s) => 
      s.name.toLowerCase().contains(lowerQuery) ||
      s.barcode.toLowerCase().contains(lowerQuery) ||
      (s.description?.toLowerCase().contains(lowerQuery) ?? false)
    ).toList();
  }

  Future<void> exportStairs(String filePath) async {
    try {
      final file = File(filePath);
      final data = json.encode(_stairs.map((s) => s.toMap()).toList());
      await file.writeAsString(data);
    } catch (e) {
      _error = 'Dışa aktarma hatası: $e';
      notifyListeners();
    }
  }

  Future<void> importStairs(String filePath) async {
    try {
      final file = File(filePath);
      final content = await file.readAsString();
      final List<dynamic> decoded = json.decode(content);
      final imported = decoded.map((s) => StairModel.fromMap(s)).toList();
      
      for (var stair in imported) {
        if (!_stairs.any((s) => s.id == stair.id)) {
          _stairs.add(stair);
        }
      }
      
      _stairs.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      notifyListeners();
      await _saveStairs();
    } catch (e) {
      _error = 'İçe aktarma hatası: $e';
      notifyListeners();
    }
  }
}
