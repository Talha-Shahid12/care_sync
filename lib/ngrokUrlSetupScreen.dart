import 'package:care_sync/Services/localStorageService.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NgrokScreen extends StatelessWidget {
  TextEditingController _urlController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'SERVER CONFIG',
          style: GoogleFonts.montserrat(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFF29A5D6),
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new,
            size: 30,
          ),
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              "⚠ Note: ",
              style: GoogleFonts.montserrat(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: Text(
                "This is configuration screen for NGROK server. Make sure and recheck the URL data before proceeding.",
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  // fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ),
            SizedBox(height: 50),
            TextField(
              controller: _urlController,
              decoration: InputDecoration(
                labelText: 'Ngrok URL',
                labelStyle: GoogleFonts.montserrat(),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF29A5D6)),
                ),
              ),
            ),
            SizedBox(height: 16),
            SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  if (_urlController != null &&
                      _urlController.text.isNotEmpty) {
                    try {
                      await SessionStorage.storeBaseUrl(
                          baseUrl: _urlController.text);
                      Navigator.pop(context);
                    } catch (e) {
                      print(e);
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Please enter Ngrok URL'),
                      backgroundColor: Colors.red,
                    ));
                  }
                  // Action for Ngrok configuration
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF29A5D6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: Text(
                  'SAVE CONFIGURATION',
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
