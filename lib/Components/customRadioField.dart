import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomRadioField extends StatefulWidget {
  final String labelText;
  final Function(String)? onChanged;

  CustomRadioField({
    required this.labelText,
    this.onChanged,
  });

  @override
  _CustomRadioFieldState createState() => _CustomRadioFieldState();
}

class _CustomRadioFieldState extends State<CustomRadioField> {
  String? _selectedValue; // Holds the selected value: "Doctor" or "Patient"

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.0),
      constraints: BoxConstraints(
        minHeight: 60.0, // Matches the height of the text field
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(21.0),
        border: Border.all(color: Colors.black, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 10,
          ),
          Text(
            widget.labelText,
            style: GoogleFonts.montserrat(color: Colors.black, fontSize: 16),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: RadioListTile<String>(
                  title: Text('Doctor', style: GoogleFonts.montserrat()),
                  value: 'DOCTOR',
                  groupValue: _selectedValue,
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  onChanged: (value) {
                    setState(() {
                      _selectedValue = value;
                      if (widget.onChanged != null) {
                        widget.onChanged!(value!);
                      }
                    });
                  },
                ),
              ),
              Expanded(
                child: RadioListTile<String>(
                  activeColor: Color(0xFF29A5D6),
                  title: Text('Patient', style: GoogleFonts.montserrat()),
                  value: 'PATIENT',
                  groupValue: _selectedValue,
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  onChanged: (value) {
                    setState(() {
                      _selectedValue = value;
                      if (widget.onChanged != null) {
                        widget.onChanged!(value!);
                      }
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
