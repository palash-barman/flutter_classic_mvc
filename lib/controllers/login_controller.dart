import 'package:demo_project/routes/app_routes.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'package:demo_project/services/api_service.dart';
import 'package:demo_project/services/api_endpoints.dart';
import 'package:demo_project/services/storage_service.dart';

import 'package:demo_project/models/login_response.dart';
import 'package:demo_project/core/utils/app_validator.dart';


class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController(text: "user@test.com");
  final passwordController = TextEditingController(text: "StrongPass123!");
  final obscurePassword = true.obs;
  
  // Loading state
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final hasError = false.obs;

  final _api = ApiService();
  final _storage = StorageService();

  String? validateEmail(String? value) => AppValidator.validateEmail(value);
  String? validatePassword(String? value) => AppValidator.validatePassword(value);

  void togglePasswordVisibility() => obscurePassword.toggle();

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;

    try {
      isLoading.value = true;
      errorMessage.value = '';
      hasError.value = false;

      var body = {
        "email": emailController.text.trim(),
        "password": passwordController.text,
      };

      final response = await _api.post(
        ApiEndpoints.login,
        body: body,
      );

      final loginResponse = LoginResponse.fromJson(response as Map<String, dynamic>);
      
      if (loginResponse.data != null) {
        await _storage.saveToken(loginResponse.data!.access ?? '');
        Get.offAllNamed(AppRoutes.products);
      } else {
        errorMessage.value = 'Login failed. Please try again.';
        hasError.value = true;
      }
    } catch (e) {
      errorMessage.value = e.toString();
      hasError.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
