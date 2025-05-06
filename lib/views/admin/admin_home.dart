import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mycampuspte/providers/events_provider.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:mycampuspte/utils/theme/theme.dart';
import 'package:mycampuspte/views/admin/add_event.dart';
import 'package:mycampuspte/views/admin/detailed_event_screen.dart';

class AdminHome extends StatefulWidget {
  final ScrollController scrollController;
  const AdminHome({super.key, required this.scrollController});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      final provider = context.read<EventsProvider>();
      provider.updateSearchQuery(_searchController.text);
    });
  }

  void _deleteEvent(String eventId, BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection('events')
          .doc(eventId)
          .delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Event deleted successfully.'),
            backgroundColor: Colors.red),
      );
    } catch (e) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //       content: Text('Failed to delete event: $e'),
      //       backgroundColor: Colors.red),
      // );
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double width = size.width;
    final double height = size.height;

    return Scaffold(
      body: Column(
        children: [
          Container(
            width: width,
            height: height / 4,
            decoration: BoxDecoration(
              color: buttonColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(top: height * 0.03),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: width * 0.05, vertical: height * 0.03),
                    child: Text(
                      "Events",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: white,
                        fontSize: (width < 550) ? 20 : 24,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search events...',
                        hintStyle: const TextStyle(color: Colors.white),
                        prefixIcon:
                            const Icon(Icons.search, color: Colors.white),
                        filled: true,
                        fillColor: Colors.white12,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // List of Events
          Expanded(
            child: Consumer<EventsProvider>(
              builder: (context, provider, child) {
                final events = provider.events;

                if (events.isEmpty) {
                  return const Center(child: Text('No events found.'));
                }

                return Padding(
                  padding: EdgeInsets.only(top: height * 0.01),
                  child: ListView.builder(
                    controller: widget.scrollController,
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.only(bottom: height * 0.08),
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      final data = events[index].data() as Map<String, dynamic>;
                      final eventId = events[index].id;
                      final eventName = data['eventName'];
                      final description = data['eventDescription'];
                      final eventDate = DateFormat('yyyy-MM-dd')
                          .format(data['eventDate'].toDate());

                      return Padding(
                        padding: const EdgeInsets.symmetric(),
                        child: Slidable(
                          endActionPane: ActionPane(
                            motion: const StretchMotion(),
                            children: [
                              CustomSlidableAction(
                                backgroundColor: Colors.transparent,
                                onPressed: (context) =>
                                    _deleteEvent(eventId, context),
                                child: Icon(Icons.delete,
                                    color: Colors.red,
                                    size: (width < 550) ? 30 : 40),
                              ),
                            ],
                          ),
                          child: Card(
                            color: tileColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        EventDetailScreen(eventId: eventId),
                                  ),
                                );
                              },
                              title: Text(
                                eventName,
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold, color: white),
                              ),
                              subtitle: Text(
                                'Date: $eventDate\n$description',
                                style: GoogleFonts.poppins(color: white),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: buttonColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddEventScreen()),
          );
        },
        child: Icon(Icons.add, color: white),
      ),
    );
  }
}
