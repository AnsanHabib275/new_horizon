import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class AppNavigatorService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static Future<dynamic>? pushNamed(String routeName, {dynamic arguments}) {
    debugPrint('route by navigatorKey: $routeName');
    return AppNavigatorService.navigatorKey.currentState
        ?.pushNamed(routeName, arguments: arguments);
  }

  static void pop() {
    return AppNavigatorService.navigatorKey.currentState?.pop();
  }

  static void navigateToReplacement(String routeName, {dynamic arguments}) {
    navigatorKey.currentState
        ?.pushReplacementNamed(routeName, arguments: arguments);
  }

  static void navigateToAndRemoveAll(String routeName, {dynamic arguments}) {
    navigatorKey.currentState?.pushNamedAndRemoveUntil(
        routeName, (Route<dynamic> route) => false,
        arguments: arguments);
  }
}
