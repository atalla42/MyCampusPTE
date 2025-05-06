import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mycampuspte/Models/user_model.dart';
import 'package:mycampuspte/auth/controller.dart';
import 'package:mycampuspte/auth/login.dart';
import 'package:mycampuspte/utils/theme/theme.dart';
import 'package:mycampuspte/views/userside/contactus.dart';
import 'package:mycampuspte/views/userside/faq.dart';
import 'package:mycampuspte/views/userside/profile.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfile extends StatefulWidget {
  // final UserModel user;
  const UserProfile({
    super.key,
  });

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  File? _imageFile;
  UserModel? user;
  bool isLoadingUser = true;

  Future<void> _loadSavedImage() async {
    final prefs = await SharedPreferences.getInstance();
    final base64Image = prefs.getString('profile_image');

    if (base64Image != null) {
      final bytes = base64Decode(base64Image);
      final tempDir = Directory.systemTemp;
      final file =
          await File('${tempDir.path}/profile_image.png').writeAsBytes(bytes);

      setState(() {
        _imageFile = file;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadSavedImage();
    Future.microtask(
      () {
        fetchUserModel();
      },
    );
  }

  void fetchUserModel() async {
    final authProvider = Provider.of<MyAuthProvider>(context, listen: false);
    final fetchedUser = await authProvider.userModel;
    setState(() {
      user = fetchedUser;
      isLoadingUser = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double width = size.width;
    final double height = size.height;
    if (isLoadingUser) {
      return const Scaffold(
        body: Center(
            child: CircularProgressIndicator(
          color: white,
        )),
      );
    }
    return Scaffold(
      // appBar: AppBar(
      //   centerTitle: true,
      //   title: Text(
      //     "Profile",
      //     style: GoogleFonts.poppins(
      //       color: white,
      //       fontSize: (width < 550) ? 16 : 18,
      //     ),
      //   ),
      //   backgroundColor: appBarBackgroundColor,
      // ),
      // backgroundColor: bgColor,
      body: SingleChildScrollView(
        // physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        child: Column(children: [
          // User Avatar
          Container(
            width: width,
            height: height / 3,
            decoration: BoxDecoration(
                color: buttonColor,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //
                // CircleAvatar(
                //   backgroundColor: white,
                //   radius: 50,
                //   child: Icon(
                //     Icons.person,
                //     color: black,
                //     size: 40,
                //   ),
                // ),
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[300],
                  backgroundImage:
                      _imageFile != null ? FileImage(_imageFile!) : null,
                  child: _imageFile == null
                      ? Icon(Icons.person, color: Colors.black, size: 40)
                      : null,
                ),

                Padding(
                  padding: EdgeInsets.only(top: height * 0.01),
                  child: Text(
                    "${user!.firstName} ${user!.lastName}",
                    style: GoogleFonts.poppins(
                        color: white, fontWeight: FontWeight.bold),
                  ),
                ),
                // text
                Padding(
                  padding: EdgeInsets.symmetric(vertical: height * 0.01),
                  child: Text(
                    user!.email,
                    style: GoogleFonts.poppins(color: white),
                  ),
                )
              ],
            ),
          ),

          //
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: height * 0.01, horizontal: width * 0.05),
            child: Padding(
              padding: EdgeInsets.only(top: height * 0.01),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Profile(user: user!),
                        ));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    'Edit Profile',
                    style: GoogleFonts.poppins(
                        color: white, fontSize: (width < 550) ? 12 : 14),
                  ),
                ),
              ),
            ),
          ),

          // Contact Us
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: height * 0.01, horizontal: width * 0.05),
            child: Padding(
              padding: EdgeInsets.only(top: height * 0.01),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Contactus()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    'Contact Us',
                    style: GoogleFonts.poppins(
                        color: white, fontSize: (width < 550) ? 12 : 14),
                  ),
                ),
              ),
            ),
          ),

          //
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: height * 0.01, horizontal: width * 0.05),
            child: Padding(
              padding: EdgeInsets.only(top: height * 0.01),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Faq()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    'Immigration FAQs',
                    style: GoogleFonts.poppins(
                        color: white, fontSize: (width < 550) ? 12 : 14),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: height * 0.02, horizontal: width * 0.05),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  // Get.offAll(() => LoginScreen());
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const LoginScreen()), // Replace with your LoginPage widget
                    (Route<dynamic> route) =>
                        false, // This will remove all the routes from the stack
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  'LogOut',
                  style: GoogleFonts.poppins(
                      color: white, fontSize: (width < 550) ? 12 : 14),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
