import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mycampuspte/utils/theme/theme.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({super.key});

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _eventDescriptionController =
      TextEditingController();
  DateTime? _selectedDate;

  // Function to pick the event date
  Future<void> _pickDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        // Update the date controller to display the selected date
        _dateController.text = DateFormat('yyyy-MM-dd').format(_selectedDate!);
      });
    }
  }

  // Function to handle Add button click and save event to Firebase
  void _addEvent() async {
    if (_eventNameController.text.isEmpty ||
        _selectedDate == null ||
        _eventDescriptionController.text.isEmpty) {
      // Show an error message if any field is empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all the fields!")),
      );
      return;
    }

    // Create an event object to add to Firestore
    final event = {
      'eventName': _eventNameController.text,
      'eventDate': _selectedDate,
      'eventDescription': _eventDescriptionController.text,
      'timestamp':
          FieldValue.serverTimestamp(), // To track when the event was created
    };

    // Add the event to Firestore
    try {
      await FirebaseFirestore.instance.collection('events').add(event);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Event added successfully!")),
      );

      // Optionally, navigate back or clear the fields
      Navigator.pop(context);
    } catch (e) {
      // Handle any errors that occur during Firestore operations
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error adding event: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double width = size.width;
    final double height = size.height;
    return Scaffold(
      // backgroundColor: bgColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: white),
        title: Text(
          "Add Event",
          style: GoogleFonts.poppins(
              color: white,
              fontWeight: FontWeight.bold,
              fontSize: (width < 550) ? 16 : 18),
        ),
        backgroundColor: appBarBackgroundColor,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Event Name TextField
              TextField(
                controller: _eventNameController,
                decoration: const InputDecoration(
                  labelText: 'Event Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Date Picker TextField
              GestureDetector(
                onTap: _pickDate,
                child: AbsorbPointer(
                  child: TextField(
                    controller: _dateController,
                    decoration: InputDecoration(
                      labelText: 'Event Date',
                      hintText: _selectedDate == null
                          ? 'Select Date'
                          : DateFormat('yyyy-MM-dd').format(_selectedDate!),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Event Description TextField
              TextField(
                controller: _eventDescriptionController,
                decoration: const InputDecoration(
                  labelText: 'Event Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),

              // Add Event Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _addEvent,
                  child: Text(
                    'Add Event',
                    style: GoogleFonts.poppins(
                        color: white, fontSize: (width < 550) ? 12 : 14),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
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
