import 'dart:convert';
import 'dart:io';

import 'package:care_sync/Components/customButton.dart';
import 'package:care_sync/Components/customDrawer.dart';
import 'package:care_sync/Components/cutomRetryButton.dart';
import 'package:care_sync/Model/doctor.dart';
import 'package:care_sync/Services/ApiCalls.dart';
import 'package:care_sync/Services/localStorageService.dart';
import 'package:care_sync/Services/redux/actions.dart';
import 'package:care_sync/Services/redux/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class PatientProfileScreen extends StatefulWidget {
  @override
  _PatientProfileScreenState createState() => _PatientProfileScreenState();
}

class _PatientProfileScreenState extends State<PatientProfileScreen> {
  // Controllers for text fields
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _contactNumberController =
      TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  // Editable state for each field
  bool isFirstNameEditable = false;
  bool isLastNameEditable = false;
  bool isContactNumberEditable = false;
  bool isDateOfBirthEditable = false;
  bool isEmailEditable = false;
  bool isLoading = true; // Track loading state
  String? errorMessage = "";
  String? token;
  final apiCalls = ApiCalls();
  String? userId;
  String? usrId;
  File? _selectedImage;
  String? imageBase64;
  bool isPicLoading = true;
  String? usrType;
  String? patntId;
  String? doctrId;
  // Update button state
  bool isUpdateButtonEnabled = false;
  String? updatedImage;
  String? fcmtoken;
  String? currentImage;

  Future<void> updateInfo() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    if (token != null) {
      try {
        final result = await apiCalls.updatePatientInfo(
            userId!,
            _firstNameController.text,
            _lastNameController.text,
            _dateOfBirthController.text,
            _contactNumberController.text,
            token!);

        if (result["success"] == true) {
          print(
              "updated name : ${_firstNameController.text} ${_lastNameController.text}");
          print("Image : $updatedImage");
          print("current Image : $currentImage");
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

          // Show a success message
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Patient information updated successfully"),
            duration: Duration(seconds: 2),
          ));
        } else {
          print("[Error]: ${result["message"]}");

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
        final result = await apiCalls.getPatientInfo(userId!, token!);

        if (result["success"] == true) {
          setState(() {
            isLoading = false;
          });

          setState(() {
            _firstNameController.text = result["message"]["firstName"];
            _lastNameController.text = result["message"]["lastName"];
            _contactNumberController.text = result["message"]["contactNumber"];
            _dateOfBirthController.text = result["message"]["dob"];
            _emailController.text = result["message"]["email"];
          });
          await _fetchUserImage();
        } else {
          print("[Error]: ${result["message"]}");

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
                leading: Icon(
                  Icons.photo_library,
                ),
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
          setState(() {
            updatedImage = imageBase64;
          });
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
  void initState() {
    super.initState();
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
    currentImage = StoreProvider.of<AppState>(context).state.image;
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
      body: SingleChildScrollView(
          child: Column(
        children: [
          // Custom AppBar with rounded bottom corners
          ClipRRect(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            child: AppBar(
              title: Text(
                'PROFILE',
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
                      Icons.menu,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Scaffold.of(context).openDrawer(); // Opens the drawer
                    },
                  );
                },
              ),
              flexibleSpace: Container(
                height: 106, // Adjust this to your desired height
              ),
            ),
          ),
          // Body content
          isLoading
              ? Center(
                  child: Container(
                    color: Colors.white, //.withOpacity(0.5), // Dim background
                    child: const Center(
                      child:
                          CircularProgressIndicator(color: Color(0xFF29A5D6)),
                    ),
                  ),
                )
              : errorMessage != null
                  ? Center(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                          SizedBox(
                            height: 200,
                          ),
                          CustomRetryButton(
                            onPressed: loadInfo,
                            buttonText: "↻ Retry",
                            width: 100,
                          ),
                          Text(
                            "Check your internet connection",
                            style: GoogleFonts.montserrat(color: Colors.red),
                          )
                        ]))
                  : SingleChildScrollView(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundImage: imageBase64 != null &&
                                        imageBase64!.isNotEmpty
                                    ? MemoryImage(base64Decode(imageBase64!))
                                    : AssetImage(
                                            'assets/Images/doctor_avatar.jpg')
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
                                    size: 30,
                                  ),
                                ),
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
                            label: "Contact Number",
                            controller: _contactNumberController,
                            isEditable: isContactNumberEditable,
                            onEditPressed: () {
                              setState(() {
                                isContactNumberEditable = true;
                              });
                              enableUpdateButton();
                            },
                          ),
                          SizedBox(height: 16),
                          _buildEditableField(
                            label: "Date of Birth",
                            controller: _dateOfBirthController,
                            isEditable: isDateOfBirthEditable,
                            onEditPressed: () {
                              setState(() {
                                isDateOfBirthEditable = true;
                              });
                              enableUpdateButton();
                            },
                          ),
                          SizedBox(height: 32),
                          if (isUpdateButtonEnabled)
                            Center(
                              child: CustomButton(
                                onPressed: () {
                                  setState(() {
                                    isFirstNameEditable = false;
                                    isLastNameEditable = false;
                                    isContactNumberEditable = false;
                                    isDateOfBirthEditable = false;
                                    isEmailEditable = false;
                                    isUpdateButtonEnabled = false;
                                  });
                                  updateInfo();
                                },
                                width: 200,
                                buttonText: "Update",
                              ),
                            ),
                        ],
                      ),
                    ),
        ],
      )),
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
                border: OutlineInputBorder(),
                labelStyle: GoogleFonts.montserrat()),
            style: GoogleFonts.montserrat(),
          ),
        ),
        SizedBox(width: 8),
        IconButton(
          icon: Icon(
            Icons.edit,
            color: Color(0xFF29A5D6),
          ),
          onPressed: onEditPressed,
        ),
      ],
    );
  }
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
