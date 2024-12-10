import 'dart:convert';
import 'package:care_sync/Components/customButton.dart';
import 'package:care_sync/Components/cutomRetryButton.dart';
import 'package:care_sync/Services/ApiCalls.dart';
import 'package:care_sync/Services/localStorageService.dart';
import 'package:care_sync/Services/redux/actions.dart';
import 'package:care_sync/Services/redux/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

class DoctorsListBody extends StatefulWidget {
  @override
  _DoctorsListBodyState createState() => _DoctorsListBodyState();
}

class _DoctorsListBodyState extends State<DoctorsListBody> {
  List<dynamic> doctors = [];
  List<bool> isExpandedList = [];
  bool isLoading = true;
  String? errorMessage;
  String? token;
  String? id;
  String? patientId;
  String? selectedDate; // Store the selected appointment date
  String? selectedDay;
  String? selectedHours;
  String? status = "SCHEDULED";
  String? doctorId;
  final apiCalls = ApiCalls();

  // Function to load data from JSON
  Future<void> _retrieveSessionData() async {
    Map<String, String?> sessionData = await SessionStorage.getSessionData();

    String? userToken = sessionData['jwtToken'];
    String? userId = sessionData['userId'];
    String? userType = sessionData['userType'];
    String? patntId = sessionData['patientId'];
    String? doctorId = sessionData['doctorId'];
    String? fName = sessionData['firstName'];
    String? lName = sessionData['lastName'];
    String? emailId = sessionData['email'];
    String? img = sessionData['image'];
    print("Session Data Retrieved: $sessionData");

    setState(() {
      token = userToken;
      id = userId;
      patientId = patntId;
    });

    // Check if the session data exists
    print("Token : $token");
    print("user id : $userId");
    print("usertype : $userType");
    if (token != null && userId != null && userType != null) {
      // Dispatch action to store session data in Redux
      StoreProvider.of<AppState>(context).dispatch(UpdateTokenAction(
        firstName: fName!,
        lastName: lName!,
        email: emailId!,
        token: userToken!,
        id: userId,
        userType: userType,
        patientId: patntId ?? "",
        doctorId: doctorId ?? "",
      ));

      StoreProvider.of<AppState>(context)
          .dispatch(UpdateImage(image: img ?? ""));

      // Load doctors once token is available
      loadDoctors();
    } else {
      setState(() {
        isLoading = false;
        errorMessage = "Token not found!";
      });
    }
  }

  Future<void> loadDoctors() async {
    print("TOken on doctors screen : $token");
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    if (token != null) {
      try {
        final result = await apiCalls.getDoctors(token!);

        if (result["success"] == true) {
          final List<dynamic> doctorList = result["message"];
          setState(() {
            doctors = doctorList;
            isExpandedList = List<bool>.filled(doctors.length, false);
            isLoading = false;
          });
        } else {
          setState(() {
            errorMessage = result["message"];
            isLoading = false;
          });
        }
      } catch (error) {
        setState(() {
          errorMessage = "An error occurred: $error";
          isLoading = false;
        });
      }
    }
  }

