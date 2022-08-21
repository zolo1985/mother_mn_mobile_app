import 'package:flutter/material.dart';

import '../../core/constants/custom_theme.dart';

class PasswordAgainTextFieldForm extends StatelessWidget {
  final VoidCallback? onToggle;
  final TextEditingController? controller;
  final bool? isObscured;
  final String textFieldTitle;
  final String? passAgain;
  const PasswordAgainTextFieldForm(
      {Key? key,
      this.controller,
      this.isObscured = false,
      this.onToggle,
      required this.textFieldTitle, this.passAgain})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: _validatePasswordField,
      style: const TextStyle(fontSize: 20.0),
      keyboardType: TextInputType.text,
      obscureText: isObscured!,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.lock_outline, color: AppTheme.primaryPinkInRGB),
        suffixIcon: IconButton(
            onPressed: onToggle,
            icon: Icon(
                isObscured! ? Icons.remove_red_eye : Icons.lock_open,
                color: Colors.grey)),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          borderSide: BorderSide(color: AppTheme.primaryPinkInRGB),
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          borderSide: BorderSide(color: AppTheme.primaryPinkInRGB),
        ),
        labelText: textFieldTitle,
        labelStyle: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onPrimary),
        errorStyle: const TextStyle(color: AppTheme.primaryPinkInRGB),
      ),
    );
  }
  
  String? _validatePasswordField(String? pass) {
    if (pass!.isEmpty) {
      return 'Нууц үг оруулна уу!';
    } else {
      if (passAgain != pass) {
        return "Нууц үгнүүд таарахгүй байна!";
      } else {
        return null;
      }
    } 
  }
}


