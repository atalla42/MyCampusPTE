import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mycampuspte/utils/theme/theme.dart';

class MailDetailPage extends StatelessWidget {
  final String name;
  final String email;
  final String message;
  final String mailId;
  final Timestamp timestamp;

  const MailDetailPage({
    super.key,
    required this.name,
    required this.email,
    required this.message,
    required this.mailId,
    required this.timestamp,
  });

  // Delete Mail
  Future<void> deleteMail(String mailId) async {
    try {
      await FirebaseFirestore.instance
          .collection('contact_messages')
          .doc(mailId)
          .delete();
      print("Mail deleted");
    } catch (e) {
      print("Error deleting mail: $e");
    }
  }

  Future<void> showDeleteConfirmationDialog(
      BuildContext context, String mailId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Mail'),
        content: Text('Are you sure you want to delete this mail?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'Cancel',
              style: TextStyle(color: black),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: Text(
              'Delete',
              style: TextStyle(color: white),
            ),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await deleteMail(mailId);
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Mail deleted')),
      );
    }
  }

  // format time
  String _formatDate(Timestamp timestamp) {
    final dateTime = timestamp.toDate();
    return "${dateTime.day}/${dateTime.month}/${dateTime.year}";
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double width = size.width;
    final double height = size.height;
    return Scaffold(
      // backgroundColor: bgColor,
      appBar: AppBar(
        // backgroundColor: white,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: IconButton(
                onPressed: () {
                  showDeleteConfirmationDialog(context, mailId);
                },
                icon: Icon(Icons.delete)),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: width * 0.05, vertical: height * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Name: $name",
                style: GoogleFonts.poppins(
                    // color: black,
                    fontWeight: FontWeight.bold,
                    fontSize: (width < 550) ? 16 : 18)),
            SizedBox(height: 8),
            Text("Email: $email",
                style: GoogleFonts.poppins(
                    // color: black,
                    fontWeight: FontWeight.w400,
                    fontSize: (width < 550) ? 14 : 16)),
            Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("message",
                    style: GoogleFonts.poppins(
                        // color: black,
                        fontWeight: FontWeight.bold,
                        fontSize: (width < 550) ? 12 : 14)),

                //
                Text(_formatDate(timestamp),
                    style: GoogleFonts.poppins(
                        // color: black,
                        fontWeight: FontWeight.bold,
                        fontSize: (width < 550) ? 12 : 14)),
              ],
            ),
            Text(message, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
