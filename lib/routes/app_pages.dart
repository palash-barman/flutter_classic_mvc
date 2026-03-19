import 'package:demo_project/views/screens/profile/profile_page.dart';
import 'package:get/get.dart';

import 'package:demo_project/controllers/products_controller.dart';
import 'package:demo_project/views/screens/auth/login_page.dart';
import 'package:demo_project/views/screens/products/products_page.dart';
import 'package:demo_project/routes/app_routes.dart';
import 'package:demo_project/routes/auth_middleware.dart';

class AppPages {
  AppPages._();

  static const initial = AppRoutes.login;

  static final pages = <GetPage>[ 
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
