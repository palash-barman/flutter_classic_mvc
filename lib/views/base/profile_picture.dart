import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo_project/core/theme/app_colors.dart';
import 'package:demo_project/views/base/custom_image_picker.dart';
import 'package:flutter/material.dart';


class ProfilePicture extends StatefulWidget {
  final double size;
  final String? imageUrl;
  final File? imageFile;
  final bool isEditable;
  final bool showLoading;
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
    this.showLoading = true,
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
        File? pickedImage = await customImagePicker();
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
                  color: widget.borderColor, width: widget.borderWidth),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius:
                  BorderRadius.circular(widget.isCircular ? widget.size : 16),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                switchInCurve: Curves.easeIn,
                switchOutCurve: Curves.easeOut,
                child: _buildImage(),
              ),
            ),
          ),
          if (widget.isEditable)
            Positioned(
              right: 0,
              bottom: 0,
              child: Center(
                child: Container(
                  height: widget.size * 0.32,
                  width: widget.size * 0.32,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white),
                  ),
                  child: Center(
                    child:Icon( 
                      Icons.edit,
                      color: Colors.white,
                      size: widget.size * 0.15,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    if (_currentFile != null) {
      return Image.file(
        _currentFile!,
        key: ValueKey(_currentFile!.path),
        width: widget.size,
        height: widget.size,
        fit: BoxFit.cover,
      );
    } else if (_currentUrl != null && _currentUrl!.isNotEmpty) {
      return CachedNetworkImage(
        key: ValueKey(_currentUrl),
        imageUrl: _currentUrl!,
        width: widget.size,
        height: widget.size,
        fit: BoxFit.cover,
        progressIndicatorBuilder: widget.showLoading
            ? (context, url, progress) => Center(
                  child: CircularProgressIndicator(
                    value: progress.progress,
                    strokeWidth: 2,
                    color: Colors.blue,
                  ),
                )
            : null,
        errorWidget: (context, url, error) => _placeholder(),
      );
    } else {
      return _placeholder();
    }
  }

  Widget _placeholder() {
    return Container(
      key: const ValueKey('placeholder'),
      width: widget.size,
      height: widget.size,
      color: Colors.grey[300],
      padding: EdgeInsets.all(widget.size * 0.17),
      child: Image.asset(
        widget.placeholderAsset,
        fit: BoxFit.contain,
       // colorFilter: ColorFilter.mode(Colors.blue, BlendMode.srcIn),
      ),
    );
  }
}