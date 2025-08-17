import 'package:flutter/material.dart';

// Make sure Flutter SDK is properly installed and 'flutter pub get' is run
// to download dependencies including the material.dart package

class LocaleProvider extends ChangeNotifier {
  Locale? _locale;
  Locale? get locale => _locale;

  void setLocale(Locale? locale) {
    if (locale == _locale) return;
    _locale = locale;
    notifyListeners();
  }

  void clearLocale() {
    _locale = null;
    notifyListeners();
  }
}
