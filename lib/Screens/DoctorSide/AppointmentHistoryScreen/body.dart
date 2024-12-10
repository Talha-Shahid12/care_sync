import 'package:care_sync/Services/ApiCalls.dart';
import 'package:care_sync/Services/redux/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_fonts/google_fonts.dart';

class DoctorAppointmentHistoryBody extends StatefulWidget {
  @override
  _DoctorAppointmentHistoryBodyState createState() =>
      _DoctorAppointmentHistoryBodyState();
}

class _DoctorAppointmentHistoryBodyState
    extends State<DoctorAppointmentHistoryBody>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String selectedTab = "Scheduled";
  Set<int> expandedIndices = {};
  bool isLoading = true;
  String? token;
  String? errorMessage;
  List<dynamic> scheduledAppointments = [];
  List<dynamic> completedAppointments = [];
  final apiCalls = ApiCalls();
  String? doctorId;

  Future<void> loadAppointments() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    if (token != null) {
      try {
        final result =
            await apiCalls.getAppointmentsHistoryForDoctor(doctorId!, token!);

        if (result["success"] == true) {
          final List<dynamic> appointmentList = result["message"];

          // Check if the widget is still mounted before calling setState
          if (mounted) {
            setState(() {
              scheduledAppointments = appointmentList
                  .where((appointment) => appointment["status"] == "SCHEDULED")
                  .toList();
              completedAppointments = appointmentList
                  .where((appointment) => appointment["status"] == "COMPLETED")
                  .toList();
              isLoading = false;
            });
          }
        } else {
          print("[Error]: ${result["message"]}");

          // Check if the widget is still mounted before calling setState
          if (mounted) {
            setState(() {
              errorMessage = result["message"];
              isLoading = false;
            });
          }
        }
      } catch (error) {
        // Check if the widget is still mounted before calling setState
        if (mounted) {
          setState(() {
            errorMessage = "An error occurred: $error";
            isLoading = false;
          });
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    token = StoreProvider.of<AppState>(context).state.token;
    doctorId = StoreProvider.of<AppState>(context).state.doctorId;
    loadAppointments();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: Container(
                child: CircularProgressIndicator(
            color: Color(0xFF29A5D6),
          )))
        : Container(
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  color: Colors.white,
                  child: TabBar(
                    controller: _tabController,
                    indicatorColor: Colors.transparent,
                    onTap: (index) {
                      setState(() {
                        selectedTab = index == 0 ? "Scheduled" : "Completed";
                      });
                    },
                    tabs: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Radio<String>(
                            activeColor: Color(0xFF29A5D6),
                            value: "Scheduled",
                            groupValue: selectedTab,
                            onChanged: (value) {
                              _tabController.index = 0;
                              setState(() {
                                selectedTab = value!;
                              });
                            },
                          ),
                          Text(
                            "Scheduled",
                            style: GoogleFonts.montserrat(),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Radio<String>(
                            activeColor: Color(0xFF29A5D6),
                            value: "Completed",
                            groupValue: selectedTab,
                            onChanged: (value) {
                              _tabController.index =
                                  1; // Switch to Completed Tab
                              setState(() {
                                selectedTab = value!;
                              });
                            },
                          ),
                          Text(
                            "Completed",
                            style: GoogleFonts.montserrat(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // Scheduled Appointments Tab
                      _buildScheduledTab(),
                      // Completed Appointments Tab
                      _buildCompletedTab(),
                    ],
                  ),
                ),
              ],
            ),
          );
  }

  Widget _buildScheduledTab() {
    if (scheduledAppointments.isEmpty) {
      return Center(
        child: Text(
          "No appointments",
          style: GoogleFonts.montserrat(fontSize: 16, color: Color(0xFF29A5D6)),
        ),
      );
    }
    return ListView.builder(
      itemCount: scheduledAppointments.length,
      itemBuilder: (context, index) {
        final appointment = scheduledAppointments[index];
        return Card(
          margin: EdgeInsets.all(10.0),
          elevation: 8.0, // Increase shadow intensity
          color: Color(0xFFEEEEEE), // Light gray color for card
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Mr/Ms. ${appointment['patientName']}",
                  style: GoogleFonts.montserrat(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  appointment['contactNumber'],
                  style: GoogleFonts.montserrat(
                      fontSize: 16,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  "Date: ${appointment['appointmentDate']}",
                  style: GoogleFonts.montserrat(
                      fontSize: 13, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Time: ${appointment['appointmentTime']}",
                  style: GoogleFonts.montserrat(
                      fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCompletedTab() {
    if (completedAppointments.isEmpty) {
      return Center(
        child: Text(
          "No appointments",
          style: GoogleFonts.montserrat(fontSize: 16, color: Color(0xFF29A5D6)),
        ),
      );
    }
    return ListView.builder(
      itemCount: completedAppointments.length,
      itemBuilder: (context, index) {
        final appointment = completedAppointments[index];
        final isExpanded = expandedIndices.contains(index);
        return Card(
          margin: EdgeInsets.all(10.0),
          elevation: 8.0,
          color: Color(0xFFEEEEEE),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Mr/Ms. ${appointment['patientName']}",
                  style: GoogleFonts.montserrat(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  appointment['contactNumber'],
                  style: GoogleFonts.montserrat(
                      fontSize: 16,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  "Date: ${appointment['appointmentDate']}",
                  style: GoogleFonts.montserrat(
                      fontSize: 13, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Time: ${appointment['appointmentTime']}",
                  style: GoogleFonts.montserrat(
                      fontSize: 13, fontWeight: FontWeight.bold),
                ),
                if (isExpanded) ...[
                  SizedBox(height: 8),
                  Divider(color: Colors.grey),
                  ...appointment['medicalHistories'].map<Widget>((history) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "👩‍⚕️ Diagnosis:",
                          style: GoogleFonts.montserrat(
                              fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "🩺    ${history['diagnosis'] ?? 'N/A'}",
                          style: GoogleFonts.montserrat(fontSize: 13),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "📝 Medication Notes:",
                          style: GoogleFonts.montserrat(
                              fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "💊     ${history['prescription'] ?? 'N/A'}",
                          style: GoogleFonts.montserrat(fontSize: 13),
                        ),
                        Divider(color: Colors.grey),
                      ],
                    );
                  }).toList(),
                ],
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: Icon(
                      isExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: Theme.of(context).primaryColor,
                    ),
                    onPressed: () {
                      setState(() {
                        if (isExpanded) {
                          expandedIndices.remove(index);
                        } else {
                          expandedIndices.add(index);
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
