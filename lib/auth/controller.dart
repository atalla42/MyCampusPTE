import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mycampuspte/Models/user_model.dart';
import 'package:mycampuspte/utils/theme/theme.dart';

class AuthResponse {
  final bool success;
  final String message;

  AuthResponse({required this.success, required this.message});
}

class MyAuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;
  bool _isLoading = false;
  bool isSaving = false;
  bool get isLoading => _isLoading;

  // Add this getter for the user model
  Future<UserModel?> get userModel async {
    if (currentUser != null) {
      try {
        final userDoc =
            await _firestore.collection('users').doc(currentUser!.uid).get();

        if (userDoc.exists) {
          return UserModel.fromMap(userDoc.data() as Map<String, dynamic>);
        }
      } catch (e) {
        print("Error getting user model: $e");
      }
    }
    return null; // Return null if no user is logged in
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<UserModel?> getUserByNeptuneCodeOrEmail(String input) async {
    try {
      final neptuneQuery = await _firestore
          .collection('users')
          .where('neptuneCode', isEqualTo: input)
          .get();

      if (neptuneQuery.docs.isNotEmpty) {
        // Convert the document to UserModel
        return UserModel.fromMap(neptuneQuery.docs.first.data());
      }

      if (input.contains('@') && input.contains('.')) {
        final emailQuery = await _firestore
            .collection('users')
            .where('email', isEqualTo: input)
            .get();

        if (emailQuery.docs.isNotEmpty) {
          // Convert the document to UserModel
          return UserModel.fromMap(emailQuery.docs.first.data());
        }
      }

      return null;
    } catch (_) {
      return null;
    }
  }

  Future<AuthResponse> signIn(
      String input, String password, BuildContext context) async {
    _setLoading(true);

    try {
      final userInfo = await getUserByNeptuneCodeOrEmail(input);
      if (userInfo == null) {
        return AuthResponse(
            success: false,
            message: 'Invalid Email or Unique Code. Please try again.');
      }

      // Always sign in, even if user is already logged in
      await _auth.signInWithEmailAndPassword(
        email: userInfo.email,
        password: password,
      );

      return AuthResponse(success: true, message: 'Login successful');
    } on FirebaseAuthException catch (e) {
      return AuthResponse(
          success: false, message: _getAuthErrorMessage(e.code));
    } finally {
      _setLoading(false);
    }
  }

  Future<AuthResponse> signUp(
      String email, String password, BuildContext context) async {
    _setLoading(true);

    try {
      // Always attempt to sign up, even if the user is already registered
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      await _showDialog(
        context,
        title: "Success",
        content: "Sign Up Successfully!",
        isSuccess: true,
      );

      return AuthResponse(success: true, message: 'Sign Up successful');
    } on FirebaseAuthException catch (e) {
      return AuthResponse(
          success: false, message: _getAuthErrorMessage(e.code));
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (_) {
      // Log or handle if needed
    }
  }

  Future<void> resetPassword(String email, BuildContext context) async {
    _setLoading(true);
    try {
      await _auth.sendPasswordResetEmail(email: email);

      await _showDialog(
        context,
        title: "Success",
        content: "Password reset link sent successfully!",
        isSuccess: true,
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Failed to send reset email.')),
      );
    } finally {
      _setLoading(false);
    }
  }

  String _getAuthErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Wrong password.';
      case 'invalid-email':
        return 'The email address is invalid.';
      case 'email-already-in-use':
        return 'The email is already in use.';
      case 'weak-password':
        return 'The password is too weak.';
      default:
        return 'An error occurred. Please try again.';
    }
  }

  Future<void> _showDialog(BuildContext context,
      {required String title,
      required String content,
      bool isSuccess = false}) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        icon: Icon(
          isSuccess ? Icons.check_circle : Icons.error,
          color: isSuccess ? Colors.green : Colors.red,
          size: 40,
        ),
        title: Text(title),
        content: Text(content),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
    await Future.delayed(Duration(seconds: 3));
    Navigator.of(context).pop(); // close dialog
  }

  //

  Future<bool> updateProfile({
    required String uid,
    required String firstName,
    required String lastName,
    required String faculty,
    required int yearOfStudy,
    required UserModel user,
    required BuildContext context,
  }) async {
    isSaving = true;
    notifyListeners();

    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'firstName': firstName.trim(),
        'lastName': lastName.trim(),
        'faculty': faculty.trim(),
        'yearOfStudy': yearOfStudy
      });

      // Update local user model
      user.firstName = firstName.trim();
      user.lastName = lastName.trim();
      user.faculty = faculty.trim();
      user.yearOfStudy = yearOfStudy;

      // Show success dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          backgroundColor: Colors.white,
          icon: const Icon(Icons.check_circle, color: Colors.green, size: 40),
          title: Text(
            "Success",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
                color: Theme.of(context).brightness == Brightness.dark
                    ? black
                    : black),
          ),
          content: Text(
            "Profile updated successfully!",
            style: GoogleFonts.poppins(
                color: Theme.of(context).brightness == Brightness.dark
                    ? black
                    : black),
            textAlign: TextAlign.center,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      );

      await Future.delayed(const Duration(seconds: 2));
      Navigator.of(context).pop(); // Pop dialog
      return true;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Failed to update profile'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return false;
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }
}
