// ignore_for_file: prefer_const_constructors

import 'package:care_sync/Components/customButton.dart';
import 'package:care_sync/Components/customTextField.dart';
import 'package:care_sync/Screens/PatientSide/AppointmentHistoryScreen/appointmentHistory.dart';
import 'package:care_sync/Screens/PatientSide/ShowAvailableDoctorScreen/availableDoctors.dart';
import 'package:flutter/material.dart';

class SignInBody extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
                  controller: _emailController,
                  labelText: 'Email',
                ),
                SizedBox(height: 10),
                CustomTextField(
                  controller: _passwordController,
                  labelText: 'Password',
                  obscureText: true,
                ),
                SizedBox(height: 20),
                CustomButton(
                  onPressed: () {
                    if (_emailController.text.isNotEmpty &&
                        _passwordController.text.isNotEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Processing Sign In Data')),
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AppointmentHistoryScreen()),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Please enter email and password')),
                      );
                    }
                  },
                  buttonText: 'Sign In',
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
