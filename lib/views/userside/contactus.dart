import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mycampuspte/utils/theme/theme.dart';
import 'package:mycampuspte/widgets/mybutton.dart';

class Contactus extends StatefulWidget {
  const Contactus({super.key});

  @override
  State<Contactus> createState() => _ContactusState();
}

class _ContactusState extends State<Contactus> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submitContactForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        setState(() {
          _isLoading = true;
        });

        final contactData = {
          'name': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'message': _messageController.text.trim(),
          'timestamp': FieldValue.serverTimestamp(),
          'status': 'new',
          'isRead': false,
        };

        await _firestore.collection('contact_messages').add(contactData);

        _nameController.clear();
        _emailController.clear();
        _messageController.clear();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text("Your message has been sent. We'll get back to you soon!"),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text("Could not send your message. Please try again later."),
            backgroundColor: Colors.red,
          ),
        );
        print('Error submitting contact form: $e');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  bool isEmailValid(String email) {
    final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
    return emailRegex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double width = size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Contact Us',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: (width < 550) ? 16 : 18,
          ),
        ),
        centerTitle: true,
        // backgroundColor: bgColor,
      ),
      // backgroundColor: bgColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Get in Touch',
                style: GoogleFonts.poppins(
                  fontSize: (width < 550) ? 14 : 16,
                  fontWeight: FontWeight.bold,
                  color: black,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Have a question or need help? Send us a message and we\'ll get back to you as soon as possible.',
                style: GoogleFonts.poppins(
                  fontSize: (width < 550) ? 12 : 14,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 30),

              // Name Field
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: const Icon(Icons.person),
                ),
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Please enter your name'
                    : null,
              ),
              const SizedBox(height: 20),

              // Email Field
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: const Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Please enter your email';
                  if (!isEmailValid(value))
                    return 'Please enter a valid email address';
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Message Field
              TextFormField(
                controller: _messageController,
                decoration: InputDecoration(
                  labelText: 'Message',
                  hintText: 'Type your message here...',
                  alignLabelWithHint: true, // This moves the label to the top
                  contentPadding: EdgeInsets.fromLTRB(
                      12, 24, 12, 12), // Adjust padding as needed
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your message';
                  }
                  if (value.length < 10) {
                    return 'Message should be at least 10 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),

              // Submit Button
              Center(
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : Mybutton(
                        onTap: _submitContactForm,
                        label: Text(
                          "Submit",
                          style: GoogleFonts.poppins(color: white),
                        ),
                      ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
