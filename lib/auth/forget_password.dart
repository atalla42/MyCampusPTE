import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mycampuspte/auth/controller.dart';
import 'package:mycampuspte/utils/theme/theme.dart';
import 'package:mycampuspte/utils/validator.dart';
import 'package:mycampuspte/widgets/mybutton.dart';
import 'package:provider/provider.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<MyAuthProvider>(context);
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      // backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: appBarBackgroundColor,
        iconTheme: IconThemeData(color: white),
        title: Text(
          "Forget Password",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: white,
            fontSize: (width < 550) ? 12 : 16,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: width * 0.05, vertical: height * 0.01),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: height * 0.01),
                child: TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: validateRequiredField,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                    hintText: "Enter email",
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: height * 0.015),
                child: Mybutton(
                  onTap: () async {
                    if (_emailController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: const Color(0xFFA9C46C),
                          content: Text(
                            "Enter Email",
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      );
                      return;
                    }

                    if (_formKey.currentState!.validate()) {
                      await authProvider.resetPassword(
                          _emailController.text.trim(), context);
                    }
                  },
                  label: authProvider.isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          "Forget Password",
                          style: GoogleFonts.poppins(
                            color: white,
                            fontSize: (width < 550) ? 12 : 16,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
