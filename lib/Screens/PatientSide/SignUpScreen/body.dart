// ignore_for_file: prefer_const_constructors

import 'package:care_sync/Components/customButton.dart';
import 'package:care_sync/Components/customTextField.dart';
import 'package:care_sync/Screens/PatientSide/SignInScreen/signIn.dart';
import 'package:flutter/material.dart';

class SignUpBody extends StatelessWidget {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _reEnterPasswordController =
      TextEditingController();

  bool _passwordsMatch = true;

  void _validatePasswords() {
    _passwordsMatch =
        _passwordController.text == _reEnterPasswordController.text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/Images/icon.png',
                  width: 200,
                  height: 200,
                ),
                SizedBox(
                  height: 20,
                ),
                CustomTextField(
                  controller: _firstNameController,
                  labelText: 'First Name',
                ),
                SizedBox(height: 10),
                CustomTextField(
                  controller: _lastNameController,
                  labelText: 'Last Name',
                ),
                SizedBox(height: 10),
                CustomTextField(
                  controller: _emailController,
                  labelText: 'Email',
                ),
                SizedBox(height: 10),
                CustomTextField(
                  controller: _passwordController,
                  labelText: 'Password',
                  obscureText: true,
                ),
                SizedBox(height: 10),
                CustomTextField(
                  controller: _reEnterPasswordController,
                  labelText: 'Re-enter Password',
                  obscureText: true,
                  onChanged: (value) => _validatePasswords(),
                ),
                SizedBox(height: 20),
                if (!_passwordsMatch)
                  Text(
                    'Passwords do not match',
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                SizedBox(height: 20),
                CustomButton(
                  onPressed: () {
                    // Check if passwords match
                    if (_passwordController.text ==
                        _reEnterPasswordController.text) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Processing Data')),
                      );
                      // Navigate to the SignInPage
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                SignInPage()), // Replace with the actual SignInPage widget
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Passwords do not match')),
                      );
                    }
                  },
                  buttonText: 'Sign Up',
                  width: 250,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
