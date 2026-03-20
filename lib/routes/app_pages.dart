import 'package:flutter_classic_mvc/views/screens/profile/profile_page.dart';
import 'package:flutter_classic_mvc/views/screens/splash/splash_page.dart';
import 'package:get/get.dart';

import 'package:flutter_classic_mvc/controllers/products_controller.dart';
import 'package:flutter_classic_mvc/views/screens/auth/login_page.dart';
import 'package:flutter_classic_mvc/views/screens/products/products_page.dart';
import 'package:flutter_classic_mvc/routes/app_routes.dart';
import 'package:flutter_classic_mvc/routes/auth_middleware.dart';

class AppPages {
  AppPages._();

  static const initial = AppRoutes.splash;

  static final pages = <GetPage>[ 
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashPage(),
    ),

    GetPage(
      name: AppRoutes.login,
      page: () => const LoginPage(),
    ),
 
    GetPage(
      name: AppRoutes.products,
      page: () {
        Get.put(ProductsController());
        return const ProductsPage();
      },
      middlewares: [AuthMiddleware()],
    ),

    GetPage(
      name: AppRoutes.profile, 
      page: () => const ProfilePage(),
      middlewares: [AuthMiddleware()],
    )
  ];
}
