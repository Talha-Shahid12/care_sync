import 'dart:convert';
import 'dart:io';

import 'package:care_sync/Components/customButton.dart';
import 'package:care_sync/Components/customDrawer.dart';
import 'package:care_sync/Services/ApiCalls.dart';
import 'package:care_sync/Services/localStorageService.dart';
import 'package:care_sync/Services/redux/actions.dart';
import 'package:care_sync/Services/redux/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class DoctorProfileScreen extends StatefulWidget {
  @override
  _DoctorProfileScreenState createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {
  // Controller for other fields (First Name, Last Name, etc.)
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _specializationController =
      TextEditingController();
  final TextEditingController _hospitalNameController = TextEditingController();
  final TextEditingController _consultantFeeController =
      TextEditingController();
  List<TextEditingController> _freeHourControllers = [];

  bool isFirstNameEditable = false;
  bool isLastNameEditable = false;
  bool isSpecializationEditable = false;
  bool isConsultationFeeEditable = false;
  bool isHospitalNameEditable = false;
  bool isLoading = true;
  String? errorMessage = "";
  String? token;
  String? userId;
  File? _selectedImage;
  String? imageBase64;
  bool isPicLoading = true;
  String? updatedImage;
  String? fcmtoken;
  String? usrId;
  String? usrType;
  String? patntId;
  String? doctrId;
  List<Map<String, String>> _freeHours = [
    {"Day": "Monday", "Hours": ""},
    {"Day": "Tuesday", "Hours": ""},
    {"Day": "Wednesday", "Hours": ""},
    {"Day": "Thursday", "Hours": ""},
    {"Day": "Friday", "Hours": ""},
    {"Day": "Saturday", "Hours": ""},
    {"Day": "Sunday", "Hours": ""},
  ];

  final apiCalls = ApiCalls();
  bool isUpdateButtonEnabled = false;

  Future<void> updateInfo() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    if (token != null) {
      try {
        final result = await apiCalls.updateDoctorInfo(
          userId!,
          _firstNameController.text,
          _lastNameController.text,
          _specializationController.text,
          _hospitalNameController.text,
          _consultantFeeController.text,
          _freeHours,
          token!,
        );

        if (result["success"] == true) {
          await SessionStorage.storeSessionData(
            userId: usrId!,
            patientId: patntId!,
            doctorId: doctrId!,
            userType: usrType!,
            jwtToken: token!,
            firstName: _firstNameController.text,
            lastName: _lastNameController.text,
            email: _emailController.text,
          );
          await SessionStorage.storeFcmToken(fcmToken: fcmtoken!);
          UpdateTokenAction(
            doctorId: doctrId!,
            token: token!,
            patientId: patntId!,
            id: usrId!,
            userType: usrType!,
            firstName: _firstNameController.text,
            lastName: _lastNameController.text,
            email: _emailController.text,
          );

          setState(() {
            isLoading = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Information updated successfully"),
            duration: Duration(seconds: 2),
          ));
        } else {
          setState(() {
            errorMessage = result["message"];
            isLoading = false;
          });
        }
      } catch (error) {
        setState(() {
          errorMessage = "An error occurred: $error";
          isLoading = false;
        });
      }
    }
  }

  Future<void> _fetchUserImage() async {
    try {
      setState(() {
        isPicLoading = true;
      });
      final response = await apiCalls.getImageByUserId(userId!, token!);
      if (response['success'] == true) {
        setState(() {
          isPicLoading = false;
          imageBase64 = response['imageData']; // Store the Base64 image string
        });
      }
    } catch (e) {
      setState(() {
        isPicLoading = false;
      });
      print("Error fetching image: $e");
    }
  }

  Future<void> loadInfo() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    if (token != null) {
      try {
        final result = await apiCalls.getDoctorInfo(userId!, token!);

        if (result["success"] == true) {
          setState(() {
            isLoading = false;
            _firstNameController.text = result["message"]["firstName"];
            _lastNameController.text = result["message"]["lastName"];
            _emailController.text = result["message"]["email"];
            _specializationController.text =
                result["message"]["specialization"];
            _hospitalNameController.text = result["message"]["hospitalName"];
            _consultantFeeController.text =
                result["message"]["consultationFee"].toString();

            var freeHoursData = result["message"]["freeHours"];
            if (freeHoursData is String) {
              List<dynamic> decodedList = jsonDecode(freeHoursData);
              _freeHours = decodedList
                  .map((e) =>
                      Map<String, String>.from(e as Map<String, dynamic>))
                  .toList();
            } else if (freeHoursData is List) {
              _freeHours = List<Map<String, String>>.from(freeHoursData.map(
                  (e) => Map<String, String>.from(e as Map<String, dynamic>)));
            }

            // Initialize the controllers for each day's hours.
            _freeHourControllers = _freeHours
                .map((item) => TextEditingController(text: item['Hours']))
                .toList();
          });

          await _fetchUserImage();
        } else {
          setState(() {
            errorMessage = result["message"];
            isLoading = false;
          });
        }
      } catch (error) {
        setState(() {
          print('catched error: $error');
          errorMessage = "An error occurred: $error";
          isLoading = false;
        });
      }
    }
  }

  Future<void> _showImagePicker() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Select from Gallery'),
                onTap: () => _pickImage(ImageSource.gallery),
              ),
              ListTile(
                leading: Icon(Icons.camera),
                title: Text('Take from Camera'),
                onTap: () => _pickImage(ImageSource.camera),
              ),
              ListTile(
                leading: Icon(Icons.cancel),
                title: Text('Cancel'),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });

      Navigator.pop(context); // Close the modal
      _uploadImageToBackend(_selectedImage!); // Upload image
    }
  }

  Future<String> encodeImageToBase64(File imageFile) async {
    try {
      final imageBytes = await imageFile.readAsBytes();
      final base64String = base64Encode(imageBytes);

      return base64String;
    } catch (e) {
      print("Error encoding image to Base64: $e");
      return '';
    }
  }

  Future<void> _uploadImageToBackend(File imageFile) async {
    try {
      setState(() {
        isPicLoading = true;
      });
      final response = await apiCalls.uploadImage(userId!, imageFile, token!);
      final base64Image = await encodeImageToBase64(imageFile);

      if (response['success'] == true) {
        UpdateImage(image: base64Image);
        SessionStorage.storeImage(image: base64Image);
        setState(() {
          imageBase64 = base64Image;
        });
        setState(() {
          isPicLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response["message"])),
        );
      } else {
        setState(() {
          isPicLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response["message"])),
        );
      }
    } catch (error) {
      setState(() {
        isPicLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }
  }

  @override
  void dispose() {
    // Dispose all the free hour controllers
    for (var controller in _freeHourControllers) {
      controller.dispose();
    }
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _specializationController.dispose();
    _hospitalNameController.dispose();
    _consultantFeeController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    token = StoreProvider.of<AppState>(context).state.token;
    userId = StoreProvider.of<AppState>(context).state.id;
    usrId = StoreProvider.of<AppState>(context).state.id;
    usrType = StoreProvider.of<AppState>(context).state.userType;
    patntId = StoreProvider.of<AppState>(context).state.patientId;
    doctrId = StoreProvider.of<AppState>(context).state.doctorId;
    fcmtoken = StoreProvider.of<AppState>(context).state.fcmToken;
    loadInfo();
  }

  void enableUpdateButton() {
    setState(() {
      isUpdateButtonEnabled = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: CustomDrawer(),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
          child: AppBar(
            leading: Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: Icon(
                    Icons.menu,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Scaffold.of(context).openDrawer(); // Opens the drawer
                  },
                );
              },
            ),
            title: Text(
              'PROFILE',
              style: GoogleFonts.montserrat(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
            backgroundColor: Color(0xFF29A5D6),
            centerTitle: true,
          ),
        ),
      ),
      body: isLoading
          ? Container(
              color: Colors.white.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(color: Color(0xFF29A5D6)),
              ),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage:
                            imageBase64 != null && imageBase64!.isNotEmpty
                                ? MemoryImage(base64Decode(imageBase64!))
                                : AssetImage('assets/Images/doctor_avatar.jpg')
                                    as ImageProvider,
                      ),

                      // Edit Icon positioned at top-right of the CircleAvatar
                      Positioned(
                        top: 0,
                        right: 0,
                        child: InkWell(
                            onTap: _showImagePicker,
                            child: Icon(
                              Icons.camera_alt_rounded,
                              color: Color(0xFF29A5D6),
                            )),
                      ),

                      // CircularProgressIndicator if isPicLoading is true
                      if (isPicLoading)
                        Positioned(
                          child: CircularProgressIndicator(
                            color: Colors.black,
                          ),
                          top: 30, // Adjust top position if needed
                          left: 30, // Adjust left position if needed
                        ),
                    ],
                  ),

                  SizedBox(height: 50),
                  _buildEditableField(
                    label: "First Name",
                    controller: _firstNameController,
                    isEditable: isFirstNameEditable,
                    onEditPressed: () {
                      setState(() {
                        isFirstNameEditable = true;
                      });
                      enableUpdateButton();
                    },
                  ),
                  SizedBox(height: 16),
                  _buildEditableField(
                    label: "Last Name",
                    controller: _lastNameController,
                    isEditable: isLastNameEditable,
                    onEditPressed: () {
                      setState(() {
                        isLastNameEditable = true;
                      });
                      enableUpdateButton();
                    },
                  ),
                  SizedBox(height: 16),
                  _buildReadOnlyField(
                    label: "Email",
                    value: _emailController.text,
                  ),
                  SizedBox(height: 16),
                  _buildEditableField(
                    label: "Specialization",
                    controller: _specializationController,
                    isEditable: isSpecializationEditable,
                    onEditPressed: () {
                      setState(() {
                        isSpecializationEditable = true;
                      });
                      enableUpdateButton();
                    },
                  ),
                  SizedBox(height: 16),
                  _buildEditableField(
                    label: "Hospital Name",
                    controller: _hospitalNameController,
                    isEditable: isHospitalNameEditable,
                    onEditPressed: () {
                      setState(() {
                        isHospitalNameEditable = true;
                      });
                      enableUpdateButton();
                    },
                  ),
                  SizedBox(height: 16),
                  _buildEditableField(
                    label: "Consultation Fee",
                    controller: _consultantFeeController,
                    isEditable: isConsultationFeeEditable,
                    onEditPressed: () {
                      setState(() {
                        isConsultationFeeEditable = true;
                      });
                      enableUpdateButton();
                    },
                  ),
                  SizedBox(height: 16),
                  // Display free hours list
                  Text(
                    "Free Hours",
                    style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  // Separate Text Fields for Each Day
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _freeHours.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                _freeHours[index]['Day']!,
                                style: GoogleFonts.montserrat(fontSize: 14),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: TextField(
                                controller: _freeHourControllers[
                                    index], // Use the controller from the list
                                onChanged: (value) {
                                  setState(() {
                                    enableUpdateButton();
                                    _freeHours[index]['Hours'] =
                                        value; // Update the value in _freeHours
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: 'e.g., 10:00 AM - 12:00 PM',
                                  border: OutlineInputBorder(),
                                ),
                                style:
                                    GoogleFonts.montserrat(color: Colors.grey),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 32),
                  if (isUpdateButtonEnabled)
                    CustomButton(
                      onPressed: () {
                        setState(() {
                          isFirstNameEditable = false;
                          isLastNameEditable = false;
                          isSpecializationEditable = false;
                          isConsultationFeeEditable = false;
                          isHospitalNameEditable = false;
                          isUpdateButtonEnabled = false;
                        });
                        updateInfo();
                      },
                      width: 200,
                      buttonText: "Update",
                    ),
                ],
              ),
            ),
    );
  }

  Widget _buildEditableField({
    required String label,
    required TextEditingController controller,
    required bool isEditable,
    required VoidCallback onEditPressed,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            enabled: isEditable,
            decoration: InputDecoration(
              labelText: label,
              labelStyle: GoogleFonts.montserrat(),
              border: OutlineInputBorder(),
            ),
            style: GoogleFonts.montserrat(),
          ),
        ),
        IconButton(
          icon: Icon(Icons.edit, color: Color(0xFF29A5D6)),
          onPressed: onEditPressed,
        ),
      ],
    );
  }

  Widget _buildReadOnlyField({
    required String label,
    required String value,
  }) {
    return TextField(
      controller: TextEditingController(text: value),
      enabled: false,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.montserrat(),
        border: OutlineInputBorder(),
      ),
      style: GoogleFonts.montserrat(),
    );
  }
}
