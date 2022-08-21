import 'package:flutter/material.dart';

import '../../core/constants/custom_theme.dart';


class LastNameTextFieldForm extends StatelessWidget {
  final ValueChanged<String?>? onSaved;
  final TextEditingController? controller;

  const LastNameTextFieldForm({Key? key, this.onSaved, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: _validateLastName,
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
        labelText: 'Овог',
        labelStyle: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onPrimary),
        hintText: '',
        hintStyle: const TextStyle(fontSize: 16),
        errorStyle: const TextStyle(color: AppTheme.primaryPinkInRGB),
      ),
      onSaved: onSaved,
    );
  }

  String? _validateLastName(String? name) {
    final RegExp regex = RegExp(r'^[A-Za-z-\u0400-\u04FF\s]+$');
    if (name!.isEmpty) {
      return 'Нэр оруулна уу!(Зөвхөн үсэг)';
    } else if (!regex.hasMatch(name)) {
      return "Нэр биш байна!";
    } else if (name.contains(" ")){
      return "Хоосон зай оруулахгүй!";
    } else {
      return null;
    }
  }
}
