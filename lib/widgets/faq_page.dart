import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mycampuspte/utils/theme/theme.dart';

class FaqPage extends StatefulWidget {
  final String question;
  final String answer;

  const FaqPage({
    super.key,
    required this.question,
    required this.answer,
  });

  @override
  State<FaqPage> createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double width = size.width;
    final double height = size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "FAQ",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(
            horizontal: width * 0.05, vertical: height * 0.03),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.question,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                // color: Colors.black87,
              ),
            ),
            Divider(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : black,
            ),
            SizedBox(height: height * 0.02),
            Text(
              widget.answer,
              style: GoogleFonts.poppins(
                fontSize: 16,
                // color: Colors.black87,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
