import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  static final SettingsProvider _instance = SettingsProvider._internal();
  factory SettingsProvider() => _instance;
  SettingsProvider._internal();

  bool _darkMode = false;
  double _fontSize = 22;
  int _lastSurah = 1;
  int _lastPage = 0;
  int _bookmarkSurah = 0;
  int _bookmarkPage = 0;

  bool get darkMode => _darkMode;
  double get fontSize => _fontSize;
  int get lastSurah => _lastSurah;
  int get lastPage => _lastPage;
  int get bookmarkSurah => _bookmarkSurah;
  int get bookmarkPage => _bookmarkPage;

  Future<void> load() async {
    final p = await SharedPreferences.getInstance();
    _darkMode = p.getBool('darkMode') ?? false;
    _fontSize = p.getDouble('fontSize') ?? 22;
    _lastSurah = p.getInt('lastSurah') ?? 1;
    _lastPage = p.getInt('lastPage') ?? 0;
    _bookmarkSurah = p.getInt('bookmarkSurah') ?? 0;
    _bookmarkPage = p.getInt('bookmarkPage') ?? 0;
    notifyListeners();
  }

  Future<void> setDarkMode(bool v) async {
    _darkMode = v;
    notifyListeners();
    final p = await SharedPreferences.getInstance();
    await p.setBool('darkMode', v);
  }

  Future<void> setFontSize(double v) async {
    _fontSize = v;
    notifyListeners();
    final p = await SharedPreferences.getInstance();
    await p.setDouble('fontSize', v);
  }

  Future<void> saveLastPosition(int surah, int page) async {
    _lastSurah = surah;
    _lastPage = page;
    final p = await SharedPreferences.getInstance();
    await p.setInt('lastSurah', surah);
    await p.setInt('lastPage', page);
  }

  Future<void> setBookmark(int surah, int page) async {
    _bookmarkSurah = surah;
    _bookmarkPage = page;
    notifyListeners();
    final p = await SharedPreferences.getInstance();
    await p.setInt('bookmarkSurah', surah);
    await p.setInt('bookmarkPage', page);
  }
}
