import 'package:shared_preferences/shared_preferences.dart';

class SessionStorage {
  // Keys for SharedPreferences
  static const String userIdKey = 'userId';
  static const String patientIdKey = 'patientId';
  static const String doctorIdKey = 'doctorId';
  static const String userTypeKey = 'userType';
  static const String jwtTokenKey = 'jwtToken';
  static const String firstNameKey = 'firstName';
  static const String lastNameKey = 'lastName';
  static const String emailKey = 'email';
  static const String imageKey = 'image';
  static const String fcmTokenKey = 'fcmToken';
  static const String baseUrlKey = 'baseUrl';
  // Store session data
  static Future<void> storeSessionData({
    required String userId,
    required String patientId,
    required String doctorId,
    required String userType,
    required String jwtToken,
    required String firstName,
    required String lastName,
    required String email,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Store session data
    await prefs.setString(userIdKey, userId);
    await prefs.setString(patientIdKey, patientId);
    await prefs.setString(doctorIdKey, doctorId);
    await prefs.setString(userTypeKey, userType);
    await prefs.setString(jwtTokenKey, jwtToken);
    await prefs.setString(firstNameKey, firstName);
    await prefs.setString(lastNameKey, lastName);
    await prefs.setString(emailKey, email);
  }

  ///////////
  static Future<void> storeFcmToken({required String fcmToken}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Store session data
    await prefs.setString(fcmTokenKey, fcmToken);
  }

  static Future<void> storeImage({required String image}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(imageKey, image);
  }

  static Future<void> storeBaseUrl({required String baseUrl}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(baseUrlKey, baseUrl);
  }

  ///

  // Retrieve session data
  static Future<Map<String, String?>> getSessionData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? userId = prefs.getString(userIdKey);
    String? patientId = prefs.getString(patientIdKey);
    String? doctorId = prefs.getString(doctorIdKey);
    String? userType = prefs.getString(userTypeKey);
    String? jwtToken = prefs.getString(jwtTokenKey);
    String? firstName = prefs.getString(firstNameKey);
    String? lastName = prefs.getString(lastNameKey);
    String? email = prefs.getString(emailKey);
    String? image = prefs.getString(imageKey);
    String? baseUrl = prefs.getString(baseUrlKey);
    return {
      'userId': userId,
      'patientId': patientId,
      'doctorId': doctorId,
      'userType': userType,
      'jwtToken': jwtToken,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'image': image,
      'baseUrl': baseUrl
    };
  }

  /////////////
  // Retrieve session data
  static Future<Map<String, String?>> getFcmToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? fcmToken = prefs.getString(fcmTokenKey);
    return {'fcmToken': fcmToken};
  }

  static Future<Map<String, String?>> getBaseUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? baseUrl = prefs.getString(baseUrlKey);
    return {'baseUrl': baseUrl};
  }

  ///

  // Check if user is logged in (session exists)
  static Future<bool> isUserLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Check if the necessary session data exists
    String? userId = prefs.getString(userIdKey);
    String? jwtToken = prefs.getString(jwtTokenKey);

    return userId != null && jwtToken != null;
  }

  // Clear all session data (on sign-out)
  static Future<void> clearSessionData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Remove the stored session data
    await prefs.remove(userIdKey);
    await prefs.remove(patientIdKey);
    await prefs.remove(doctorIdKey);
    await prefs.remove(userTypeKey);
    await prefs.remove(jwtTokenKey);
    await prefs.remove(firstNameKey);
    await prefs.remove(lastNameKey);
    await prefs.remove(emailKey);
    await prefs.remove(imageKey);
    await prefs.remove(fcmTokenKey);
    await prefs.remove(baseUrlKey);
  }
}
