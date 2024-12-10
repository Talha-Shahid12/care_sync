import 'package:care_sync/Services/ApiCalls.dart';
import 'package:care_sync/Services/redux/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_fonts/google_fonts.dart';

class MedicalHistoryScreen extends StatefulWidget {
  final String appointmentId;
  final List<Map<String, String>> medicalHistories;
  final String patientId;

  const MedicalHistoryScreen({
    Key? key,
    required this.patientId,
    required this.appointmentId,
    required this.medicalHistories,
  }) : super(key: key);

  @override
  _MedicalHistoryScreenState createState() => _MedicalHistoryScreenState();
}

class _MedicalHistoryScreenState extends State<MedicalHistoryScreen> {
  late List<Map<String, String>> _medicalHistories;
  bool isLoading = false;
  String? errorMessage;
  final apiCalls = ApiCalls();
  String? token;
  String? prescription;
  String? diagnosis;
  @override
  void initState() {
    super.initState();
    _medicalHistories = List.from(
        widget.medicalHistories); // Initialize with the given histories
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    token = StoreProvider.of<AppState>(context).state.token;
  }

  // Function to load data from JSON
  Future<void> addMedicalHistory() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    if (token != null) {
      try {
        final result = await apiCalls.addMedicalHistory(diagnosis!,
            prescription!, token!, widget.patientId, widget.appointmentId);

        if (result["success"] == true) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Success!"),
                content: Text(result["message"]),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: Text("OK"),
                  ),
                ],
              );
            },
          );
          setState(() {
            isLoading = false;
          });
        } else {
          setState(() {
            errorMessage = "An error occurred: ${result["message"]}";
            isLoading = false;
          });
        }
      } catch (error) {
        setState(() {
          errorMessage = "An error occurred: $error";
          isLoading = false;
        });
      }
    } else {
      print("token is null");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Ensure white background

      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
          child: AppBar(
            leading: InkWell(
              child: Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 30,
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            title: Text(
              'MEDICAL HISTORY',
              style: GoogleFonts.montserrat(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
            backgroundColor: Color(0xFF29A5D6),
            centerTitle: true,
          ),
        ),
      ),
      body: Stack(
        children: [
          // Display medical histories or "No Medical History"
          _medicalHistories.isNotEmpty
              ? ListView.builder(
                  itemCount: _medicalHistories.length,
                  itemBuilder: (context, index) {
                    final history = _medicalHistories[index];
                    return Container(
                      margin: const EdgeInsets.all(10),
                      child: Card(
                        elevation: 8, // Increased elevation for shadow
                        child: ListTile(
                          title: Row(
                            children: [
                              Text(
                                "🩺  Diagnosis: ",
                                style: GoogleFonts.montserrat(
                                    fontSize: 13, fontWeight: FontWeight.bold),
                              ),
                              Expanded(
                                child: Text(
                                  "${history["diagnosis"]}",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 13,
                                  ),
                                  softWrap: true, // Allows the text to wrap
                                ),
                              ),
                            ],
                          ),
                          subtitle: Row(
                            children: [
                              Text(
                                "📝  Medication Notes: ",
                                style: GoogleFonts.montserrat(
                                    fontSize: 13, fontWeight: FontWeight.bold),
                              ),
                              Expanded(
                                child: Text(
                                  "${history["prescription"]}",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 13,
                                  ),
                                  softWrap:
                                      true, // Ensures the text wraps when it reaches the edge
                                  overflow: TextOverflow
                                      .visible, // Makes sure text is not clipped
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                )
              : Center(
                  child: Text(
                    "No Medical History",
                    style: GoogleFonts.montserrat(color: Color(0xFF29A5D6)),
                  ),
                ),

          // Floating action button to add medical history
          Positioned(
            bottom: 100, // Position the button near the bottom
            right: 16, // Keep the button on the right side
            child: FloatingActionButton(
              onPressed: () {
                _showAddMedicalHistoryPopup(context);
              },
              backgroundColor: Theme.of(context).primaryColor,
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ), // Add sign
            ),
          ),

          // Loading overlay
          if (isLoading)
            Container(
              color: Colors.white.withOpacity(0.5), // Dim background
              child: const Center(
                child: CircularProgressIndicator(color: Color(0xFF29A5D6)),
              ),
            ),

          // Error message
          if (errorMessage != null)
            Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.symmetric(horizontal: 32),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  errorMessage!,
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showAddMedicalHistoryPopup(BuildContext context) {
    final diagnosisController = TextEditingController();
    final prescriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          elevation: 20,
          shadowColor: Color(0xFF29A5D6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8, // Adjustable width
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "👩‍⚕️   Add Medical History",
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Color(0xFF29A5D6),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: diagnosisController,
                  decoration: InputDecoration(
                    labelText: "Diagnosis",
                    labelStyle: GoogleFonts.montserrat(),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: prescriptionController,
                  maxLines: 5, // Make the text field taller
                  decoration: InputDecoration(
                    labelText: "Prescription",
                    labelStyle: GoogleFonts.montserrat(),
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the popup
                      },
                      child: Text(
                        "Cancel",
                        style: GoogleFonts.montserrat(),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (diagnosisController.text.trim().isEmpty ||
                            prescriptionController.text.trim().isEmpty) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(
                                  "Error",
                                  style: GoogleFonts.montserrat(),
                                ),
                                content: Text(
                                    "No field should be empty. Please fill out all fields."),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); // Close the dialog
                                    },
                                    child: Text("OK"),
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          final newHistory = {
                            "diagnosis": diagnosisController.text,
                            "prescription": prescriptionController.text,
                          };

                          setState(() {
                            _medicalHistories
                                .add(newHistory); // Add the new history
                          });
                          setState(() {
                            prescription = prescriptionController.text.trim();
                            diagnosis = diagnosisController.text.trim();
                          });
                          addMedicalHistory();
                          Navigator.of(context).pop(); // Close the popup
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF29A5D6), // Orange color
                      ),
                      child: Text(
                        "Add",
                        style: GoogleFonts.montserrat(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
