import 'package:flutter_classic_mvc/core/utils/app_validator.dart';
import 'package:flutter/material.dart';
// Email & Password regex

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String? hintText;
  final String? labelText;
  final bool isPassword;
  final bool isEmail;
  final bool checkEmpty; // empty check optional
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Color? fillColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final double borderRadius;
  final double contentPaddingHorizontal;
  final double contentPaddingVertical;
  final double fontSize;
  final Color? cursorColor;
  

  const CustomTextField({
    super.key,
    required this.controller,
    this.hintText,
    this.labelText,
    this.isPassword = false,
    this.isEmail = false,
    this.checkEmpty = false, // default false to avoid unnecessary validation for non-required fields
    this.prefixIcon,
    this.suffixIcon,
    this.fillColor,
    this.borderColor,
    this.focusedBorderColor,

    /// Default values modified for better aesthetics and usability
    this.borderRadius = 50,
    this.contentPaddingHorizontal = 20,
    this.contentPaddingVertical = 16,
    this.fontSize = 16,
    this.cursorColor,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool obscureText = true;

  void toggle() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  String? _validator(String? value) {
    // 1️⃣ Empty check only if checkEmpty=true
    if (widget.checkEmpty && (value == null || value.isEmpty)) {
      return AppValidator.validateRequired(value);
    }

    // 2️⃣ Email validator (only if field filled)
    if (widget.isEmail && (value != null && value.isNotEmpty)) {
        return AppValidator.validateEmail(value);
    }

    // 3️⃣ Password validator (only if field filled)
    if (widget.isPassword && (value != null && value.isNotEmpty)) {
      return AppValidator.validatePassword(value, minLength: 6);
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.isPassword ? obscureText : false,
      cursorColor: widget.cursorColor,
      validator: _validator,
      style: TextStyle(fontSize: widget.fontSize),
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        fillColor: widget.fillColor,
        filled: widget.fillColor != null,
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.isPassword
            ? GestureDetector(
                onTap: toggle,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Icon(
                    obscureText ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey[700],
                  ),
                ),
              )
            : widget.suffixIcon,
        contentPadding: EdgeInsets.symmetric(
          horizontal: widget.contentPaddingHorizontal,
          vertical: widget.contentPaddingVertical,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(color: widget.borderColor ?? Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(color: widget.borderColor ?? Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(
              color: widget.focusedBorderColor ?? widget.borderColor ?? Colors.blue),
        ),
      ),
    );
  }
}