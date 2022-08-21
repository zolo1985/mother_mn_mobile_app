import 'package:flutter/material.dart';

import '../../core/constants/custom_theme.dart';

class UsernameTextFieldForm extends StatelessWidget {
  final ValueChanged<String?>? onSaved;
  final String textFieldTitle;
  final TextEditingController? controller;

  const UsernameTextFieldForm(
      {Key? key, this.onSaved, required this.textFieldTitle, this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: _validateUsername,
      controller: controller,
      style: const TextStyle(fontSize: 20.0),
      keyboardType: TextInputType.text,
      autocorrect: false,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.person_outline, color: AppTheme.primaryPinkInRGB),
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
      onSaved: onSaved,
    );
  }

  String? _validateUsername(String? username) {
    // 1
    final RegExp regex = RegExp(r'^[A-Za-z0-9_\s]+$');
    // 2
    if (username!.isEmpty) {
      return 'Зөвхөн латин үсэг, тоо, _ ашиглана уу!';
    } else if (!regex.hasMatch(username)) {
      return "Зөвхөн латин үсэг, тоо, _ ашиглана уу!";
    } else if ( username.contains(" ")){
      return "Хоосон зай оруулахгүй!";
    } else {
      return null;
    }
  }
}
