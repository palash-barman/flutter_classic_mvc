import 'package:get/get.dart';

import 'package:flutter_classic_mvc/core/global/loading_controller.dart';
import 'package:flutter_classic_mvc/core/theme/theme_controller.dart';
import 'package:flutter_classic_mvc/core/localization/localization_controller.dart';

class GlobalBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(LoadingController(), permanent: true);
    Get.put(ThemeController(), permanent: true);
    Get.put(LocalizationController(), permanent: true);
  }
}
