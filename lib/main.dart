import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutter_classic_mvc/core/config/environment.dart';
import 'package:flutter_classic_mvc/core/global/global_bindings.dart';
import 'package:flutter_classic_mvc/core/global/loading_overlay.dart';
import 'package:flutter_classic_mvc/core/localization/app_translations.dart';
import 'package:flutter_classic_mvc/core/localization/localization_controller.dart';
import 'package:flutter_classic_mvc/services/storage_service.dart';
import 'package:flutter_classic_mvc/core/theme/app_theme.dart';
import 'package:flutter_classic_mvc/core/theme/theme_controller.dart';
import 'package:flutter_classic_mvc/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize environment
  EnvironmentConfig.init(Environment.dev);

  // Initialize storage
  await StorageService.init();

  // Run global bindings before app starts
  GlobalBindings().dependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final localizationController = Get.find<LocalizationController>();

    return Obx(() => GetMaterialApp(
          title: 'Demo Project',
          debugShowCheckedModeBanner: false,

          // Theme
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: themeController.themeMode,

          // Localization
          translations: AppTranslations(),
          locale: localizationController.locale,
          fallbackLocale: const Locale('en', 'US'),

          // Routes
          initialRoute: AppPages.initial,
          getPages: AppPages.pages,

          // Loading overlay
          builder: (context, child) => LoadingOverlay(
            child: child ?? const SizedBox.shrink(),
          ),
        ));
  }
}
