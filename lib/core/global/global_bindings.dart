import 'package:get/get.dart';

import 'package:demo_project/core/global/loading_controller.dart';
import 'package:demo_project/core/theme/theme_controller.dart';
import 'package:demo_project/core/localization/localization_controller.dart';

class GlobalBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(LoadingController(), permanent: true);
    Get.put(ThemeController(), permanent: true);
    Get.put(LocalizationController(), permanent: true);
  }
}
