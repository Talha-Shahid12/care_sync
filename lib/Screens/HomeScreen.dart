import 'package:care_sync/Screens/DoctorSide/AppointmentHistoryScreen/appointmentHistory.dart';
import 'package:care_sync/Screens/DoctorSide/ProfileScreen/profile.dart';
import 'package:care_sync/Screens/DoctorSide/ShowAvailableAppointments/showAvailableAppointments.dart';
import 'package:care_sync/Screens/PatientSide/AppointmentHistoryScreen/appointmentHistory.dart';
import 'package:care_sync/Screens/PatientSide/ProfileScreen/profile.dart';
import 'package:care_sync/Screens/PatientSide/ShowAvailableDoctorScreen/availableDoctors.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final String userType;

  HomeScreen({required this.userType});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  // Doctor-specific screens and navigation items
  final List<Widget> doctorScreens = [
    DoctorAppointmentsScreen(),
    DoctorAppointmentHistoryScreen(),
    DoctorProfileScreen(),
  ];

  final List<BottomNavigationBarItem> doctorNavItems = [
    BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: ''),
    BottomNavigationBarItem(icon: Icon(Icons.history_edu_outlined), label: ''),
    BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
  ];

  // Patient-specific screens and navigation items
  final List<Widget> patientScreens = [
    AvailableDoctors(),
    AppointmentHistoryScreen(),
    PatientProfileScreen(),
  ];

  final List<BottomNavigationBarItem> patientNavItems = [
    BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: ''),
    BottomNavigationBarItem(icon: Icon(Icons.history_edu_outlined), label: ''),
    BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
  ];

  @override
  Widget build(BuildContext context) {
    // Choose screens and navigation items based on userType
    final isDoctor = widget.userType == 'DOCTOR';
    final screens = isDoctor ? doctorScreens : patientScreens;
    final navItems = isDoctor ? doctorNavItems : patientNavItems;

    return Scaffold(
      body: screens[_currentIndex], // Render the current screen
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Color(0xFF29A5D6),
        currentIndex: _currentIndex,
        items: navItems, // Conditionally render navigation items
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
