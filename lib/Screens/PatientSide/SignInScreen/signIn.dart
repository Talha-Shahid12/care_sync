import 'package:flutter/material.dart';
import 'body.dart'; // Importing the body.dart file
import 'package:google_fonts/google_fonts.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
          child: AppBar(
            automaticallyImplyLeading: false,
            title: Text(
              'Welcome Back !',
              style: GoogleFonts.montserrat(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: Color(0xFF29A5D6), //#29A5D6//
            centerTitle: true,
          ),
        ),
      ),
      body: Column(
        children: [
          // Body content
          Expanded(
            child: SignInBody(),
          ),
        ],
      ),
    );
  }
}
