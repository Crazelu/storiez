import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

abstract class NavigationHandler {
  ///Pushes `destinationRoute` route onto the stack
  Future<Object?>? pushNamed(String destinationRoute, {Object? arguments});

  ///Pushes `destinationRoute` onto stack and removes stack items until
  ///`lastRoute` is hit
  Future<Object?>? pushNamedAndRemoveUntil(
    String destinationRoute,
    String lastRoute, {
    Object? arguments,
  });

  ///Pushes `destinationRoute` onto stack with replacement
  Future<Object?>? pushReplacementNamed(
    String destinationRoute, {
    Object? arguments,
  });

  ///Pushes `destinationRoute` after popping current route off stack
  Future<Object?>? popAndPushNamed(
    String destinationRoute, {
    Object? arguments,
  });

  ///Pops current route off stack
  void pop();

  ///Pops routes on stack until `destinationRoute` is hit
  void popUntil(String destinationRoute);

  ///Exits app
  void exitApp();

  late GlobalKey<NavigatorState> navigatorKey;
}

/// Handles navigation
class NavigationHandlerImpl implements NavigationHandler {
  @override
  late GlobalKey<NavigatorState> navigatorKey;

  /// Constructs a NavigationHandler instance
  NavigationHandlerImpl({GlobalKey<NavigatorState>? navigatorKey}) {
    this.navigatorKey = navigatorKey ?? GlobalKey<NavigatorState>();
  }

  NavigatorState? get _state => navigatorKey.currentState;

  @override
  void exitApp() {
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  }

  @override
  void pop() {
    return _state?.pop();
  }

  @override
  Future<Object?>? popAndPushNamed(
    String destinationRoute, {
    Object? arguments,
  }) {
    return _state?.popAndPushNamed(destinationRoute, arguments: arguments);
  }

  @override
  void popUntil(String destinationRoute) {
    return _state?.popUntil(ModalRoute.withName(destinationRoute));
  }

  @override
  Future<Object?>? pushNamed(
    String destinationRoute, {
    Object? arguments,
  }) {
    return _state?.pushNamed(destinationRoute, arguments: arguments);
  }

  @override
  Future<Object?>? pushNamedAndRemoveUntil(
    String destinationRoute,
    String lastRoute, {
    Object? arguments,
  }) {
    return _state?.pushNamedAndRemoveUntil(
      destinationRoute,
      ModalRoute.withName(lastRoute),
      arguments: arguments,
    );
  }

  @override
  Future<Object?>? pushReplacementNamed(
    String destinationRoute, {
    Object? arguments,
  }) {
    return _state?.pushReplacementNamed(destinationRoute, arguments: arguments);
  }
}
