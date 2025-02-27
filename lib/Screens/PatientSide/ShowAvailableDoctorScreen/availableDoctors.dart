import 'package:care_sync/Components/customDrawer.dart';
import 'package:care_sync/Screens/PatientSide/AppointmentHistoryScreen/body.dart';
import 'package:care_sync/Screens/PatientSide/ShowAvailableDoctorScreen/body.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AvailableDoctors extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0), // Reduced height of the AppBar
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
          child: AppBar(
            title: Text(
              'DASHBOARD',
              style: GoogleFonts.montserrat(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: Color(0xFF29A5D6), //#29A5D6//
            centerTitle: true,
            leading: Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: Icon(Icons.menu,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Scaffold.of(context).openDrawer(); // Opens the drawer
                  },
                );
              },
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Body content
          Expanded(
            child: DoctorsListBody(),
          ),
        ],
      ),
    );
  }
}
