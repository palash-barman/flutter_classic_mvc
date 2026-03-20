import 'dart:io';
import 'package:flutter_classic_mvc/core/theme/app_colors.dart';
import 'package:flutter_classic_mvc/views/base/custom_image_picker.dart';
import 'package:flutter/material.dart';
import 'custom_image.dart'; // <-- import your CustomImage

class ProfilePicture extends StatefulWidget {
  final double size;
  final String? imageUrl;
  final File? imageFile;
  final bool isEditable;
  final bool isCircular;
  final double borderWidth;
  final Color borderColor;
  final Function(File)? onImagePicked;
  final String placeholderAsset;

  const ProfilePicture({
    super.key,
    this.size = 100,
    this.imageUrl,
    this.imageFile,
    this.isEditable = false,
    this.isCircular = true,
    this.borderWidth = 2,
    this.borderColor = Colors.grey,
    this.onImagePicked,
    this.placeholderAsset = "assets/images/user_placeholder.png",
  });

  @override
  State<ProfilePicture> createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {
  File? _currentFile;
  String? _currentUrl;

  @override
  void initState() {
    super.initState();
    _currentFile = widget.imageFile;
    _currentUrl = widget.imageUrl;
  }

  @override
  void didUpdateWidget(covariant ProfilePicture oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageFile != widget.imageFile) {
      setState(() => _currentFile = widget.imageFile);
    }
    if (oldWidget.imageUrl != widget.imageUrl) {
      setState(() => _currentUrl = widget.imageUrl);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () async {
        if (!widget.isEditable) return;
        File? pickedImage = await customImagePicker(
          isCircular: true,
          isSquared: false,
        );
        if (pickedImage != null && widget.onImagePicked != null) {
          widget.onImagePicked!(pickedImage);
        }
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: widget.size,
            height: widget.size,
            padding: EdgeInsets.all(widget.borderWidth),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              shape: BoxShape.circle,
              border: Border.all(
                color: widget.borderColor,
                width: widget.borderWidth,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: CustomImage(
              path:
                  _currentFile?.path ?? _currentUrl ?? widget.placeholderAsset,
              width: widget.size,
              height: widget.size,
              boxShape: widget.isCircular
                  ? BoxShape.circle
                  : BoxShape.rectangle,
              backgroundColor: Colors.grey[300],
            ),
          ),
          if (widget.isEditable)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                height: widget.size * 0.32,
                width: widget.size * 0.32,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white),
                ),
                child: Center(
                  child: Icon(
                    Icons.edit,
                    color: Colors.white,
                    size: widget.size * 0.15,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
