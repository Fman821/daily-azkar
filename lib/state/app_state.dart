import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// User data kept on the device: favourites, dhikr counters, tasbih, name and
/// text size. Every change is saved to SharedPreferences and then notifies the UI.
class AppState extends ChangeNotifier {
  AppState._(this._prefs) {
    _favorites = (_prefs.getStringList(_kFavorites) ?? const <String>[]).toSet();
    _progress = _readProgress();
    _tasbih = _prefs.getInt(_kTasbih) ?? 0;
    _name = _prefs.getString(_kName) ?? '';
    _fontScale = _prefs.getDouble(_kFontScale) ?? 1.0;
    _arabicScale = _prefs.getDouble(_kArabicScale) ?? 1.0;
    _showTranslit = _prefs.getBool(_kShowTranslit) ?? true;
    _showAmharic = _prefs.getBool(_kShowAmharic) ?? true;
    _hapticOn = _prefs.getBool(_kHaptic) ?? true;
    _tasbihTarget = _prefs.getInt(_kTasbihTarget) ?? 33;
  }

  static const _kFavorites = 'favorites';
  static const _kProgress = 'progress';
  static const _kTasbih = 'tasbih';
  static const _kName = 'name';
  static const _kFontScale = 'fontScale';
  static const _kArabicScale = 'arabicScale';
  static const _kShowTranslit = 'showTranslit';
  static const _kShowAmharic = 'showAmharic';
  static const _kHaptic = 'haptic';
  static const _kTasbihTarget = 'tasbihTarget';

  static Future<AppState> create() async {
    final prefs = await SharedPreferences.getInstance();
    return AppState._(prefs);
  }

  final SharedPreferences _prefs;
  late Set<String> _favorites;
  late Map<String, int> _progress;
  late int _tasbih;
  late String _name;
  late double _fontScale;
  late double _arabicScale;
  late bool _showTranslit;
  late bool _showAmharic;
  late bool _hapticOn;
  late int _tasbihTarget;

  Set<String> get favorites => Set.unmodifiable(_favorites);
  bool isFavorite(String key) => _favorites.contains(key);

  int progressOf(String key) => _progress[key] ?? 0;

  int get tasbih => _tasbih;
  String get name => _name;
  double get fontScale => _fontScale;
  double get arabicScale => _arabicScale;
  bool get showTranslit => _showTranslit;
  bool get showAmharic => _showAmharic;
  bool get hapticOn => _hapticOn;
  int get tasbihTarget => _tasbihTarget;

  void toggleFavorite(String key) {
    if (!_favorites.remove(key)) {
      _favorites.add(key);
    }
    unawaited(_prefs.setStringList(_kFavorites, _favorites.toList()));
    notifyListeners();
  }

  /// Counts one recitation, never going past [repeat].
  void tapDhikr(String key, int repeat) {
    final current = progressOf(key);
    if (current >= repeat) return;
    _progress[key] = current + 1;
    _saveProgress();
    notifyListeners();
  }

  void resetDhikr(String key) {
    _progress.remove(key);
    _saveProgress();
    notifyListeners();
  }

  void resetCategory(String categoryId) {
    final prefix = '$categoryId:';
    _progress.removeWhere((key, value) => key.startsWith(prefix));
    _saveProgress();
    notifyListeners();
  }

  void tapTasbih() {
    _tasbih++;
    unawaited(_prefs.setInt(_kTasbih, _tasbih));
    notifyListeners();
  }

  void resetTasbih() {
    _tasbih = 0;
    unawaited(_prefs.setInt(_kTasbih, _tasbih));
    notifyListeners();
  }

  void resetAllCounts() {
    _progress.clear();
    _tasbih = 0;
    _saveProgress();
    unawaited(_prefs.setInt(_kTasbih, _tasbih));
    notifyListeners();
  }

  void setName(String value) {
    _name = value.trim();
    unawaited(_prefs.setString(_kName, _name));
    notifyListeners();
  }

  void setFontScale(double value) {
    _fontScale = value;
    unawaited(_prefs.setDouble(_kFontScale, value));
    notifyListeners();
  }

  void setArabicScale(double value) {
    _arabicScale = value;
    unawaited(_prefs.setDouble(_kArabicScale, value));
    notifyListeners();
  }

  void setShowTranslit(bool value) {
    _showTranslit = value;
    unawaited(_prefs.setBool(_kShowTranslit, value));
    notifyListeners();
  }

  void setShowAmharic(bool value) {
    _showAmharic = value;
    unawaited(_prefs.setBool(_kShowAmharic, value));
    notifyListeners();
  }

  void setHapticOn(bool value) {
    _hapticOn = value;
    unawaited(_prefs.setBool(_kHaptic, value));
    notifyListeners();
  }

  void setTasbihTarget(int value) {
    _tasbihTarget = value;
    unawaited(_prefs.setInt(_kTasbihTarget, value));
    notifyListeners();
  }

  Map<String, int> _readProgress() {
    final raw = _prefs.getString(_kProgress);
    if (raw == null) return {};
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      return decoded.map((key, value) => MapEntry(key, value as int));
    } catch (_) {
      return {};
    }
  }

  void _saveProgress() {
    unawaited(_prefs.setString(_kProgress, jsonEncode(_progress)));
  }
}
