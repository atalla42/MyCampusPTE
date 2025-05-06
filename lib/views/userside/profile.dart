import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mycampuspte/Models/user_model.dart';
import 'package:mycampuspte/utils/theme/theme.dart';
import 'package:provider/provider.dart';
import 'package:mycampuspte/auth/controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  final UserModel user;

  const Profile({super.key, required this.user});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _uniqueCodeController;
  late TextEditingController _facultyController;
  late TextEditingController _yearofStudyController;

  bool isSaving = false;
  final uid = FirebaseAuth.instance.currentUser!.uid;
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  // Future<void> _pickImage() async {
  //   final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

  //   if (pickedFile != null) {
  //     setState(() {
  //       _imageFile = File(pickedFile.path); // Temporarily hold it here
  //     });
  //   }
  // }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final bytes = await file.readAsBytes();
      final base64Image = base64Encode(bytes);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('profile_image', base64Image);

      setState(() {
        _imageFile = file;
      });
    }
  }

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
    super.initState();
    _firstNameController = TextEditingController(text: widget.user.firstName);
    _lastNameController = TextEditingController(text: widget.user.lastName);
    _emailController = TextEditingController(text: widget.user.email);
    _uniqueCodeController =
        TextEditingController(text: widget.user.neptuneCode);
    _yearofStudyController =
        TextEditingController(text: widget.user.yearOfStudy.toString());
    _facultyController = TextEditingController(text: widget.user.faculty);
    _loadSavedImage();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _uniqueCodeController.dispose();
    _yearofStudyController.dispose();
    _facultyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double width = size.width;
    final double height = size.height;

    return Scaffold(
      // backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          'Profile',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: (width < 550) ? 16 : 18,
          ),
        ),
        centerTitle: true,
        // backgroundColor: bgColor,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // elevated

                Padding(
                  padding: EdgeInsets.only(
                      top: height * 0.03, bottom: height * 0.03),
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: (width < 550) ? width * 0.2 : width * 0.3,
                        backgroundColor: Colors.grey[300],
                        backgroundImage:
                            _imageFile != null ? FileImage(_imageFile!) : null,
                        child: _imageFile == null
                            ? Icon(Icons.person, size: 50, color: Colors.white)
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 4,
                        child: GestureDetector(
                          onTap: _pickImage, // your image picking method
                          child: Container(
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child:
                                Icon(Icons.edit, color: Colors.white, size: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                TextField(
                  controller: _firstNameController,
                  decoration: const InputDecoration(
                    labelText: "First Name",
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _lastNameController,
                  decoration: const InputDecoration(
                    labelText: "Last Name",
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _facultyController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.school),
                    labelText: "Faculty / Programme",
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _yearofStudyController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.school),
                    labelText: "Year of Study",
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  enabled: false,
                  controller: _emailController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    labelText: "Email",
                    hintText: widget.user.email,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  enabled: false,
                  controller: _uniqueCodeController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    labelText: "Unique Code",
                    hintText: widget.user.neptuneCode,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isSaving
                        ? null
                        : () async {
                            final authProvider = Provider.of<MyAuthProvider>(
                                context,
                                listen: false);
                            setState(() => isSaving = true);

                            await authProvider.updateProfile(
                              uid: uid,
                              firstName: _firstNameController.text,
                              lastName: _lastNameController.text,
                              yearOfStudy:
                                  int.tryParse(_yearofStudyController.text) ??
                                      1,
                              faculty: _facultyController.text,
                              user: widget.user,
                              context: context,
                            );

                            // if (!success) {
                            //   setState(() => isSaving = false);
                            // }
                            setState(() => isSaving = false);
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor,
                      foregroundColor: Colors.white,
                      elevation: 3,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      textStyle: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    child: isSaving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              color: Colors.white,
                            ),
                          )
                        : const Text("Save"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
