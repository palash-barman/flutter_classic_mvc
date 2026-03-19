import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Formatter {

   /// -------------------------------
  /// TIME & DATE FORMATTERS
  /// -------------------------------

  static String timeFormatter({TimeOfDay? time, DateTime? dateTime, bool showDate = false}) {
    time ??= dateTime != null ? TimeOfDay.fromDateTime(dateTime) : null;
    if (time == null) return "null";

    String result = "";
    if (showDate && dateTime != null) {
      final now = DateTime.now();
      final dateOnly = DateTime(dateTime.year, dateTime.month, dateTime.day);
      final yesterday = now.subtract(Duration(days: 1));
      if (dateOnly == yesterday) result += "Yesterday at ";
      else if (dateOnly == DateTime(now.year, now.month, now.day)) result += "Today at ";
      else result += "${dateTime.day} ${monthName(dateTime.month)} at ";
    }

    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    return "$result$hour:${time.minute.toString().padLeft(2,'0')} ${time.period == DayPeriod.am ? 'AM' : 'PM'}";
  }

  static String dateFormatter(DateTime date, {String format = "yyyy-MM-dd"}) => DateFormat(format).format(date);

  static String monthName(int month) => [
        "", "January", "February", "March", "April", "May", "June",
        "July", "August", "September", "October", "November", "December"
      ][month];

  static String countdown(Duration duration) =>
      "${duration.inMinutes.toString().padLeft(2,'0')}:${(duration.inSeconds % 60).toString().padLeft(2,'0')}";

  static String durationFormatter(Duration duration, {bool showSeconds = false}) {
    final days = duration.inDays;
    final hours = duration.inHours % 24;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;

    String result = "";
    if (days > 0) result += "${days}d ";
    if (hours > 0) result += "${hours}h ";
    if (minutes > 0 || result.isNotEmpty) result += "${minutes}m";
    if (showSeconds) result += " ${seconds}s";

    return result.trim();
  }
  /// -------------------------------
  /// TEXT FORMATTERS
  /// -------------------------------
  /// TEXT
  static String toPascalCase(String text) =>
      text.split(' ').map((w) => w.isEmpty ? w : "${w[0].toUpperCase()}${w.substring(1).toLowerCase()}").join(' ');

  static String capitalize(String text) => text.isEmpty ? text : "${text[0].toUpperCase()}${text.substring(1)}";

    /// -------------------------------
  /// NUMBER & CURRENCY FORMATTERS
  /// -------------------------------

  /// General number formatter (round to 2 decimals, remove trailing zeros)
  static String numberFormatter(dynamic value) {
    num? n = value is num ? value : num.tryParse(value.toString());
    if (n == null) return "0";
    final s = (n * 100).round() / 100;
    return s.toStringAsFixed(2).replaceAll(RegExp(r'\.00$'), '').replaceAll(RegExp(r'0$'), '');
  }

  static String currency(num value, {String symbol = "\$", int decimalDigits = 2}) =>
      NumberFormat.currency(symbol: symbol, decimalDigits: decimalDigits).format(value);

  static String percentage(num value, {int decimalDigits = 2}) =>
      NumberFormat("##0.${'0' * decimalDigits}%").format(value / 100);

  /// -------------------------------
  /// FILE & SIZE FORMATTERS
  /// -------------------------------
  /// FILE SIZE
  static String fileSizeFormatter(int bytes) {
    if (bytes <= 0) return "0 B";
    const suffix = ["B", "KB", "MB", "GB", "TB"];
    double size = bytes.toDouble();
    int i = 0;
    while (size >= 1024 && i < suffix.length - 1) { size /= 1024; i++; }
    return "${size.toStringAsFixed(2)} ${suffix[i]}";
  }
 /// -------------------------------
  /// SPECIAL FORMATTERS
  /// -------------------------------

  /// Phone number formatter (basic)
  static String phoneFormatter(String phone, {String countryCode = "+1"}) {
    phone = phone.replaceAll(RegExp(r'[^0-9]'), '');
    if (!phone.startsWith(countryCode.replaceAll('+',''))) phone = countryCode.replaceAll('+','') + phone;
    return "+$phone";
  }

  static String emailFormatter(String email) => email.trim().toLowerCase();
}