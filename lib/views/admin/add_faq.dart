import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mycampuspte/utils/theme/theme.dart';
import 'package:mycampuspte/utils/validator.dart';
import 'package:mycampuspte/widgets/mybutton.dart';

class AddFaq extends StatefulWidget {
  const AddFaq({super.key});

  @override
  State<AddFaq> createState() => _AddFaqState();
}

class _AddFaqState extends State<AddFaq> {
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _answerController = TextEditingController();

  bool _isLoading = false;
  final _formkey = GlobalKey<FormState>();

  Future<void> _addFaq() async {
    final question = _questionController.text.trim();
    final answer = _answerController.text.trim();

    if (question.isEmpty || answer.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill both question and answer')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseFirestore.instance.collection('faqs').add({
        'question': question,
        'answer': answer,
        'timestamp': FieldValue.serverTimestamp(),
      });

      _questionController.clear();
      _answerController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('FAQ added successfully')),
      );
    } catch (e) {
      print('Error adding FAQ: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add FAQ')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double width = size.width;
    return Scaffold(
      // backgroundColor: bgColor,
      appBar: AppBar(
          backgroundColor: appBarBackgroundColor,
          centerTitle: true,
          iconTheme: IconThemeData(color: white),
          title: Text(
            'Add FAQ',
            style: GoogleFonts.poppins(
                color: white, fontSize: (width < 550) ? 14 : 16),
          )),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formkey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _questionController,
                  validator: validateRequiredField,
                  decoration: InputDecoration(
                    labelText: 'FAQ Question',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _answerController,
                  validator: validateRequiredField,
                  maxLines: 10,
                  decoration: InputDecoration(
                    labelText: 'FAQ Answer',
                    alignLabelWithHint: true, // This moves the label to the top
                    contentPadding: EdgeInsets.fromLTRB(
                        12, 12, 12, 12), // Adjust padding as needed
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                _isLoading
                    ? CircularProgressIndicator()
                    : Mybutton(
                        onTap: () {
                          if (_formkey.currentState!.validate()) {
                            _addFaq();
                          }
                        },
                        label: Text(
                          "Add",
                          style: GoogleFonts.poppins(
                            color: white,
                          ),
                        ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
