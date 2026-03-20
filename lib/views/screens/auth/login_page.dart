import 'package:demo_project/views/base/custom_button.dart';
import 'package:demo_project/views/base/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_project/core/localization/language_selection.dart';
import 'package:demo_project/core/theme/theme_controller.dart';
import 'package:demo_project/controllers/login_controller.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    final themeController = Get.find<ThemeController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('login'.tr),
        actions: [
          IconButton(
            icon: Obx(
              () => Icon(
                themeController.isDarkMode ? Icons.light_mode : Icons.dark_mode,
              ),
            ),
            onPressed: themeController.toggleTheme,
          ),
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const LanguageSelectionDialog(),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 48),
                Icon(
                  Icons.lock_outline,
                  size: 80,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(height: 32),
                Text(
                  'app_name'.tr,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 48),

                CustomTextField(
                  controller: controller.emailController,
                  labelText: 'email'.tr,
                  isEmail: true,
                  prefixIcon: const Icon(Icons.email_outlined),
                ),
                const SizedBox(height: 16),

                CustomTextField(
                  controller: controller.passwordController,
                  labelText: 'password'.tr,
                  isPassword: true,
                  prefixIcon: const Icon(Icons.lock_outlined),
                ),

                const SizedBox(height: 8),
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: TextButton(
                    onPressed: () {},
                    child: Text('forgot_password'.tr),
                  ),
                ),
                const SizedBox(height: 24),
                Obx(
                  () => CustomButton(
                    onTap: () {
                      if (controller.formKey.currentState!.validate()) {
                        controller.login();
                      }
                    },
                    text: "login".tr,
                    loading: controller.isLoading.value,
                    type: ButtonType.filled,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('dont_have_account'.tr),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'register'.tr,
                        style: const TextStyle(color: Colors.green),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
