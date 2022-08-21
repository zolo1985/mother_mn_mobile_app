import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/custom_theme.dart';
import '../../../../core/network/custom_exception.dart';
import '../../../core/view_models/password_change_screen_view_model.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/password_again_textfield.dart';
import '../../widgets/password_form_field.dart';
import '../../widgets/password_textfield_form.dart';

class PasswordChangeScreen extends StatelessWidget {
  const PasswordChangeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Нууц үг өөрчлөх", style: TextStyle(fontSize: 16),),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppTheme.primaryPinkInRGB, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Container(
          color: Theme.of(context).backgroundColor,
          child: Consumer<PasswordChangeScreenViewModel>(
            builder: (context, model, __) {
              return Form(
                key: key,
                child: Container(
                  margin: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      const Spacer(),
                      PasswordFormField(
                        textFieldTitle: 'Одоо хэрэглэж байгаа нууц үг',
                        onToggle: () => model.toggleIsObscured(),
                        isObscured: model.isObscured,
                        onChanged: (value) {
                          model.currentPassword = value.trim();
                        }),
                      const SizedBox(height: 20),
                      PasswordTextFieldForm(
                        textFieldTitle: 'Шинэ нууц үг',
                        onToggle: () => model.toggleIsObscured(),
                        isObscured: model.isObscured,
                        onChanged: (value) {
                          model.newPassword = value.trim();
                        },
                      ),
                      const SizedBox(height: 20),
                      PasswordAgainTextFieldForm(
                        textFieldTitle: 'Шинэ нууц үг дахин',
                        onToggle: () => model.toggleIsObscured(),
                        isObscured: model.isObscured,
                        passAgain: model.newPassword,
                      ),
                      const SizedBox(height: 40),
                      SizedBox(
                        child: model.isLoading 
                        ? const CircularProgressIndicator(color: AppTheme.primaryPinkInRGB) 
                        : CustomButton(buttonTitle: 'Өөрчлөх',
                          onPressed: () async {
                            if (key.currentState!.validate()) {
                              key.currentState!.save();
                                try {
                                  final response = await model.changePasswordToRemote();
                                  Future.delayed(Duration.zero).then((_) {
                                    Navigator.of(context).pop();
                                    showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (context) {
                                        Future.delayed(const Duration(seconds: 3), () {
                                          Navigator.of(context).pop();
                                        });
                                        return AlertDialog(
                                          title: Text(
                                            response.msg ?? "",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w300, fontSize: 14),
                                          ),
                                        );
                                      },
                                    );
                                  });
                                } on CustomException catch (error) {
                                  showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) {
                                      Future.delayed(const Duration(seconds: 3), () {
                                        Navigator.of(context).pop();
                                      });
                                      return AlertDialog(
                                        title: Text(
                                          error.msg.toString(),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w300, fontSize: 14),
                                        ),
                                      );
                                    },
                                  );
                                }
                            } else {
                              return;
                            }
                          },
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              );
            },
          )
        ),
      ),
    );
  }
}