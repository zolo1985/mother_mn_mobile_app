import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import '../../../core/view_models/signup_screen_view_model.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/email_textfield_form.dart';

import '../../../core/constants/custom_theme.dart';
import '../../widgets/firstname_textfield_form.dart';
import '../../widgets/lastname_textfield_form.dart';
import '../../widgets/password_again_textfield.dart';
import '../../widgets/password_textfield_form.dart';
import '../../widgets/username_textfield_form.dart';
import '../signin_screen/signin_screen.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

   @override
  Widget build(BuildContext context) {
    final key = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppTheme.primaryPinkInRGB, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Бүртгүүлэх', textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            color: Theme.of(context).backgroundColor,
            child: Consumer<SignUpScreenViewModel>(
              builder: (context, model, __) {
                return Form(
                  autovalidateMode: AutovalidateMode.disabled,
                  key: key,
                  child: Container(
                    margin: const EdgeInsets.only(left: 20, right: 20),
                    color: Theme.of(context).backgroundColor,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        const SizedBox(height: 20),
                          UsernameTextFieldForm(
                          textFieldTitle: 'Хэрэглэгчийн нэр',
                          onSaved: (value) {
                            model.username = value!.trim();
                          }
                        ),
                        const SizedBox(height: 20),
                        LastNameTextFieldForm(
                          onSaved: (value) {
                            model.lastName = value!.trim();
                          }
                        ),
                        const SizedBox(height: 20),
                        FirstNameTextFieldForm( 
                          onSaved: (value) {
                            model.firstName = value!.trim();
                          }
                        ),
                        const SizedBox(height: 20),
                        EmailTextFieldForm(
                          onSaved: (value) {
                            model.email = value!.trim();
                          },
                        ),
                        const SizedBox(height: 20),
                        PasswordTextFieldForm(
                          textFieldTitle: "Нууц үг",
                          onToggle: () => model.toggleIsObscured(),
                          isObscured: model.isObscured,
                          onChanged: (value) {
                            model.password = value.trim();
                          },
                        ),
                        const SizedBox(height: 20),
                        PasswordAgainTextFieldForm(
                          textFieldTitle: 'Шинэ нууц үг дахин',
                          onToggle: () => model.toggleIsObscured(),
                          isObscured: model.isObscured,
                          passAgain: model.password,
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: [
                              const SizedBox(height: 40),
                              GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  model.launchURL("mother.mn:5000/user-agreements");
                                },
                                child: const Text('Хэрэглэгчийн журам'),
                              ),
                              const SizedBox(height: 40),
                              GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  model.launchURL("mother.mn:5000/terms-and-conditions");
                                },
                                child: const Text('Үйлчилгээний нөхцөл'),
                              ),
                              const SizedBox(height: 40),
                              const Text(
                                'Бүртгүүлэх товчин дээр дарснаар та манай үйлчилгээний нөхцөл болон хэрэглэгчийн журмыг хүлээн зөвшөөрч байгаад тооцогдоно.',
                                style: TextStyle(fontWeight: FontWeight.w400),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
                        if (model.isLoading) const SpinKitFadingCircle(color: AppTheme.primaryPinkInRGB, size: 40.0) else CustomButton(
                          buttonTitle: 'Бүртгүүлэх',
                          onPressed: () async {
                            if (key.currentState!.validate()) {
                                key.currentState!.save();
                                  final response = await model.signUpUserRequest();
                                  if (response == false) {
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
                                  } else {
                                    Future.delayed(Duration.zero).then((_) {
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
                                    });
                                    Future.delayed(const Duration(seconds: 4)).then((_) {
                                      Navigator.push(context, CupertinoPageRoute(builder: (context) => const SignInScreen()));
                                    });
                                  }
                              } else {
                                return;
                              }
                          },
                        ),
                        const SizedBox(height: 50),
                      ],
                    ),
                  ),
                );
              }
            ),
          ),
        ),
      ),
    );
  }
}