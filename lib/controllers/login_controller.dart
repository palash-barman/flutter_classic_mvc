import 'package:demo_project/core/base/base_controller.dart';
import 'package:demo_project/core/utils/app_validator.dart';
import 'package:demo_project/models/login_response.dart';
import 'package:demo_project/routes/app_routes.dart';
import 'package:demo_project/services/api_endpoints.dart';
import 'package:demo_project/services/api_service.dart';
import 'package:demo_project/services/storage_service.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';



class LoginController extends BaseController {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController(text: "user@test.com");
  final passwordController = TextEditingController(text: "StrongPass123!");
  final obscurePassword = true.obs;

  final _api = ApiService();
  final _storage = StorageService();

  String? validateEmail(String? value) => AppValidator.validateEmail(value);

  String? validatePassword(String? value) => AppValidator.validatePassword(value);

  void togglePasswordVisibility() => obscurePassword.toggle();

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;

    var body = {
      "email": emailController.text.trim(),
      "password": passwordController.text,
    };

    final result = await apiCall<LoginResponse>(
      () async {
        final data = await _api.post(
          ApiEndpoints.login,
          body: body,
        );
        return LoginResponse.fromJson(data as Map<String, dynamic>);
      },
      showOverlay: false,
    );

    if (result != null) {
      await _storage.saveToken(result.data?.access ?? '');
      Get.offAllNamed(AppRoutes.products);
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}