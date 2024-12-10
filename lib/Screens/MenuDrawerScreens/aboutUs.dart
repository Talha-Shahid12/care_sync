import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:care_sync/Components/customDrawer.dart';

class AboutUsScreen extends StatelessWidget {
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
                'ABOUT US',
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
                    "About CareSync",
                    style: GoogleFonts.montserrat(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "CareSync is designed to revolutionize the way doctors and patients interact. "
                    "Our platform bridges the communication gap, ensuring better appointment management "
                    "and more personalized care.",
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Our Mission",
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "At CareSync, our mission is to enhance healthcare by providing a seamless, "
                    "user-friendly platform that empowers both doctors and patients. We aim to "
                    "reduce missed appointments and promote adherence to treatment plans.",
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Key Features",
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "- Appointment booking and reminders\n"
                    "- Patient record management\n"
                    "- Treatment history access\n"
                    "- Secure data handling",
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Why Choose Us?",
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "CareSync is built with the latest technology to ensure a smooth and efficient experience. "
                    "We prioritize data security, user convenience, and feature-rich functionalities "
                    "that cater to the needs of modern healthcare.",
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Contact Us",
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "For more information or inquiries, feel free to reach out to us via email at support@caresync.com. "
                    "We’re here to help!",
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
