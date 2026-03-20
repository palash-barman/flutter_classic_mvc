import 'package:flutter/material.dart';

enum ButtonType { filled, outlined }

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.onTap,
    required this.text,
    this.loading = false,
    this.loadingText,
    // modified defaults height and width to be more compact
    this.height = 50,
    this.width,
    // modified default radius to be more rounded
    this.radius = 24,
    this.margin = EdgeInsets.zero,
    this.color,
    this.textColor,
    this.textStyle,
    this.icon,
    this.elevation = 0,
    this.borderSide,
    this.type = ButtonType.filled,
  });

  // Required
  final VoidCallback onTap;
  final String text;

  // Loader
  final bool loading;
  final String? loadingText;

  // Size & margin
  final double height;
  final double? width;
  final double radius;
  final EdgeInsetsGeometry margin;

  // Colors & style
  final Color? color;
  final Color? textColor;
  final TextStyle? textStyle;

  // Optional icon
  final Widget? icon;

  // Button appearance
  final double elevation;
  final BorderSide? borderSide;
  final ButtonType type;

  @override
  Widget build(BuildContext context) {
    final btnColor = color ?? Theme.of(context).primaryColor;
    final txtColor =
        textColor ?? (type == ButtonType.filled ? Colors.white : btnColor);

    return Padding(
      padding: margin,
      child: SizedBox(
        width: width ?? double.infinity,
        height: height,
        child: ElevatedButton(
          onPressed: loading ? null : onTap,
          style: _buildStyle(btnColor),
          child: _buildChild(txtColor),
        ),
      ),
    );
  }

  /// Style Builder
  ButtonStyle _buildStyle(Color btnColor) {
    switch (type) {
      case ButtonType.outlined:
        return ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          elevation: 0,
          side: borderSide ?? BorderSide(color: btnColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
        );

      case ButtonType.filled:
      return ElevatedButton.styleFrom(
          backgroundColor: btnColor,
          elevation: elevation,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
        );
    }
  }

  /// Child Builder
  Widget _buildChild(Color txtColor) {
    final style = textStyle ??
        TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: txtColor,
        );

    // Loader
    if (loading) {
      if (loadingText == null) {
        return SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: txtColor,
          ),
        );
      }

      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 18,
            width: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: txtColor,
            ),
          ),
          const SizedBox(width: 8),
          Text(loadingText!, style: style),
        ],
      );
    }

    // Normal content
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          icon!,
          const SizedBox(width: 8),
        ],
        Text(text, style: style),
      ],
    );
  }
}