import 'package:flutter/material.dart';

class BottomNavVisibilityProvider extends ChangeNotifier {
  bool _isVisible = true; // Initially, the bottom nav is visible.

  bool get isVisible => _isVisible;

  void show() {
    if (!_isVisible) {
      _isVisible = true;
      notifyListeners(); // Notify listeners to rebuild widgets.
    }
  }

  void hide() {
    if (_isVisible) {
      _isVisible = false;
      notifyListeners(); // Notify listeners to rebuild widgets.
    }
  }
}
