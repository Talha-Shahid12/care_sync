import 'dart:convert';

import 'package:care_sync/Screens/MenuDrawerScreens/aboutUs.dart';
import 'package:care_sync/Screens/MenuDrawerScreens/helpSupportScreen.dart';
import 'package:care_sync/Screens/MenuDrawerScreens/privacyPolicy.dart';
import 'package:care_sync/Services/ApiCalls.dart';
import 'package:care_sync/Services/redux/app_state.dart';
import 'package:care_sync/ngrokUrlSetupScreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:care_sync/Services/localStorageService.dart';
import 'package:care_sync/Screens/PatientSide/SignInScreen/signIn.dart';

class CustomDrawer extends StatelessWidget {
  final apiCalls = ApiCalls();
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(25),
        bottomRight: Radius.circular(25),
      ),
      child: Drawer(
        child: StoreConnector<AppState, AppState>(
          converter: (store) => store.state,
          builder: (context, appState) {
            return Column(
              children: [
                // Drawer Header
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Color(0xFF29A5D6),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                            foregroundColor: Color(0xFF29A5D6),
                            radius: 30,
                            backgroundColor: Color(0xFF29A5D6),
                            backgroundImage: appState.image != null &&
                                    appState.image!.isNotEmpty
                                ? MemoryImage(base64Decode(appState.image!))
                                : AssetImage(
                                    'assets/Images/doctor_avatar.jpg')),
                        SizedBox(height: 10),
                        Text(
                          '${appState.firstName} ${appState.lastName}',
                          style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 5),
                        Flexible(
                          child: Text(
                            appState.email,
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Drawer Items
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      _buildDrawerItem(
                        context,
                        icon: Icons.privacy_tip,
                        title: 'Privacy Policy',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PrivacyPolicyScreen(),
                            ),
                          );
                        },
                      ),
                      _buildDrawerItem(
                        context,
                        icon: Icons.settings,
                        title: 'Settings',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NgrokScreen(),
                            ),
                          );
                        },
                      ),
                      _buildDrawerItem(
                        context,
                        icon: Icons.help_center,
                        title: 'Help & Support',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HelpSupportScreen(),
                            ),
                          );
                        },
                      ),
                      _buildDrawerItem(
                        context,
                        icon: Icons.info,
                        title: 'About Us',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AboutUsScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                // Logout Button
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final res = await apiCalls.updateFcmToken(
                          appState.id, "", appState.token);
                      if (res["success"] == true) {
                        await SessionStorage.clearSessionData();
                        Navigator.pop(context);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => SignInPage()),
                        );
                      } else {
                        print("[Error : 1] ${res["message"]}");
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(res["message"] ?? 'Logout failed')),
                        );
                      }
                    },
                    icon: Icon(Icons.logout, color: Colors.white),
                    label: Text(
                      'Logout',
                      style: GoogleFonts.montserrat(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF29A5D6),
                      minimumSize: Size(double.infinity, 50),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context,
      {required IconData icon,
      required String title,
      required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Color(0xFF29A5D6)),
      title: Text(
        title,
        style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
      ),
      onTap: onTap,
    );
  }
}
