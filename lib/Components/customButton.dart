import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;
  final double width;
  final Color backgroundColor;

  CustomButton({
    required this.onPressed,
    required this.buttonText,
    this.width = double.infinity, // Default to full width
    this.backgroundColor = const Color(0xFFFF6720), // Default color
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
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
