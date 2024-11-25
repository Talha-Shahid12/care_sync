// ignore_for_file: prefer_const_constructors

import 'package:care_sync/Screens/PatientSide/AppointmentHistoryScreen/body.dart';
import 'package:flutter/material.dart';

class AppointmentHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Appointment History',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFFFF6720),
        centerTitle: true,
        leading: IconButton(
          icon: Image.asset(
            'assets/Images/backarrow.png',
            width: 30,
            height: 30,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: AppointmentHistoryBody(),
    );
  }
}
