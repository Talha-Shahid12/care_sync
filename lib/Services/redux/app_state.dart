// app_state.dart
import 'package:flutter/material.dart';

class AppState {
  final String token;
  final String id;
  final String userType;
  final String patientId;
  final String doctorId;
  final String firstName;
  final String lastName;
  final String email;
  final String image;
  final String fcmToken;

  AppState(
      {required this.token,
      required this.id,
      required this.userType,
      required this.patientId,
      required this.doctorId,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.image,
      required this.fcmToken});

  AppState copyWith(
      {String? token,
      String? id,
      String? userType,
      String? patientId,
      String? doctorId,
      String? firstName,
      String? lastName,
      String? email,
      String? image,
      String? fcmToken}) {
    return AppState(
        token: token ?? this.token,
        id: id ?? this.id,
        userType: userType ?? this.userType,
        patientId: patientId ?? this.patientId,
        doctorId: doctorId ?? this.doctorId,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        email: email ?? this.email,
        image: image ?? this.image,
        fcmToken: fcmToken ?? this.fcmToken);
  }

  factory AppState.initial() {
    return AppState(
        token: '',
        id: '',
        userType: '',
        patientId: '',
        doctorId: '',
        firstName: '',
        lastName: '',
        email: '',
        image: '',
        fcmToken: '');
  }
}
