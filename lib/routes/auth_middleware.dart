import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'package:demo_project/services/storage_service.dart';
import 'package:demo_project/routes/app_routes.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    final storage = StorageService();
    if (!storage.isLoggedIn) {
      return const RouteSettings(name: AppRoutes.login);
    }
    return null;
  }
}
