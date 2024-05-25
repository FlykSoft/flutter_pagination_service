import 'package:flutter/material.dart';

class PaginationRefreshListenable extends Listenable {
  final List<VoidCallback> _listeners = [];

  void refresh() {
    for (final listener in _listeners) {
      listener.call();
    }
  }

  @override
  void addListener(VoidCallback listener) => _listeners.add(listener);

  @override
  void removeListener(VoidCallback listener) => _listeners.remove(listener);
}
