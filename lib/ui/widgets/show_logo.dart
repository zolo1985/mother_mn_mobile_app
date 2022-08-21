import 'package:flutter/material.dart';

class ShowAppLogo extends StatelessWidget {
  const ShowAppLogo({Key? key}) : super(key: key);
  // const SignInButton({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/logo.png',
      height: MediaQuery.of(context).size.width/2,
      width: MediaQuery.of(context).size.width/2,
    );
  }
}