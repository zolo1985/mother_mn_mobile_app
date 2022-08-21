import 'package:flutter/material.dart';

import '../../core/constants/custom_theme.dart';

SnackBar displaySnackBar(String msg, {String? actionmsg}) {
  return SnackBar(
    content: Text(
      msg,
      style: const TextStyle(color: Colors.white, fontSize: 14.0),
    ),
    duration: const Duration(seconds: 2),
    backgroundColor: AppTheme.primaryPinkInRGB,
  );
}