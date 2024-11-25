import 'package:flutter/material.dart';
import 'package:care_sync/Screens/PatientSide/SignUpScreen/signUp.dart'; // Import SignInPage from signIn.dart

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Page',
      theme: ThemeData(
        primaryColor: Color(0xFFFF6720), // Orange color
        scaffoldBackgroundColor: Colors.black, // Black background
      ),
      home:
          SignUpPage(), // Remove 'const' here since the LoginForm widget isn't const
    );
  }
}
