import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';

class CustomImage extends StatelessWidget {
  final String path;
  final double width;
  final double height;
  final Border? border;
  final BorderRadius? borderRadius;
  final BoxShape boxShape;
  final Color? backgroundColor;
  final Widget? child; 
  final ColorFilter? colorFilter;
  final BoxFit fit;

  const CustomImage({
    super.key,
    required this.path,
    this.width = 50,
    this.height = 50,
    this.border,
    this.borderRadius,
    this.boxShape = BoxShape.rectangle,
    this.backgroundColor,
    this.child,
    this.colorFilter,
    this.fit = BoxFit.cover,
  });

  bool get _isSvg => path.toLowerCase().endsWith('.svg');
  bool get _isNetwork => path.startsWith('http');

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;

    if (_isSvg) {
      imageWidget = _isNetwork
          ? SvgPicture.network(
              path,
              width: width,
              height: height,
              fit: fit,
              colorFilter: colorFilter,
              placeholderBuilder: (_) => _shimmerPlaceholder(),
            )
          : SvgPicture.asset(
              path,
              width: width,
              height: height,
              fit: fit,
              colorFilter: colorFilter,
            );
    } else {
      imageWidget = _isNetwork
          ? CachedNetworkImage(
              imageUrl: path,
              imageBuilder: (context, imageProvider) => Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                  border: border,
                  borderRadius: borderRadius,
                  shape: boxShape,
                  color: backgroundColor,
                  image: DecorationImage(
                    image: imageProvider,
                    fit: fit,
                    colorFilter: colorFilter,
                  ),
                ),
                child: child,
              ),
              placeholder: (context, url) => _shimmerPlaceholder(),
              errorWidget: (context, url, error) => _errorWidget(),
            )
          : Image.asset(
              path,
              width: width,
              height: height,
              fit: fit,
              errorBuilder: (_, __, ___) => _errorWidget(),
            );
    }

    return ClipRRect(
      borderRadius: boxShape == BoxShape.circle
          ? BorderRadius.circular(width / 2)
          : borderRadius ?? BorderRadius.zero,
      child: imageWidget,
    );
  }

  Widget _shimmerPlaceholder() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.withOpacity(0.6),
      highlightColor: Colors.grey.withOpacity(0.3),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          border: border,
          color: backgroundColor ?? Colors.grey.withOpacity(0.6),
          borderRadius: borderRadius,
          shape: boxShape,
        ),
      ),
    );
  }

  Widget _errorWidget() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        border: border,
        color: backgroundColor ?? Colors.grey.withOpacity(0.6),
        borderRadius: borderRadius,
        shape: boxShape,
      ),
      child: const Icon(Icons.error),
    );
  }
}