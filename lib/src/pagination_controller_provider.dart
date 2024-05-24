import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:pagination_service/src/pagination_controller.dart';

class PaginationControllerProvider<T> extends InheritedWidget {
  final PaginationController<T> controller;

  const PaginationControllerProvider({
    required this.controller,
    required super.child,
    super.key,
  });

  static PaginationController<T> of<T>(BuildContext context) {
    final result = context
        .dependOnInheritedWidgetOfExactType<PaginationControllerProvider<T>>();
    assert(
        result != null,
        'No PaginationControllerProvider<$T> found in context. '
        'To solve this issue either wrap material app with '
        '\'PaginationControllerProvider<$T>\' or provide controller argument in '
        'respected pagination view class.');
    return result!.controller;
  }

  static PaginationController<T>? maybeOf<T>(BuildContext context) {
    final result = context
        .dependOnInheritedWidgetOfExactType<PaginationControllerProvider<T>>();
    if (result == null && kDebugMode) {
      print('No PaginationControllerProvider<$T> found in context. '
          'To solve this issue either wrap material app with '
          '\'PaginationControllerProvider<$T>\' or provide controller argument in '
          'respected pagination view class.');
    }
    return result?.controller;
  }

  @override
  bool updateShouldNotify(PaginationControllerProvider oldWidget) =>
      oldWidget.controller != controller;
}