  // Function to load data from JSON
  Future<void> createAppointment(String? doctorId) async {
    print("called");
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    print("selected date : $selectedDate");
    print("selected hours : $selectedHours");
    print("selected status : $status");
    print("selected doctor : $doctorId");
    print("token : $token");
    print("selected patient  : $patientId");

    if (token != null &&
        selectedDate != null &&
        selectedHours != null &&
        status != null &&
        patientId != null) {
      try {
        print("came");
        final result = await apiCalls.createAppointment(selectedDate!,
            selectedHours!, status!, patientId!, doctorId!, token!);

        if (result["success"] == true) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Success!"),
                content: Text(result["message"]),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: Text("OK"),
                  ),
                ],
              );
            },
          );
          setState(() {
            isLoading = false;
          });
        } else {
          setState(() {
            errorMessage = "An error occurred: ${result["message"]}";
            isLoading = false;
          });
        }
      } catch (error) {
        print("error : $error");
        setState(() {
          errorMessage = "An error occurred: $error";
          isLoading = false;
        });
      }
    } else {
      setState(() {
        errorMessage = "One or more required fields are null";
        isLoading = false;
      });
      print("One or more required fields are null");
    }
  }

  String _getNextDate(String day) {
    final today = DateTime.now();
    final weekdays = {
      "Monday": DateTime.monday,
      "Tuesday": DateTime.tuesday,
      "Wednesday": DateTime.wednesday,
      "Thursday": DateTime.thursday,
      "Friday": DateTime.friday,
      "Saturday": DateTime.saturday,
      "Sunday": DateTime.sunday,
    };

    final targetWeekday = weekdays[day] ?? today.weekday;
    final daysToAdd = (targetWeekday - today.weekday + 7) % 7 == 0
        ? 7
        : (targetWeekday - today.weekday + 7) % 7;
    final nextDate = today.add(Duration(days: daysToAdd));
    return DateFormat('dd-MM-yyyy').format(nextDate);
  }

  @override
  void initState() {
    super.initState();
    _retrieveSessionData(); // Retrieve session data on screen load
  }

  // Method to retrieve session data from SharedPreferences and dispatch to Redux
  // Future<void> _retrieveSessionData() async {
  //   // Get session data from SharedPreferences
  //   Map<String, String?> sessionData = await SessionStorage.getSessionData();

  //   String? userToken = sessionData['jwtToken'];
  //   String? userId = sessionData['userId'];
  //   String? userType = sessionData['userType'];
  //   String? patientId = sessionData['patientId'];
  //   String? doctorId = sessionData['doctorId'];

  //   print(
  //       "Session Data Retrieved: token: $userToken, userId: $userId, userType: $userType");

  //   setState(() {
  //     token = userToken;
  //     id = userId;
  //     patientId = patientId;
  //   });

  //   // Check if the session data exists
  //   if (token != null && userId != null && userType != null) {
  //     // Dispatch action to store session data in Redux
  //     StoreProvider.of<AppState>(context).dispatch(UpdateTokenAction(
  //       token: userToken!,
  //       id: userId,
  //       userType: userType,
  //       patientId: patientId ?? "",
  //       doctorId: doctorId ?? "",
  //     ));

  //     // Load doctors once token is available
  //     loadDoctors();
  //   } else {
  //     setState(() {
  //       isLoading = false;
  //       errorMessage = "Token not found!";
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? Center(
              child: Container(
                color: Colors.white.withOpacity(0.5), // Dim background
                child: const Center(
                  child: CircularProgressIndicator(color: Color(0xFF29A5D6)),
                ),
              ),
            )
          : doctors.isEmpty
              ? errorMessage != null
                  ? Center(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                          CustomRetryButton(
                            onPressed: loadDoctors,
                            buttonText: "↻ Retry",
                            width: 100,
                          ),
                          Text(
                            "Check your internet connection",
                            style: GoogleFonts.montserrat(color: Colors.red),
                          )
                        ]))
                  : Center(child: Text("No doctors available"))
              : ListView.builder(
                  itemCount: doctors.length,
                  itemBuilder: (context, index) {
                    final doctor = doctors[index];
                    final isExpanded = isExpandedList[index];

                    return Card(
                      color: Color(0xFFEEEEEE),
                      elevation: 8,
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        doctor["doctorName"] ?? "No Name",
                                        style: GoogleFonts.montserrat(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 2),
                                      Text(
                                        doctor["specialization"] ?? "N/A",
                                        style: GoogleFonts.montserrat(
                                          fontSize: 10,
                                          color: Colors.grey[700],
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 2),
                                      Text(
                                        "Fee: \$${doctor["consultationFee"] ?? "N/A"}",
                                        style: GoogleFonts.montserrat(
                                          fontSize: 12,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        doctor["hospitalName"] ?? "No Hospital",
                                        style: GoogleFonts.montserrat(
                                          fontSize: 12,
                                          color: Colors.grey[700],
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        isExpanded
                                            ? Icons.keyboard_arrow_up
                                            : Icons.keyboard_arrow_down,
                                        color: const Color(0xFF29A5D6),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          isExpandedList[index] = !isExpanded;
                                        });
                                      },
                                    ),
                                    CustomButton(
                                      onPressed: () {
                                        if (selectedHours == null) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "Please select a time slot")));
                                        } else {
                                          setState(() {
                                            doctorId = doctor["doctorId"]!;
                                          });
                                          createAppointment(doctorId);
                                        }
                                      },
                                      buttonText: "Book Now",
                                      width: 120,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            if (isExpanded) ...[
                              SizedBox(height: 16),
                              Column(
                                children: [
                                  Center(
                                    child: Text(
                                      "Free Hours",
                                      style: GoogleFonts.montserrat(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  if (doctor["freeHours"] != null &&
                                      doctor["freeHours"].isNotEmpty)
                                    Column(
                                      children:
                                          doctor["freeHours"].where((entry) {
                                        // Ensure entry["hours"] is not empty and is a valid string
                                        return entry["hours"] != null &&
                                            entry["hours"]!.isNotEmpty;
                                      }).map<Widget>((entry) {
                                        final day = entry["day"] ?? "N/A";
                                        final hours = entry["hours"] ?? "N/A";

                                        return Transform.scale(
                                          scale:
                                              0.9, // Adjust the scale to make the tile smaller
                                          child: RadioListTile<String>(
                                            activeColor: Color(0xFF29A5D6),
                                            dense:
                                                true, // Makes the tile more compact
                                            contentPadding: EdgeInsets
                                                .zero, // Reduces padding around the tile
                                            title: Text(
                                              "$day ($hours)",
                                              style: GoogleFonts.montserrat(
                                                fontSize:
                                                    14, // Adjust font size
                                              ),
                                            ),
                                            value: day,
                                            groupValue: selectedDay,
                                            onChanged: (value) {
                                              if (value != null) {
                                                final nextDate =
                                                    _getNextDate(value);
                                                setState(() {
                                                  selectedDay = value;
                                                  selectedDate =
                                                      nextDate; // Store the correct value when the radio button is selected
                                                  selectedHours =
                                                      hours; // Store the selected hours
                                                });
                                              }
                                            },
                                          ),
                                        );
                                      }).toList(),
                                    )
                                  else
                                    Text(
                                      "No Free Hours Available",
                                      style: GoogleFonts.montserrat(
                                          fontSize: 14,
                                          fontStyle: FontStyle.italic),
                                    ),
                                ],
                              )
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
