import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomRetryButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;
  final double width;
  final Color backgroundColor;

  CustomRetryButton({
    required this.onPressed,
    required this.buttonText,
    this.width = double.infinity, // Default to full width
    this.backgroundColor = const Color(0xFF29A5D6), // Default color
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width, // Set the width of the button
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(21.0), // Rounded button
          ),
        ),
        child: Text(
          buttonText,
          style: GoogleFonts.montserrat(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
        ),
      ),
    );
  }
}
