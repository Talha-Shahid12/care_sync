import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:care_sync/Components/customDrawer.dart';

class PrivacyPolicyScreen extends StatelessWidget {
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
                'PRIVACY POLICY',
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
                      Navigator.pop(context); // Opens the drawer
                    },
                  );
                },
              ),
              flexibleSpace: Container(
                height: 106, // Adjust this to match your AppBar height
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
                    "Privacy Policy",
                    style: GoogleFonts.montserrat(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "[Effective Date: Dec 16, 2024]",
                    style: GoogleFonts.montserrat(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 114, 97, 97),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Welcome to CareSync! We are committed to protecting your privacy and ensuring the security of "
                    "your personal information. This Privacy Policy explains how we collect, use, and safeguard your data "
                    "when you use our app.",
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Information We Collect",
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "We collect personal information that you voluntarily provide to us when registering, "
                    "expressing an interest in obtaining information about us or our products, or otherwise contacting us.",
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "How We Use Your Information",
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "We use personal information collected via our app for a variety of business purposes, including: "
                    "to provide and deliver services, improve our app functionality, and communicate with you.",
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Your Privacy Rights",
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "You have the right to access, update, and delete your personal information. "
                    "To exercise these rights, please contact us through the app or via email.",
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
