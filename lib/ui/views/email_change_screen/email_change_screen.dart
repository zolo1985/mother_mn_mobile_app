import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mother_mobileapp/core/view_models/account_settings_screen_view_model.dart';
import 'package:provider/provider.dart';
import '../../../../core/network/custom_exception.dart';
import '../../../core/constants/custom_theme.dart';
import '../../../core/view_models/email_change_screen_view_model.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/email_textfield_form.dart';


class EmailChangeScreen extends StatelessWidget {
  const EmailChangeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppTheme.primaryPinkInRGB, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Container(
          color: Theme.of(context).backgroundColor,
          child: Consumer<EmailChangeScreenViewModel>(
            builder: (context, model, __) {
              return Form(
                key: key,
                child: Column(
                  children: [
                    const Spacer(),
                    Container(
                      margin: const EdgeInsets.only(right: 15, left: 15),
                      child: Column(
                        children: [
                          EmailTextFieldForm(
                            onSaved: (value) {
                              model.email = value!;
                            },
                          ),
                          const SizedBox(height: 40),
                          SizedBox(
                            child: model.isLoading
                            ? const SpinKitFadingCircle(color: AppTheme.primaryPinkInRGB, size: 40.0)
                            : CustomButton(buttonTitle: 'Өөрчлөх',
                              onPressed: () async {
                                if (key.currentState!.validate()) {
                                  key.currentState!.save();
                                  try {
                                    final response = await model.changeEmailToRemote();
                                    if (response.response!) {
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
                                                  "${response.msg}",
                                                  style: const TextStyle(
                                                      fontWeight: FontWeight.w300, fontSize: 14),
                                                ),
                                              );
                                            },
                                          );
                                        Provider.of<AccountSettingsScreenViewModel>(context, listen: false).fetchInfoAndSet();
                                      });
                                    }
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
                        ],
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              );
            },
          )
        ),
      ),
    );
  }
}