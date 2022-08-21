import 'package:flutter/material.dart';

import '../../core/constants/custom_theme.dart';

class CustomButton extends StatelessWidget {
  final String buttonTitle;
  final VoidCallback? onPressed;
  final GlobalKey<FormState>? formKey;
  const CustomButton({Key? key, this.onPressed, this.formKey, required this.buttonTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: AppTheme.primaryPinkInRGB,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: AppTheme.primaryPinkInRGB, width: 2),
          borderRadius: BorderRadius.circular(25.0),
        ),
      ),
      onPressed: onPressed,
      child: Container(
        
        padding: const EdgeInsets.all(10.0),
        width: 200,
        height: 40,
        child: Center(
            child: Text(buttonTitle,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white))),
      ),
    );
  }
}