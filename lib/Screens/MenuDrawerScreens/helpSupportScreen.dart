import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:care_sync/Components/customDrawer.dart';

class HelpSupportScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: CustomDrawer(),
      body: Column(
        children: [
          // Custom AppBar with rounded bottom corners
          ClipRRect(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            child: AppBar(
              title: Text(
                'HELP & SUPPORT',
                style: GoogleFonts.montserrat(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: Color(0xFF29A5D6),
              centerTitle: true,
              leading: Builder(
                builder: (BuildContext context) {
                  return IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  );
                },
              ),
              flexibleSpace: Container(
                height: 106, // Adjust to match AppBar height
              ),
            ),
          ),
          // Body content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "User Guide",
                    style: GoogleFonts.montserrat(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Welcome to CareSync! This app is designed to improve communication and management of patient appointments. "
                    "Here’s how to get started:",
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "For Patients",
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "- Book appointments with your doctor seamlessly.\n"
                    "- Receive reminders 24 hours before your scheduled visit.\n"
                    "- Access past appointments and treatment history.",
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "For Doctors",
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "- Record and manage patient details including prescribed medications and treatments.\n"
                    "- Quickly access patient history for follow-up visits.\n"
                    "- Send reminders to patients about upcoming appointments.",
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "App Features",
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "- Easy appointment booking for patients.\n"
                    "- Secure management of patient records for doctors.\n"
                    "- Reminder notifications to reduce missed appointments.\n"
                    "- Access to treatment history for continuity of care.",
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Need Help?",
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "For any issues or support, please contact us through the app or via email. Our team is here to help you.",
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
