import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {
          Navigator.of(context).pop();
        }, icon: const Icon(Icons.arrow_back_ios)),
        title: const Text("Бидний тухай", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
        centerTitle: true,
      ),
      body: const Center(
        child: SizedBox(
          child: Text('About Us Page'),
        ),
      )
    );
  }
}