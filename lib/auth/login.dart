import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mycampuspte/auth/controller.dart';
import 'package:mycampuspte/auth/forget_password.dart';
import 'package:mycampuspte/auth/signup.dart';
import 'package:mycampuspte/utils/theme/theme.dart';
import 'package:mycampuspte/utils/validator.dart';
import 'package:mycampuspte/views/admin/admin_tabbar.dart';
import 'package:mycampuspte/views/tabbar.dart';
import 'package:mycampuspte/widgets/mybutton.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isPasswordHidden = true;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<MyAuthProvider>(context);
    var size = MediaQuery.of(context).size;
    final double width = size.width;
    final double height = size.height;

    return Scaffold(
      // backgroundColor: bgColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.only(top: height * 0.1),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // App Logo
                Padding(
                  padding: EdgeInsets.only(bottom: height * 0.02),
                  child: CircleAvatar(
                    // backgroundColor: bgColor,
                    backgroundColor:
                        Theme.of(context).brightness == Brightness.dark
                            ? black
                            : white,
                    radius: (width < 550) ? width * 0.2 : width * 0.3,
                    backgroundImage:
                        const AssetImage('assets/images/logodisplay.png'),
                  ),
                ),

                // Welcome Text
                Padding(
                  padding: EdgeInsets.only(bottom: height * 0.02),
                  child: Text(
                    textAlign: TextAlign.center,
                    "Welcome to MyCampusPTE \n Login To Continue!",
                    style: GoogleFonts.poppins(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? white
                          : black,
                      fontWeight: FontWeight.bold,
                      fontSize: (width < 550) ? 12 : 16,
                    ),
                  ),
                ),

                // Email
                TextFormField(
                  validator: validateRequiredField,
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),

                // Password
                TextFormField(
                  validator: validateRequiredField,
                  controller: _passwordController,
                  obscureText: _isPasswordHidden,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(_isPasswordHidden
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          _isPasswordHidden = !_isPasswordHidden;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Login button
                authProvider.isLoading
                    ? const CircularProgressIndicator()
                    : Mybutton(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            _login(context, authProvider);
                          }
                        },
                        label: Text(
                          "Login",
                          style: GoogleFonts.poppins(
                            color: white,
                            fontSize: (width < 550) ? 12 : 16,
                          ),
                        ),
                      ),

                const SizedBox(height: 20),

                // Sign up and forgot password
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SignUp()),
                    );
                  },
                  child: Text(
                    textAlign: TextAlign.center,
                    "Don't have an account? Register",
                    style: GoogleFonts.poppins(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? white
                            : black,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ForgetPassword()),
                    );
                  },
                  child: Text(
                    "Forgot password?",
                    style: GoogleFonts.poppins(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? white
                            : black,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _login(BuildContext context, MyAuthProvider authProvider) async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnackBar(context, "Please enter both email and password");
      return;
    }

    final result = await authProvider.signIn(email, password, context);
    print(result);

    if (result.success) {
      // final user = FirebaseAuth.instance.currentUser!;
      final userModel = await authProvider.userModel;

      if (
          // user.email == "adminatmycampus26@gmail.com"
          userModel != null && userModel.role == 'admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AdminTabbar()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const Tabbar()),
        );
      }
    } else {
      _showSnackBar(context, result.message ?? "Login failed");
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text(
          message,
          style: GoogleFonts.poppins(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
