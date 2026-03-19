import 'dart:io';
import 'package:demo_project/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

Future<File?> customImagePicker({
  bool isCircular = true,
  bool isSquared = true,
  ImageSource source = ImageSource.gallery,
  int? imageQuality = 85,
  bool enableCrop = true,
}) async {
  try {
    if (!Platform.isAndroid && !Platform.isIOS) return null;

    final picker = ImagePicker();
    final cropper = ImageCropper();

    // Pick image
    final XFile? pickedImage = await picker.pickImage(
      source: source,
      imageQuality: imageQuality,
    );

    if (pickedImage == null) return null; // user cancelled

    if (!enableCrop) return File(pickedImage.path);

    // Crop image
    final CroppedFile? croppedImage = await cropper.cropImage(
      sourcePath: pickedImage.path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop your image',
          toolbarColor: AppColors.primary,
          toolbarWidgetColor: Colors.white,
          backgroundColor: AppColors.primary,
          hideBottomControls: !isSquared,
        ),
        IOSUiSettings(
          title: 'Crop your image',
          aspectRatioLockEnabled: isSquared,
        ),
      ],
    );

    if (croppedImage == null) return null;

    return File(croppedImage.path);
  } catch (e, st) {
    debugPrint("Error picking or cropping image: $e\n$st");
    return null;
  }
}