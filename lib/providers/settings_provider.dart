import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

class SettingsProvider with ChangeNotifier {
  String _dataPath = '';
  bool _isLoading = false;
  bool _darkMode = false;

  String get dataPath => _dataPath;
  bool get isLoading => _isLoading;
  bool get darkMode => _darkMode;

  SettingsProvider() {
    loadSettings();
  }

  Future<void> loadSettings() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      _darkMode = prefs.getBool('darkMode') ?? false;
      
      final savedPath = prefs.getString('dataPath');
      if (savedPath != null && savedPath.isNotEmpty) {
        _dataPath = savedPath;
      } else {
        final appDir = await getApplicationDocumentsDirectory();
        _dataPath = appDir.path;
      }
    } catch (e) {
      final appDir = await getApplicationDocumentsDirectory();
      _dataPath = appDir.path;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> setDataPath(String path) async {
    _dataPath = path;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('dataPath', path);
  }

  Future<void> setDarkMode(bool value) async {
    _darkMode = value;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', value);
  }

  Future<String> getDefaultPath() async {
    final appDir = await getApplicationDocumentsDirectory();
    return appDir.path;
  }
}
