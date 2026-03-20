import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_classic_mvc/core/localization/localization_controller.dart';

class LanguageSelectionDialog extends StatelessWidget {
  const LanguageSelectionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final localizationController = Get.find<LocalizationController>();

    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'language'.tr,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const Divider(),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: LocalizationController.availableLanguages.length,
              itemBuilder: (context, index) {
                final language = LocalizationController.availableLanguages[index];
                final isSelected = localizationController.locale.languageCode == language.code;

                return ListTile(
                  title: Text(language.name),
                  subtitle: Text(language.nativeName),
                  trailing: isSelected ? Icon(Icons.check, color: Theme.of(context).primaryColor) : null,
                  onTap: () {
                    localizationController.changeLanguage(language);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('close'.tr),
            ),
          ),
        ],
      ),
    );
  }
}

class LanguageSelectionBottomSheet extends StatelessWidget {
  const LanguageSelectionBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final localizationController = Get.find<LocalizationController>();

    return Container(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'language'.tr,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: LocalizationController.availableLanguages.length,
              itemBuilder: (context, index) {
                final language = LocalizationController.availableLanguages[index];
                final isSelected = localizationController.locale.languageCode == language.code;

                return ListTile(
                  title: Text(language.name),
                  subtitle: Text(language.nativeName),
                  trailing: isSelected ? Icon(Icons.check, color: Theme.of(context).primaryColor) : null,
                  onTap: () {
                    localizationController.changeLanguage(language);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
