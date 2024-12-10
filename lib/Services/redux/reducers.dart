// reducers.dart
import 'app_state.dart';
import 'actions.dart';

AppState appReducer(AppState state, dynamic action) {
  if (action is UpdateTokenAction) {
    return state.copyWith(
      token: action.token,
      id: action.id,
      userType: action.userType,
      patientId: action.patientId,
      doctorId: action.doctorId,
      firstName: action.firstName,
      lastName: action.lastName,
      email: action.email,
    );
  }
  if (action is UpdateFcmToken) {
    return state.copyWith(fcmToken: action.fcmToken);
  }
  if (action is UpdateImage) {
    return state.copyWith(image: action.image);
  }
  return state;
}
