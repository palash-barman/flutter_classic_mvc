import 'package:demo_project/routes/app_routes.dart';
import 'package:demo_project/services/storage_service.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  final _storage = StorageService();

  @override
  void onInit() {
    super.onInit();
    _navigateToNextScreen();
  }
  

  /// Check if user is logged in and navigate accordingly
  Future<void> _navigateToNextScreen() async {
    // Simulate splash screen delay for better UX
    await Future.delayed(const Duration(seconds: 2));

    if (_storage.isLoggedIn) {
      Get.offAllNamed(AppRoutes.products);
    } else {
      Get.offAllNamed(AppRoutes.login);
    }
  }

}
