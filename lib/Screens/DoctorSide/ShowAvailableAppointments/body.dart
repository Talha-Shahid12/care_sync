import 'package:care_sync/Components/customButton.dart';
import 'package:care_sync/Screens/DoctorSide/ShowAvailableAppointments/MedicalHistoryScreen/medicalHistoryScreen.dart';
import 'package:care_sync/Services/ApiCalls.dart';
import 'package:care_sync/Services/localStorageService.dart';
import 'package:care_sync/Services/redux/actions.dart';
import 'package:care_sync/Services/redux/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_fonts/google_fonts.dart';

class AppointmentsBody extends StatefulWidget {
  const AppointmentsBody({Key? key}) : super(key: key);

  @override
  _AppointmentsBodyState createState() => _AppointmentsBodyState();
}

class _AppointmentsBodyState extends State<AppointmentsBody> {
  List<Map<String, dynamic>> appointments = [];
  bool isLoading = true;
  String? token;
  String? errorMessage;
  List<dynamic> scheduledAppointments = [];
  final apiCalls = ApiCalls();
  String? doctorId;
  String? id;

  Future<void> _retrieveSessionData() async {
    Map<String, String?> sessionData = await SessionStorage.getSessionData();

    String? userToken = sessionData['jwtToken'];
    String? userId = sessionData['userId'];
    String? userType = sessionData['userType'];
    String? patntId = sessionData['patientId'];
    String? doctrId = sessionData['doctorId'];
    String? fName = sessionData['firstName'];
    String? lName = sessionData['lastName'];
    String? emailId = sessionData['email'];
    String? img = sessionData['image'];
    print("Session Data Retrieved: ${sessionData['firstName']}");

    setState(() {
      token = userToken;
      id = userId;
      doctorId = doctrId;
    });

    // Check if the session data exists
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
        doctorId: doctrId ?? "",
      ));

      StoreProvider.of<AppState>(context)
          .dispatch(UpdateImage(image: img ?? ""));

      // Load doctors once token is available
      loadAppointments();
    } else {
      setState(() {
        isLoading = false;
        errorMessage = "Token not found!";
      });
    }
  }

  Future<void> loadAppointments() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    if (token != null) {
      try {
        final result =
            await apiCalls.getAppointmentsForDoctor(doctorId!, token!);

        if (result["success"] == true) {
          final List<dynamic> appointmentList = result["message"];
          setState(() {
            scheduledAppointments = appointmentList
                .where((appointment) => appointment["status"] == "SCHEDULED")
                .toList();
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

  @override
  void initState() {
    super.initState();
    _retrieveSessionData(); // Retrieve session data on screen load
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: Container(
              color: Colors.white.withOpacity(0.5), // Dim background
              child: const Center(
                child: CircularProgressIndicator(color: Color(0xFF29A5D6)),
              ),
            ),
          )
        : errorMessage != null
            ? Container(
                color: Colors.white,
                child: Center(
                    child: Text(
                  errorMessage!,
                  style: GoogleFonts.montserrat(color: Color(0xFF29A5D6)),
                )))
            : Container(
                color: Colors.white,
                child: ListView.builder(
                  itemCount: scheduledAppointments.length,
                  itemBuilder: (context, index) {
                    final appointment = scheduledAppointments[index];

                    // Ensure medicalHistories is a list of maps with String values
                    List<Map<String, String>> medicalHistories = [];
                    if (appointment['medicalHistories'] is List) {
                      medicalHistories = (appointment['medicalHistories']
                              as List)
                          .map((e) => (e as Map<String, dynamic>).map(
                              (key, value) => MapEntry(key, value.toString())))
                          .toList();
                    }

                    return Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ExpansionTile(
                          collapsedIconColor: Color(0xFF29A5D6),
                          iconColor: Color(0xFF29A5D6),
                          // tilePadding: EdgeInsets.zero, // Remove padding
                          title: Text(
                            "Mr. ${appointment['patientName']}",
                            style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${appointment['appointmentDate']}",
                                style: GoogleFonts.montserrat(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 91, 63, 63)),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "${appointment['appointmentTime']}",
                                style: GoogleFonts.montserrat(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 186, 109, 109),
                                ),
                              ),
                            ],
                          ),
                          children: [
                            ListTile(
                              title: Text(
                                "DOB: ${appointment['dob']}",
                                style: GoogleFonts.montserrat(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                "Contact: ${appointment['contactNumber']}",
                                style: GoogleFonts.montserrat(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            CustomButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MedicalHistoryScreen(
                                      patientId: appointment['patientId'],
                                      appointmentId:
                                          appointment['appointmentId'],
                                      medicalHistories: medicalHistories,
                                    ),
                                  ),
                                ).then((_) {
                                  loadAppointments();
                                });
                              },
                              width: 200,
                              buttonText: 'Medical History',
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
  }
}
