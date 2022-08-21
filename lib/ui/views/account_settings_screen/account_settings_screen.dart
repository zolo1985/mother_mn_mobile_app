import 'package:flutter/material.dart';
import 'package:mother_mobileapp/ui/views/email_change_screen/email_change_screen.dart';
import 'package:mother_mobileapp/ui/views/password_change_screen.dart/password_change_screen.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/custom_theme.dart';
import '../../../core/view_models/account_settings_screen_view_model.dart';
import '../../../core/view_models/base_view_model.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/loading_screen.dart';
import '../signin_screen/signin_screen.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({Key? key}) : super(key: key);

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) async {
      await Provider.of<AccountSettingsScreenViewModel>(context, listen: false).fetchInfoAndSet();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Дансны мэдээлэл', style: TextStyle(fontSize: 16),),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppTheme.primaryPinkInRGB, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
      ),
      body: Consumer<AccountSettingsScreenViewModel>(
        builder: (context, model, __) {
          if (model.state == ViewState.busy) {
            return const LoadingScreen();
          } else {
            return Container(
              margin: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Text("Хэрэглэгчийн нэр: ${model.user.username!}"),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("И-мэйл: ${model.user.email!}"),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: AppTheme.primaryPinkInRGB,
                          onPrimary: Colors.white
                        ),
                        onPressed: () async {
                            Future.delayed(Duration.zero).then((_) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const EmailChangeScreen(),),
                              );
                            });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          child: const Text("Өөрчлөх", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis, maxLines: 1),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Нууц үг"),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: AppTheme.primaryPinkInRGB,
                          onPrimary: Colors.white
                        ),
                        onPressed: () {
                          Future.delayed(Duration.zero).then((_) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const PasswordChangeScreen(),),
                            );
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          child: const Text("Өөрчлөх", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Center(
                    child: CustomButton(
                      onPressed: () async {
                        await model.signOutUser();
                        Future.delayed(Duration.zero).then((_) {
                            Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const SignInScreen()), (_) => false);
                            showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                Future.delayed(const Duration(seconds: 3), () {
                                  Navigator.of(context).pop();
                                });
                                return const AlertDialog(
                                  title: Text(
                                    "Баяртай...",
                                    style: TextStyle(fontWeight: FontWeight.w300, fontSize: 14),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                      buttonTitle: "Гарах?"
                    ),
                  ),
                ],
              ),
            );
          }
        }
      )
    );
  }
}