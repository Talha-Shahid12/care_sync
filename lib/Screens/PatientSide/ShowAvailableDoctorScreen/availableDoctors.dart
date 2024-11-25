// ignore_for_file: prefer_const_constructors

import 'package:care_sync/Screens/PatientSide/ShowAvailableDoctorScreen/body.dart';
import 'package:flutter/material.dart';

class AvailableDoctors extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Available Doctors',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFFFF6720),
        centerTitle: true, // This centers the title
        leading: IconButton(
          icon: Image.asset(
            'assets/Images/backarrow.png',
            width: 30,
            height: 30,
          ), // Replace with your image path
          onPressed: () {
            Navigator.pop(context); // You can add custom action here
          },
        ),
      ),
      body: DoctorsListBody(), // Call the body widget
    );
  }
}
