import 'package:flutter/material.dart';
import 'body.dart'; // Importing the body.dart file

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Welcome Back',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFFFF6720),
        centerTitle: true, // This centers the title
        leading: IconButton(
          icon: Image.asset(
            'assets/Images/backarrow.png',
            width: 30,
            height: 30,
          ), // Replace with your image path
          onPressed: () {
            Navigator.pop(context); // You can add custom action here
          },
        ),
      ),
      body: SignInBody(),
    );
  }
}
