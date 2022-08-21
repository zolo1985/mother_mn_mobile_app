import 'package:flutter/material.dart';

import '../../core/constants/custom_theme.dart';

class EmailTextFieldForm extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  final ValueChanged<String?>? onSaved;
  final TextEditingController? controller;

  const EmailTextFieldForm({Key? key, this.onChanged, this.controller, this.onSaved}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validateEmail,
      autocorrect: false,
      style: const TextStyle(fontSize: 20.0),
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.mail_outline, color: AppTheme.primaryPinkInRGB),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          borderSide: BorderSide(color: AppTheme.primaryPinkInRGB),
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          borderSide: BorderSide(color: AppTheme.primaryPinkInRGB),
        ),
        labelText: 'И-мэйл хаяг',
        labelStyle: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onPrimary),
        errorStyle: const TextStyle(color: AppTheme.primaryPinkInRGB),
      ),
      onChanged: onChanged,
      onSaved: onSaved,
    );
  }
  
  String? validateEmail(String? email) {
    // 1
    final RegExp regex = RegExp(r'\w+@\w+\.\w+');
    // 2
    if (email!.isEmpty) {
      return 'И-мэйл оруулна уу!';
    } else if (!regex.hasMatch(email)) {
      return "И-мэйл хаяг биш байна!";
    } else {
      return null;
    }
  }
}



