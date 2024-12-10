// ignore_for_file: prefer_const_constructors

import 'package:care_sync/Components/customButton.dart';
import 'package:care_sync/Components/customTextField.dart';
import 'package:care_sync/Screens/DoctorSide/AppointmentHistoryScreen/appointmentHistory.dart';
import 'package:care_sync/Screens/DoctorSide/ShowAvailableAppointments/showAvailableAppointments.dart';
import 'package:care_sync/Screens/HomeScreen.dart';
import 'package:care_sync/Screens/PatientSide/AppointmentHistoryScreen/appointmentHistory.dart';
import 'package:care_sync/Screens/PatientSide/ShowAvailableDoctorScreen/availableDoctors.dart';
import 'package:care_sync/Screens/PatientSide/SignUpScreen/signUp.dart';
import 'package:care_sync/Services/ApiCalls.dart';
import 'package:care_sync/Services/localStorageService.dart';
import 'package:care_sync/Services/redux/actions.dart';
import 'package:care_sync/Services/redux/app_state.dart';
import 'package:care_sync/ngrokLogin.dart';
import 'package:care_sync/ngrokUrlSetupScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_fonts/google_fonts.dart';

class SignInBody extends StatefulWidget {
  @override
  _SignInBodyState createState() => _SignInBodyState();
}

class _SignInBodyState extends State<SignInBody> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final apiCalls = ApiCalls();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

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
                  width: 100,
                  height: 100,
                ),
                SizedBox(
                  height: 50,
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
                  onPressed: () async {
                    Map<String, String?> sessionData =
                        await SessionStorage.getBaseUrl();
                    String? baseUrl = sessionData['baseUrl'];
                    if (_emailController.text.isNotEmpty &&
                        _passwordController.text.isNotEmpty) {
                      if (baseUrl != null && baseUrl.isNotEmpty) {
                        final result = await apiCalls.login(
                            _emailController.text.trim(),
                            _passwordController.text.trim());

                        if (result["success"] == true) {
                          String? FcmToken =
                              await _firebaseMessaging.getToken();
                          print("FCM Token: $FcmToken");
                          String userId = result["userId"];
                          String patientId = result["patientId"] ?? "";
                          String doctorId = result["doctorId"] ?? "";
                          String userType = result["userType"];
                          String jwtToken = result["token"];
                          String firstName = result["firstName"];
                          String lastName = result["lastName"];
                          String email = result["email"];
                          String img = result["imageData"];
                          // Store session data
                          await SessionStorage.storeSessionData(
                            userId: userId,
                            patientId: patientId,
                            doctorId: doctorId,
                            userType: userType,
                            jwtToken: jwtToken,
                            firstName: firstName,
                            lastName: lastName,
                            email: email,
                          );
                          await SessionStorage.storeFcmToken(
                              fcmToken: FcmToken!);
                          await SessionStorage.storeImage(image: img);
                          final res = await apiCalls.updateFcmToken(
                              userId, FcmToken, jwtToken);
                          if (res["success"] == true) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomeScreen(
                                    userType: result["userType"] ?? "PATIENT"),
                              ),
                            );
                          } else {
                            print("[Error : 1] ${res["message"]}");
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content:
                                      Text(res["message"] ?? 'Login failed')),
                            );
                          }
                        } else {
                          print("[Error : 2] ${result["message"]}");
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content:
                                    Text(result["message"] ?? 'Login failed')),
                          );
                        }
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Error"),
                              content: Text("Please specify the server url!"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(); // Close the dialog
                                  },
                                  child: Text("OK"),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Error"),
                            content: Text(
                                "No field should be empty. Please fill out all fields."),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                },
                                child: Text("OK"),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  buttonText: 'Sign In',
                  width: 250,
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text("Don't have an account?",
                      style: GoogleFonts.montserrat()),
                  TextButton(
                    child: Text(
                      "Register",
                      style: GoogleFonts.montserrat(color: Colors.blue),
                    ),
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignUpPage(),
                        ),
                      );
                    },
                  ),
                ]),
                TextButton(
                  child: Text(
                    "Change server",
                    style: GoogleFonts.montserrat(
                        color: const Color.fromARGB(255, 243, 33, 33)),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NgrokScreenLogin(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
