// import 'package:flutter/material.dart';
// import 'package:intl_phone_number_input/intl_phone_number_input.dart';

// import '../../core/constants/custom_theme.dart';

// class PhoneNumberTextFieldForm extends StatelessWidget {
//   final ValueChanged<PhoneNumber?>? onSaved;
//   final PhoneNumber? initialCountry;
//   final TextEditingController? controller;

//   const PhoneNumberTextFieldForm({Key? key, this.onSaved, this.initialCountry, this.controller})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return InternationalPhoneNumberInput(
//       maxLength: 20,
//       validator: _validatePhone,
//       selectorConfig: const SelectorConfig(
//         selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
//       ),
//       hintText: "",
//       initialValue: initialCountry,
//       textFieldController: controller,
//       formatInput: false,
//       keyboardType: TextInputType.number,
//       searchBoxDecoration: InputDecoration(
//         labelText: "Олон улсын код",
//         labelStyle: TextStyle(
//             fontSize: 12, color: Theme.of(context).colorScheme.onPrimary),
//         focusedBorder: const UnderlineInputBorder(
//           borderSide: BorderSide(color: AppTheme.primaryRedInRGB),
//         ),
//         border: const UnderlineInputBorder(
//           borderSide: BorderSide(color: AppTheme.primaryRedInRGB),
//         ),
//         errorStyle: const TextStyle(color: AppTheme.primaryRedInRGB),
//       ),
//       inputDecoration: InputDecoration(
//         labelText: "Утасны дугаар",
//         labelStyle: TextStyle(
//             fontSize: 12, color: Theme.of(context).colorScheme.onPrimary),
//         focusedBorder: const UnderlineInputBorder(
//           borderSide: BorderSide(color: AppTheme.primaryRedInRGB),
//         ),
//         border: const UnderlineInputBorder(
//           borderSide: BorderSide(color: AppTheme.primaryRedInRGB),
//         ),
//         errorStyle: const TextStyle(color: AppTheme.primaryRedInRGB),
//       ),
//       onSaved: onSaved, 
//       onInputChanged: (PhoneNumber value) {},
//     );
//   }

//   String? _validatePhone(String? phone) {
//     final RegExp regex = RegExp(r'^[0-9]+$');
//     if (phone!.isEmpty) {
//       return 'Утасны дугаар оруулна уу!';
//     } else if (!regex.hasMatch(phone)) {
//       return 'Утасны дугаар биш байна!';
//     } else {
//       return null;
//     }
//   }
// }
