import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
// import 'dart:math';
import 'package:care_sync/Services/localStorageService.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';

class ApiCalls {
  String? baseUrl;
  ApiCalls() {
    _initializeBaseUrl();
  }

  /// Initialize the base URL from local storage
  Future<void> _initializeBaseUrl() async {
    Map<String, String?> sessionData = await SessionStorage.getBaseUrl();
    String gotbaseUrl = sessionData['baseUrl'] ?? "";
    baseUrl = '$gotbaseUrl/api';
  }

  Future<void> _ensureBaseUrl() async {
    if (baseUrl == null) {
      await _initializeBaseUrl();
    }
  }

  /// Login API call
  Future<Map<String, dynamic>> login(String email, String password) async {
    await _ensureBaseUrl(); // Ensure baseUrl is loaded

    log("[BaseUrl] : ${baseUrl}");
    final String url = "$baseUrl/auth/login";
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"Email": email, "Password": password}),
      );

      if (response.statusCode == 200) {
        print("respone : ${jsonDecode(response.body)}");

        return jsonDecode(response.body);
      } else {
        final responseBody = jsonDecode(response.body);

        return {
          "success": false,
          "message": "Login failed: ${responseBody["message"]}"
        };
      }
    } catch (error) {
      return {"success": false, "message": "Error occurred: $error"};
    }
  }

  /// Register API call
  Future<Map<String, dynamic>> register(String firstName, String lastName,
      String userType, String email, String password) async {
    await _ensureBaseUrl();
    log("[BaseUrl] : ${baseUrl}");

    final String url = "$baseUrl/auth/register";
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "FirstName": firstName,
          "LastName": lastName,
          "UserType": userType,
          "Email": email,
          "Password": password,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("respone : ${jsonDecode(response.body)}");
        return jsonDecode(response.body);
      } else {
        final responseBody = jsonDecode(response.body);

        return {"success": false, "message": "${responseBody["message"]}"};
      }
    } catch (error) {
      return {"success": false, "message": "Error occurred: $error"};
    }
  }

  /// add Doctor API call
  Future<Map<String, dynamic>> addDoctor(
      String specialization,
      String hospitalName,
      String consultationFee,
      List<Map<String, String>> freeHours,
      String token,
      String userId) async {
    await _ensureBaseUrl();
    log("[BaseUrl] : ${baseUrl}");

    final String url = "$baseUrl/doctor/add";
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          'Authorization': "Bearer ${token}"
        },
        body: jsonEncode({
          "Specialization": specialization,
          "HospitalName": hospitalName,
          "ConsultationFee": consultationFee,
          "FreeHours": freeHours,
          "UserId": userId
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("respone : ${jsonDecode(response.body)}");
        return jsonDecode(response.body);
      } else {
        final responseBody = jsonDecode(response.body);

        return {"success": false, "message": "${responseBody["message"]}"};
      }
    } catch (error) {
      return {"success": false, "message": "Error occurred: $error"};
    }
  }

  /// add Patient API call
  Future<Map<String, dynamic>> addPatient(
      String Dob, String contactNumber, String token, String userId) async {
    await _ensureBaseUrl();
    log("[BaseUrl] : ${baseUrl}");

    final String url = "$baseUrl/patient/add";
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          'Authorization': "Bearer ${token}"
        },
        body: jsonEncode(
            {"Dob": Dob, "ContactNumber": contactNumber, "UserId": userId}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("respone : ${jsonDecode(response.body)}");
        return jsonDecode(response.body);
      } else {
        final responseBody = jsonDecode(response.body);

        return {"success": false, "message": "${responseBody["message"]}"};
      }
    } catch (error) {
      return {"success": false, "message": "Error occurred: $error"};
    }
  }

  /// get Doctors API call
  Future<Map<String, dynamic>> getDoctors(String token) async {
    await _ensureBaseUrl();
    log("[BaseUrl] : ${baseUrl}");

    final String url = "$baseUrl/doctor/get-doctors";
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          'Authorization': "Bearer ${token}"
        },
      );

      if (response.statusCode == 200) {
        print("respone : ${jsonDecode(response.body)}");
        return jsonDecode(response.body);
      } else {
        final responseBody = jsonDecode(response.body);

        return {"success": false, "message": "${responseBody["message"]}"};
      }
    } catch (error) {
      return {"success": false, "message": "Error occurred: $error"};
    }
  }

  /// create appointment API call
  Future<Map<String, dynamic>> createAppointment(
      String appointmentDate,
      String appointmentTime,
      String status,
      String patientId,
      String doctorId,
      String token) async {
    await _ensureBaseUrl();
    log("[BaseUrl] : ${baseUrl}");

    print("appointment date: $appointmentDate");
    print("appointment time: $appointmentTime");
    print("status: $status");
    print("patient id: $patientId");
    print("doctor id: $doctorId");
    print("token: $token");
    final String url = "$baseUrl/appointment/add";
    try {
      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode({
          "AppointmentDate": appointmentDate,
          "AppointmentTime": appointmentTime,
          "Status": status,
          "PatientId": patientId,
          "DoctorId": doctorId
        }),
        headers: {
          "Content-Type": "application/json",
          'Authorization': "Bearer ${token}"
        },
      );

      if (response.statusCode == 200) {
        print("respone : ${jsonDecode(response.body)}");
        return jsonDecode(response.body);
      } else {
        final responseBody = jsonDecode(response.body);

        return {"success": false, "message": "${responseBody["message"]}"};
      }
    } catch (error) {
      return {"success": false, "message": "Error occurred: $error"};
    }
  }

  /// get appointments API call
  Future<Map<String, dynamic>> getAppointment(
      String patientId, String token) async {
    await _ensureBaseUrl();
    log("[BaseUrl] : ${baseUrl}");

    print("Show all available apointments api called");

    final String url =
        "$baseUrl/appointment/get-appointments?patientId=$patientId";
    print("PatientId  : $patientId");
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': "Bearer ${token}"},
      );

      if (response.statusCode == 200) {
        print("respone : ${jsonDecode(response.body)}");
        return jsonDecode(response.body);
      } else {
        final responseBody = jsonDecode(response.body);
        return {"success": false, "message": "${responseBody["message"]}"};
      }
    } catch (error) {
      return {"success": false, "message": "Error occurred: $error"};
    }
  }

  /// get appointments API call
  Future<Map<String, dynamic>> getPatientInfo(
      String userId, String token) async {
    await _ensureBaseUrl();
    log("[BaseUrl] : ${baseUrl}");

    final String url = "$baseUrl/auth/get-patient-info?userId=$userId";
    print("UserId  : $userId");
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': "Bearer ${token}"},
      );

      if (response.statusCode == 200) {
        print("respone : ${jsonDecode(response.body)}");
        return jsonDecode(response.body);
      } else {
        final responseBody = jsonDecode(response.body);
        return {"success": false, "message": "${responseBody["message"]}"};
      }
    } catch (error) {
      return {"success": false, "message": "Error occurred: $error"};
    }
  }

  /// get appointments API call
  Future<Map<String, dynamic>> getDoctorInfo(
      String userId, String token) async {
    await _ensureBaseUrl();
    log("[BaseUrl] : ${baseUrl}");

    final String url = "$baseUrl/auth/get-doctor-info?userId=$userId";
    print("UserId  : $userId");
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': "Bearer ${token}"},
      );

      if (response.statusCode == 200) {
        print("respone : ${jsonDecode(response.body)}");
        return jsonDecode(response.body);
      } else {
        final responseBody = jsonDecode(response.body);
        return {"success": false, "message": "${responseBody["message"]}"};
      }
    } catch (error) {
      return {"success": false, "message": "Error occurred: $error"};
    }
  }

  /// update info patient API call
  Future<Map<String, dynamic>> updatePatientInfo(
      String UserId,
      String FirstName,
      String LastName,
      String Dob,
      String ContactNumber,
      String token) async {
    await _ensureBaseUrl();
    log("[BaseUrl] : ${baseUrl}");

    final String url = "$baseUrl/auth/update-patient-info";
    print("UserId  : $UserId");
    try {
      final response = await http.put(Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': "Bearer ${token}"
          },
          body: jsonEncode({
            "UserId": UserId,
            "FirstName": FirstName,
            "LastName": LastName,
            "Dob": Dob,
            "ContactNumber": ContactNumber
          }));

      if (response.statusCode == 200) {
        print("respone : ${jsonDecode(response.body)}");
        return jsonDecode(response.body);
      } else {
        final responseBody = jsonDecode(response.body);
        return {"success": false, "message": "${responseBody["message"]}"};
      }
    } catch (error) {
      return {"success": false, "message": "Error occurred: $error"};
    }
  }

  /// get appointments API call
  Future<Map<String, dynamic>> getAppointmentsForDoctor(
      String doctorId, String token) async {
    await _ensureBaseUrl();
    log("[BaseUrl] : ${baseUrl}");

    print("Show all available apointments api called");

    final String url =
        "$baseUrl/appointment/get-appointments-for-doctor?doctorId=$doctorId";
    print("Doctor Id  : $doctorId");
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': "Bearer ${token}"},
      );

      if (response.statusCode == 200) {
        print("respone : ${jsonDecode(response.body)}");
        return jsonDecode(response.body);
      } else {
        final responseBody = jsonDecode(response.body);
        return {"success": false, "message": "${responseBody["message"]}"};
      }
    } catch (error) {
      return {"success": false, "message": "Error occurred: $error"};
    }
  }

  /// get appointments history API call
  Future<Map<String, dynamic>> getAppointmentsHistoryForDoctor(
      String doctorId, String token) async {
    await _ensureBaseUrl();
    log("[BaseUrl] : ${baseUrl}");

    final String url =
        "$baseUrl/appointment/get-all-appointments-for-doctor?doctorId=$doctorId";
    print("Doctor Id  : $doctorId");
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': "Bearer ${token}"},
      );

      if (response.statusCode == 200) {
        print("respone : ${jsonDecode(response.body)}");
        return jsonDecode(response.body);
      } else {
        final responseBody = jsonDecode(response.body);
        return {"success": false, "message": "${responseBody["message"]}"};
      }
    } catch (error) {
      return {"success": false, "message": "Error occurred: $error"};
    }
  }

  /// add Patient API call
  Future<Map<String, dynamic>> addMedicalHistory(
      String diagnosis,
      String prescription,
      String token,
      String patientId,
      String appointmentId) async {
    await _ensureBaseUrl();
    log("[BaseUrl] : ${baseUrl}");

    final String url = "$baseUrl/medicalHistory/add";
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          'Authorization': "Bearer ${token}"
        },
        body: jsonEncode({
          "Diagnosis": diagnosis,
          "Prescription": prescription,
          "PatientId": patientId,
          "AppointmentId": appointmentId
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("respone : ${jsonDecode(response.body)}");
        return jsonDecode(response.body);
      } else {
        final responseBody = jsonDecode(response.body);

        return {"success": false, "message": "${responseBody["message"]}"};
      }
    } catch (error) {
      return {"success": false, "message": "Error occurred: $error"};
    }
  }

  /// update info patient API call
  Future<Map<String, dynamic>> updateDoctorInfo(
      String UserId,
      String FirstName,
      String LastName,
      String Specialization,
      String HospitalName,
      String? ConsultationFee,
      List<Map<String, String>> freeHours,
      String token) async {
    await _ensureBaseUrl();
    log("[BaseUrl] : ${baseUrl}");

    final String url = "$baseUrl/auth/update-doctor-info";
    print("UserId  : $UserId");
    try {
      final response = await http.put(Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': "Bearer ${token}"
          },
          body: jsonEncode({
            "UserId": UserId,
            "FirstName": FirstName,
            "LastName": LastName,
            "Specialization": Specialization,
            "HospitalName": HospitalName,
            "ConsultationFee": ConsultationFee,
            "FreeHours": freeHours
          }));

      if (response.statusCode == 200) {
        print("respone : ${jsonDecode(response.body)}");
        return jsonDecode(response.body);
      } else {
        final responseBody = jsonDecode(response.body);
        return {"success": false, "message": "${responseBody["message"]}"};
      }
    } catch (error) {
      return {"success": false, "message": "Error occurred: $error"};
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

  Future<Map<String, dynamic>> uploadImage(
      String userId, File imageFile, String token) async {
    await _ensureBaseUrl();
    log("[BaseUrl] : ${baseUrl}");

    try {
      final base64Image = await encodeImageToBase64(imageFile);
      if (base64Image.isEmpty) {
        throw Exception('Image encoding failed');
      }
      final requestBody = jsonEncode({
        'UserId': userId,
        'Base64Image': base64Image,
      });

      print("Image : $base64Image");
      final uri = Uri.parse('$baseUrl/images/upload-image');

      final response = await http.post(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: requestBody,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print("object : $response");
        throw Exception(
            'Failed to upload image. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print("Error: $error");
      throw Exception('Error occurred during the upload process: $error');
    }
  }

  Future<Map<String, dynamic>> getImageByUserId(
      String userId, String token) async {
    await _ensureBaseUrl();
    log("[BaseUrl] : ${baseUrl}");

    final Uri url = Uri.parse(
        '$baseUrl/images/get-image/$userId'); // API endpoint for getting the image

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization':
              'Bearer $token', // Pass the authorization token in headers
          'Content-Type': 'application/json', // Set the content type to JSON
        },
      );

      if (response.statusCode == 200) {
        // If the server returns a successful response (status 200), decode the JSON response
        return jsonDecode(response.body);
      } else {
        // If the server returns an error, throw an exception
        throw Exception(
            'Failed to load image. Status code: ${response.statusCode}');
      }
    } catch (error) {
      // Handle errors (e.g., network issues)
      throw Exception('Error fetching image: $error');
    }
  }

  /// update info patient API call
  Future<Map<String, dynamic>> updateFcmToken(
      String UserId, String fcmToken, String token) async {
    await _ensureBaseUrl();
    log("[BaseUrl] : ${baseUrl}");

    final String url = "$baseUrl/auth/update-fcm-token";
    print("UserId  : $UserId");
    try {
      final response = await http.post(Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': "Bearer ${token}"
          },
          body: jsonEncode({
            "UserId": UserId,
            "FcmToken": fcmToken,
          }));

      if (response.statusCode == 200) {
        print("respone : ${jsonDecode(response.body)}");
        return jsonDecode(response.body);
      } else {
        final responseBody = jsonDecode(response.body);
        return {"success": false, "message": "${responseBody["message"]}"};
      }
    } catch (error) {
      return {"success": false, "message": "Error occurred: $error"};
    }
  }
}
