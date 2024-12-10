import 'package:care_sync/Components/customButton.dart';
import 'package:care_sync/Components/customRadioField.dart';
import 'package:care_sync/Components/customTextField.dart';
import 'package:care_sync/Screens/PatientSide/SignInScreen/signIn.dart';
import 'package:care_sync/Services/ApiCalls.dart';
import 'package:care_sync/Services/localStorageService.dart';
import 'package:care_sync/ngrokLogin.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpBody extends StatefulWidget {
  @override
  _SignUpBodyState createState() => _SignUpBodyState();
}

class _SignUpBodyState extends State<SignUpBody> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _reEnterPasswordController =
      TextEditingController();
  String? _userType;
  final apiCalls = ApiCalls();
  bool _passwordsMatch = true;

  // Fields for Patient
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _contactNumberController =
      TextEditingController();

  // Fields for Doctor
  final TextEditingController _specializationController =
      TextEditingController();
  final TextEditingController _hospitalNameController = TextEditingController();
  final TextEditingController _consultationFeeController =
      TextEditingController();
  List<Map<String, String>> _freeHours = [
    {"Day": "Monday", "Hours": ""},
    {"Day": "Tuesday", "Hours": ""},
    {"Day": "Wednesday", "Hours": ""},
    {"Day": "Thursday", "Hours": ""},
    {"Day": "Friday", "Hours": ""},
    {"Day": "Saturday", "Hours": ""},
    {"Day": "Sunday", "Hours": ""},
  ];
  String? token;
  String? id;

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
                  width: 100,
                  height: 100,
                ),
                SizedBox(height: 50),
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
                if (!_passwordsMatch)
                  Text(
                    'Passwords do not match',
                    style:
                        GoogleFonts.montserrat(color: Colors.red, fontSize: 12),
                  ),
                SizedBox(height: 10),
                CustomRadioField(
                  labelText: 'User Type',
                  onChanged: (value) {
                    setState(() {
                      _userType = value; // Store the selected value here
                    });
                  },
                ),
                SizedBox(height: 10),

                // Check if _userType is selected and display relevant fields
                if (_userType == 'PATIENT') ...[
                  CustomTextField(
                    controller: _dobController,
                    labelText: 'Date of Birth',
                    keyboardType: TextInputType.datetime,
                  ),
                  SizedBox(height: 10),
                  CustomTextField(
                    controller: _contactNumberController,
                    labelText: 'Contact Number',
                    keyboardType: TextInputType.phone,
                  ),
                ] else if (_userType == 'DOCTOR') ...[
                  CustomTextField(
                    controller: _specializationController,
                    labelText: 'Specialization',
                  ),
                  SizedBox(height: 10),
                  CustomTextField(
                    controller: _hospitalNameController,
                    labelText: 'Hospital Name',
                  ),
                  SizedBox(height: 10),
                  CustomTextField(
                    controller: _consultationFeeController,
                    labelText: 'Consultation Fee',
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Free Hours",
                    style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _freeHours.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                _freeHours[index]['Day']!,
                                style: GoogleFonts.montserrat(fontSize: 14),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: TextField(
                                onChanged: (value) {
                                  setState(() {
                                    _freeHours[index]['Hours'] = value;
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: 'e.g., 10:00 AM - 12:00 PM',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
                SizedBox(height: 20),
                CustomButton(
                  onPressed: () async {
                    Map<String, String?> sessionData =
                        await SessionStorage.getBaseUrl();
                    String? baseUrl = sessionData['baseUrl'];
                    if (_firstNameController.text.isNotEmpty &&
                        _lastNameController.text.isNotEmpty &&
                        _userType != null &&
                        _emailController.text.isNotEmpty &&
                        _passwordController.text.isNotEmpty &&
                        _reEnterPasswordController.text.isNotEmpty) {
                      if (baseUrl != null && baseUrl.isNotEmpty) {
                        if (_passwordsMatch) {
                          final result = await apiCalls.register(
                            _firstNameController.text.trim(),
                            _lastNameController.text.trim(),
                            _userType!,
                            _emailController.text.trim(),
                            _passwordController.text.trim(),
                          );

                          id = result["userId"];
                          token = result["token"];
                          if (result["success"] == true) {
                            if (_userType == 'DOCTOR') {
                              final result1 = await apiCalls.addDoctor(
                                _specializationController.text.trim(),
                                _hospitalNameController.text.trim(),
                                _consultationFeeController.text.trim(),
                                _freeHours,
                                token!,
                                id!,
                              );
                              if (result1["success"] == true) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SignInPage(),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(result1["message"] ??
                                        'Doctor registration failed'),
                                  ),
                                );
                              }
                            } else if (_userType == 'PATIENT') {
                              final result2 = await apiCalls.addPatient(
                                _dobController.text.trim(),
                                _contactNumberController.text.trim(),
                                token!,
                                id!,
                              );
                              if (result2["success"] == true) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SignInPage(),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(result2["message"] ??
                                        'Patient registration failed'),
                                  ),
                                );
                              }
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    result["message"] ?? 'Registration failed'),
                              ),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Passwords do not match')),
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
                                    Navigator.of(context).pop();
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
                                  Navigator.of(context).pop();
                                },
                                child: Text("OK"),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  buttonText: 'Sign Up',
                  width: 250,
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account?"),
                    TextButton(
                      child: Text(
                        "SignIn",
                        style: GoogleFonts.montserrat(color: Colors.blue),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignInPage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
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
