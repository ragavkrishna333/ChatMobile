import 'package:chatapp/screens/Tabscreen.dart';
import 'package:chatapp/screens/login.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  Route onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => const Login(),
        );
      case 'Tabscreen':
        final int arguments = routeSettings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => Tabscreen(
            index: arguments,
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const Login(),
        );
    }
  }
}
