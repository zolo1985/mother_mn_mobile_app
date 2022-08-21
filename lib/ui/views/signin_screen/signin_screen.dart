import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/custom_theme.dart';
import '../../../core/view_models/signin_screen_view_model.dart';
import '../../../main.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/email_textfield_form.dart';
import '../../widgets/password_form_field.dart';
import '../../widgets/show_logo.dart';
import '../signup_screen/signup_screen.dart';


class SignInScreen extends StatelessWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<FormState>();
    return Scaffold(
      persistentFooterButtons: [
        Builder(
          builder: (context) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(),
                    onPressed: () {
                      Future.delayed(Duration.zero).then((_) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SignUpScreen(),),
                        );
                      });
                    },
                    child: Container(
                      width: 100,
                      alignment: Alignment.center,
                      child: const Text("Бүртгүүлэх?", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300)),
                    ),
                  ),
                ),
                const Center(child: Text('©2022 Mother.mn. Бүх эрх хуулиар хамгаалагдсан.', style: TextStyle(color: Colors.grey, fontSize: 10)),),
              ],
            );
          }
        )
      ],
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            color: Theme.of(context).backgroundColor,
            child: Consumer<SignInScreenViewModel>(
              builder: (context, model, __) {
                return Form(
                  key: key,
                  autovalidateMode: AutovalidateMode.disabled,
                  child: Column(
                    children: <Widget>[
                      const ShowAppLogo(),
                      const SizedBox(height: 30),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        color: model.errorMsg == "" ? Theme.of(context).backgroundColor : Colors.red,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10, bottom: 10),
                          child: Text(model.errorMsg, textAlign: TextAlign.center,),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: EmailTextFieldForm(
                          onChanged: (value) {
                            model.email = value;
                          },
                          onSaved: (value) {
                            model.email = value!;
                          }
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: PasswordFormField(
                            textFieldTitle: 'Нууц үг',
                            onToggle: () => model.toggleIsObscured(),
                            isObscured: model.isObscured,
                            onChanged: (value) {
                              model.password = value;
                            }
                        ),
                      ),
                      const SizedBox(height: 50),
                      if (model.isLoading) const SpinKitFadingCircle(color: AppTheme.primaryPinkInRGB, size: 40.0) else CustomButton(
                        buttonTitle: 'Нэвтрэх',
                        onPressed: () async {
                          if (key.currentState!.validate()) {
                            key.currentState!.save();
                            final response = await model.signIn();
                            if (!response) {
                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) {
                                  Future.delayed(const Duration(seconds: 3), () {
                                    Navigator.of(context).pop();
                                  });
                                  return AlertDialog(
                                    title: Text(
                                      model.customException?.msg ?? "",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w300, fontSize: 14),
                                    ),
                                  );
                                },
                              );
                            }
                            if (response) {
                              Future.delayed(const Duration(seconds: 0), () {
                                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const MotherMainPage()), (Route<dynamic> route) => false);
                              });
                            }
                          } else {
                            return;
                          }
                        },
                      ),
                      const SizedBox(height: 30),
                      InkWell(
                        onTap: () {
                          model.launchURL("mother.mn:5000/reset-password");
                        },
                        child: const Text('Нууц үгээ мартсан?', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ),
                    ],
                  ),
                );
              }
            )
          ),
        ),
      ),
    );
  }
}