import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mycampuspte/utils/theme/theme.dart';
import 'package:mycampuspte/views/admin/detailed_event_screen.dart';
import 'package:provider/provider.dart';
import 'package:mycampuspte/providers/events_provider.dart';

class AllEventsUserside extends StatefulWidget {
  final ScrollController scrollController;
  const AllEventsUserside({super.key, required this.scrollController});

  @override
  State<AllEventsUserside> createState() => _AllEventsUsersideState();
}

class _AllEventsUsersideState extends State<AllEventsUserside> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      final provider = Provider.of<EventsProvider>(context, listen: false);
      provider.updateSearchQuery(_searchController.text);
    });
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
          // Header and Search
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
              padding: EdgeInsets.only(top: height * 0.02),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
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
                  // Search Field
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                    child: TextField(
                      style: GoogleFonts.poppins(color: white),
                      controller: _searchController,
                      decoration: InputDecoration(
                        // counterStyle: GoogleFonts.poppins(color: white),

                        hintText: 'Search events...',
                        hintStyle: TextStyle(
                          color: Colors.white,
                        ),
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

          // Event List
          Expanded(
            child: Consumer<EventsProvider>(
              builder: (context, provider, child) {
                final events = provider.events;

                if (events.isEmpty) {
                  return const Center(child: Text('No events found.'));
                }

                return ListView.builder(
                  controller: widget.scrollController,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(
                    top: height * 0.01,
                    bottom: height * 0.08,
                  ),
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final data = events[index].data() as Map<String, dynamic>;
                    final eventId = events[index].id;
                    final eventName = data['eventName'];
                    final eventDate = DateFormat('yyyy-MM-dd')
                        .format(data['eventDate'].toDate());
                    final description = data['eventDescription'];

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 6.0),
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
                              fontWeight: FontWeight.bold,
                              color: white,
                            ),
                          ),
                          subtitle: Text(
                            'Date: $eventDate\n$description',
                            style: GoogleFonts.poppins(color: white),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
