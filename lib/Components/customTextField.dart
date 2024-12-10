import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool obscureText;
  final Function(String)? onChanged;
  final TextInputType?
      keyboardType; // Added keyboardType as an optional parameter

  CustomTextField({
    required this.controller,
    required this.labelText,
    this.obscureText = false,
    this.onChanged,
    this.keyboardType, // Pass keyboardType here
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      onChanged: onChanged,
      style: GoogleFonts.montserrat(color: Colors.black),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: GoogleFonts.montserrat(color: Colors.black),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(21.0),
        ),
      ),
      keyboardType: keyboardType, // Apply keyboardType to TextField
    );
  }
}
