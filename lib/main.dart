import 'package:care_sync/Screens/HomeScreen.dart';
import 'package:care_sync/Screens/PatientSide/SignInScreen/signIn.dart';
import 'package:care_sync/Services/NotificationService.dart';
import 'package:care_sync/Services/localStorageService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:care_sync/Services/redux/store.dart';
import 'package:care_sync/Services/redux/app_state.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseNotificationService().initialize();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        title: 'Care Sync',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Color(0xFF29A5D6), //Color(0xFF29A5D6)
          scaffoldBackgroundColor: Colors.black,
        ),
        home: _getInitialScreen(),
      ),
    );
  }

  Widget _getInitialScreen() {
    return FutureBuilder<Map<String, String?>>(
      future: SessionStorage.getSessionData(),
      builder:
          (BuildContext context, AsyncSnapshot<Map<String, String?>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show loading indicator while checking login status
          return Center(
              child: CircularProgressIndicator(color: Color(0xFF29A5D6)));
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error checking login status.'));
        }

        if (snapshot.hasData) {
          Map<String, String?> sessionData = snapshot.data!;
          String? userType = sessionData['userType'];
          if (userType != null) {
            return HomeScreen(userType: userType);
          } else {
            return SignInPage();
          }
        } else {
          return SignInPage();
        }
      },
    );
  }
}
