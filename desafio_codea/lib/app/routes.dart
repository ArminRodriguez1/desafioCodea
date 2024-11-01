import 'package:flutter/material.dart';
import 'package:desafio_codea/app/pages.dart';
import 'package:desafio_codea/app/pages/activity_screen.dart';
import 'package:desafio_codea/app/pages/login.dart';

class Routes {
  static final routeObserver = RouteObserver<PageRoute>();

  static Route<dynamic> getRoutes(RouteSettings settings) {
    switch (settings.name) {
      case Pages.ActivityScreen:
        return _buildRoute(settings, const ActividadesScreen());
      default:
        return _buildRoute(settings, const LoginPage());
    }
  }

  static MaterialPageRoute<dynamic> _buildRoute(
      RouteSettings settings, Widget builder) {
    return MaterialPageRoute<dynamic>(
      settings: settings,
      builder: (BuildContext context) => builder,
    );
  }
}
