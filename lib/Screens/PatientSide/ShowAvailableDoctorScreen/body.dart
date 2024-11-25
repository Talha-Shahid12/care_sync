import 'dart:convert';
import 'package:care_sync/Components/customButton.dart';
import 'package:care_sync/Model/doctor.dart';
import 'package:flutter/material.dart';

class DoctorsListBody extends StatefulWidget {
  @override
  _DoctorsListBodyState createState() => _DoctorsListBodyState();
}

class _DoctorsListBodyState extends State<DoctorsListBody> {
  List<Doctor> doctors = [];
  List<bool> isExpandedList = [];

  // Function to load data from JSON
  Future<void> loadDoctors() async {
    String data = await DefaultAssetBundle.of(context)
        .loadString('assets/Data/doctors_data.json');
    List<dynamic> jsonResult = jsonDecode(data);
    setState(() {
      doctors = jsonResult.map((json) => Doctor.fromJson(json)).toList();
      isExpandedList = List<bool>.filled(
          doctors.length, false); // Update isExpandedList here
    });
  }

  @override
  void initState() {
    super.initState();
    loadDoctors();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set whole screen background to white
      body: doctors.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: doctors.length,
              itemBuilder: (context, index) {
                final doctor = doctors[index];
                final isExpanded = isExpandedList[index];

                return Card(
                  color: Color(0xFFEEEEEE), // Card background color
                  elevation: 8, // Shadow for the card
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    doctor.name,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    doctor.hospital,
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey[700],
                                        fontWeight: FontWeight.bold),
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
                                    color: const Color(0xFFFF6720),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      isExpandedList[index] = !isExpanded;
                                    });
                                  },
                                ),
                                CustomButton(
                                  onPressed: () {},
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: doctor.availability.entries.map((entry) {
                              int index = doctor.availability.entries
                                  .toList()
                                  .indexOf(entry);
                              return Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 4.0),
                                    child: Text(
                                      "${entry.key}: ${entry.value}",
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ),
                                  if (index !=
                                      doctor.availability.entries.length - 1)
                                    Divider(
                                      color: Colors.grey,
                                      thickness: 1,
                                      indent: 16, // Padding from the left
                                      endIndent: 16, // Padding from the right
                                    ),
                                ],
                              );
                            }).toList(),
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
