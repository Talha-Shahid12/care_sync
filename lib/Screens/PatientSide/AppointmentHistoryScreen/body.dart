import 'package:flutter/material.dart';

class AppointmentHistoryBody extends StatefulWidget {
  @override
  _AppointmentHistoryBodyState createState() => _AppointmentHistoryBodyState();
}

class _AppointmentHistoryBodyState extends State<AppointmentHistoryBody>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String selectedTab = "Upcoming"; // Tracks selected tab
  Set<int> expandedIndices =
      {}; // Tracks expanded indices for past appointments

  List<Map<String, dynamic>> upcomingAppointments = [
    {
      "doctorName": "Dr. John Doe",
      "hospitalName": "City Hospital",
      "appointmentDate": "2024-11-30",
      "appointmentTime": "10:00 AM",
    },
    {
      "doctorName": "Dr. Jane Smith",
      "hospitalName": "General Hospital",
      "appointmentDate": "2024-12-05",
      "appointmentTime": "2:30 PM",
    },
  ];

  List<Map<String, dynamic>> pastAppointments = [
    {
      "doctorName": "Dr. Alice Brown",
      "hospitalName": "Downtown Clinic",
      "appointmentDate": "2024-10-15",
      "appointmentTime": "3:00 PM",
      "medicationNotes": "Take 1 tablet of Ibuprofen after meals for 5 days.",
    },
    {
      "doctorName": "Dr. Charlie Davis",
      "hospitalName": "HealthCare Center",
      "appointmentDate": "2024-10-01",
      "appointmentTime": "1:00 PM",
      "medicationNotes": "Apply ointment twice a day for 2 weeks.",
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white, // Set background color to white
      child: Column(
        children: [
          // Tab Bar with Radio Buttons
          Container(
            color: Colors.white, // Keep tab background white
            child: TabBar(
              controller: _tabController,
              indicatorColor: Colors.transparent, // Remove underline divider
              onTap: (index) {
                setState(() {
                  selectedTab = index == 0 ? "Upcoming" : "Past";
                });
              },
              tabs: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Radio<String>(
                      value: "Upcoming",
                      groupValue: selectedTab,
                      onChanged: (value) {
                        _tabController.index = 0; // Switch to Upcoming Tab
                        setState(() {
                          selectedTab = value!;
                        });
                      },
                    ),
                    Text("Upcoming"),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Radio<String>(
                      value: "Past",
                      groupValue: selectedTab,
                      onChanged: (value) {
                        _tabController.index = 1; // Switch to Past Tab
                        setState(() {
                          selectedTab = value!;
                        });
                      },
                    ),
                    Text("Past"),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Upcoming Appointments Tab
                _buildUpcomingTab(),
                // Past Appointments Tab
                _buildPastTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingTab() {
    return ListView.builder(
      itemCount: upcomingAppointments.length,
      itemBuilder: (context, index) {
        final appointment = upcomingAppointments[index];
        return Card(
          margin: EdgeInsets.all(16.0),
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
                  "Doctor: ${appointment['doctorName']}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  appointment['hospitalName'],
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  "Date: ${appointment['appointmentDate']}",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Time: ${appointment['appointmentTime']}",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPastTab() {
    return ListView.builder(
      itemCount: pastAppointments.length,
      itemBuilder: (context, index) {
        final appointment = pastAppointments[index];
        final isExpanded = expandedIndices.contains(index);
        return Card(
          margin: EdgeInsets.all(8.0),
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
                  "Doctor: ${appointment['doctorName']}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  appointment['hospitalName'],
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  "Date: ${appointment['appointmentDate']}",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Time: ${appointment['appointmentTime']}",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
                if (isExpanded) ...[
                  SizedBox(height: 8),
                  Divider(color: Colors.grey),
                  Text(
                    "Medication Notes:",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(appointment['medicationNotes']),
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
