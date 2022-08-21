import 'package:flutter/material.dart';

import '../../core/constants/custom_theme.dart';

class PasswordTextFieldForm extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  final VoidCallback? onToggle;
  final TextEditingController? controller;
  final bool? isObscured;
  final String textFieldTitle;
  const PasswordTextFieldForm(
      {Key? key,
      this.onChanged,
      this.controller,
      this.isObscured = false,
      this.onToggle,
      required this.textFieldTitle})
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
        errorMaxLines: 2,
      ),
      onChanged: onChanged,
    );
  }
}

String? _validatePasswordField(String? pass) {
    if (pass!.length < 8 || pass.isEmpty) {
      return 'Нууц үг багадаа 8н тэмдэгт оруулна уу!';
    }

    if (!pass.contains(RegExp('[a-z]'))) {
      return 'Нууц үг нэг жижиг үсэг оролцуулсан байх ёстой';
    }

    if (!pass.contains(RegExp("[A-Z]"))) {
      return 'Нууц үг нэг том үсэг оролцуулсан байх ёстой';
    }

    if (!pass.contains(RegExp("[0-9]"))) {
      return 'Нууц үг нэг тоо оролцуулсан байх ёстой';
    }

    if (!pass.contains(RegExp(r'[_!@#$%^&*(),.?":{}|<>]'))) {
        return 'Нууц үг нэг тусгай тэмдэгт оролцуулсан байх ёстой (_!@#\$%^&*(),.?":{}|<>) аль нэг';
    } else {
      return null;
    }
  }
