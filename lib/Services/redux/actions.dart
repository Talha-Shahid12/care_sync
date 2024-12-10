// actions.dart
import 'package:flutter/material.dart';

class UpdateTokenAction {
  final String token;
  final String id;
  final String userType;
  final String patientId;
  final String doctorId;
  final String firstName;
  final String lastName;
  final String email;

  UpdateTokenAction({
    required this.token,
    required this.id,
    required this.userType,
    required this.patientId,
    required this.doctorId,
    required this.firstName,
    required this.lastName,
    required this.email,
  });
}

class UpdateImage {
  final String image;
  UpdateImage({required this.image});
}

class UpdateFcmToken {
  final String fcmToken;
  UpdateFcmToken({required this.fcmToken});
}
