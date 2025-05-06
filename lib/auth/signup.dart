import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mycampuspte/Models/user_model.dart';
import 'package:mycampuspte/auth/controller.dart';
import 'package:mycampuspte/auth/login.dart';
import 'package:mycampuspte/utils/theme/theme.dart';
import 'package:mycampuspte/utils/validator.dart';
import 'package:mycampuspte/widgets/mybutton.dart';
import 'package:provider/provider.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool _isPasswordHidden = true;
  bool _isConfPasswordHidden = true;

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _naptuneCode = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _facultyController = TextEditingController();
  final TextEditingController _yearofStudy = TextEditingController();

  bool _isCodeAvailable = false;
  bool _isCheckingCode = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _naptuneCode.addListener(_checkNeptuneCodeAvailability);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _naptuneCode.removeListener(_checkNeptuneCodeAvailability);
    _naptuneCode.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _checkNeptuneCodeAvailability() async {
    final code = _naptuneCode.text.trim();
    if (code.length < 6) {
      setState(() {
        _isCodeAvailable = false;
      });
      return;
    }

    setState(() {
      _isCheckingCode = true;
    });

    final query = await FirebaseFirestore.instance
        .collection('users')
        .where('neptuneCode', isEqualTo: code)
        .get();

    setState(() {
      _isCodeAvailable = query.docs.isEmpty;
      _isCheckingCode = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<MyAuthProvider>(context);
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      // backgroundColor: bgColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.only(top: height * 0.1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor:
                        Theme.of(context).brightness == Brightness.dark
                            ? black
                            : white,
                    radius: (width < 550) ? width * 0.2 : width * 0.3,
                    backgroundImage:
                        AssetImage('assets/images/logodisplay.png'),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Welcome to MyCampusPTE \n SignUp to Continue!",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? white
                          : black,
                      fontWeight: FontWeight.bold,
                      fontSize: (width < 550) ? 12 : 16,
                    ),
                  ),
                  const SizedBox(height: 20),

                  _buildTextField(
                      _firstNameController, "First Name", Icons.person_outline),
                  const SizedBox(height: 20),

                  _buildTextField(
                      _lastNameController, "Last Name", Icons.person_outline),
                  const SizedBox(height: 20),

                  _buildTextField(_emailController, "Email", Icons.email,
                      type: TextInputType.emailAddress),
                  const SizedBox(height: 20),

                  // Neptune Code with availability check
                  TextFormField(
                    controller: _naptuneCode,
                    decoration: InputDecoration(
                      labelText: 'Unique Code',
                      hintText: 'ABC67B',
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.numbers),
                      counterText: '',
                      suffixIcon: _naptuneCode.text.isEmpty
                          ? null
                          : _isCheckingCode
                              ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2),
                                  ),
                                )
                              : Icon(
                                  _isCodeAvailable
                                      ? Icons.check_circle
                                      : Icons.cancel,
                                  color: _isCodeAvailable
                                      ? Colors.green
                                      : Colors.red,
                                ),
                    ),
                    maxLength: 6,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Required field';

                      if (!_isCodeAvailable) return 'Code is not available';
                      return null;
                    },
                  ),
                  if (_naptuneCode.text.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        _isCodeAvailable
                            ? "Code is available"
                            : "Code is already taken",
                        style: TextStyle(
                            color:
                                _isCodeAvailable ? Colors.green : Colors.red),
                      ),
                    ),
                  const SizedBox(height: 20),

                  // Faculty
                  _buildTextField(
                      _facultyController, "Faculty / Programme", Icons.school),
                  const SizedBox(height: 20),

                  //
                  // Year of Study
                  _buildTextField(
                      _yearofStudy,
                      "Year of Study",
                      type: TextInputType.number,
                      Icons.school),
                  const SizedBox(height: 20),
                  // Password
                  _buildPasswordField(
                      _passwordController, "Password", _isPasswordHidden, () {
                    setState(() => _isPasswordHidden = !_isPasswordHidden);
                  }),
                  const SizedBox(height: 20),

                  _buildPasswordField(_confirmPasswordController,
                      "Confirm Password", _isConfPasswordHidden, () {
                    setState(
                        () => _isConfPasswordHidden = !_isConfPasswordHidden);
                  }),
                  const SizedBox(height: 30),

                  authProvider.isLoading
                      ? const CircularProgressIndicator()
                      : Mybutton(
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              _register(authProvider);
                            }
                          },
                          label: Text(
                            "Sign Up",
                            style: GoogleFonts.poppins(
                              color: white,
                              fontSize: (width < 550) ? 12 : 16,
                            ),
                          ),
                        ),

                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      textAlign: TextAlign.center,
                      'Already have an account? Login',
                      style: GoogleFonts.poppins(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? white
                            : black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      {TextInputType type = TextInputType.text}) {
    return TextFormField(
      validator: validateRequiredField,
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        prefixIcon: Icon(icon),
      ),
      keyboardType: type,
    );
  }

  Widget _buildPasswordField(TextEditingController controller, String label,
      bool obscure, VoidCallback toggle) {
    return TextFormField(
      validator: passWordValidator,
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
          onPressed: toggle,
        ),
      ),
    );
  }

  void _register(MyAuthProvider authProvider) async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _showSnackBar('Fields cannot be empty');
      return;
    }

    if (password != confirmPassword) {
      _showSnackBar('Passwords do not match');
      return;
    }

    if (!_isCodeAvailable) {
      _showSnackBar('Unique code is not available');
      return;
    }

    final result = await authProvider.signUp(email, password, context);

    if (result.success) {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final newUser = UserModel(
            firstName: _firstNameController.text.trim(),
            lastName: _lastNameController.text.trim(),
            email: email,
            neptuneCode: _naptuneCode.text.trim(),
            role: "user",
            faculty: _facultyController.text.trim(),
            yearOfStudy: int.tryParse(_yearofStudy.text.trim()) ?? 1);

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set(newUser.toMap());

        _firstNameController.clear();
        _lastNameController.clear();
        _emailController.clear();
        _naptuneCode.clear();
        _passwordController.clear();
        _confirmPasswordController.clear();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      } else {
        _showSnackBar('Failed to retrieve user data.');
      }
    } else {
      _showSnackBar(result.message);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text(
          message,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
