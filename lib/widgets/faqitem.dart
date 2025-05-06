import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mycampuspte/utils/theme/theme.dart';

class FAQItem extends StatefulWidget {
  final String question;
  final String answer;

  const FAQItem({
    super.key,
    required this.question,
    required this.answer,
  });

  @override
  State<FAQItem> createState() => _FAQItemState();
}

class _FAQItemState extends State<FAQItem> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double width = size.width;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        title: Text(
          widget.question,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: (width < 550) ? 12 : 14,
            // color: black,
          ),
        ),
        trailing: Icon(
          _expanded ? Icons.remove : Icons.add,
          color: buttonColor,
        ),
        onExpansionChanged: (expanded) {
          setState(() {
            _expanded = expanded;
          });
        },
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: 16,
            ),
            child: Text(
              widget.answer,
              style: GoogleFonts.poppins(
                fontSize: (width < 550) ? 10 : 12,
                color: Colors.grey.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
