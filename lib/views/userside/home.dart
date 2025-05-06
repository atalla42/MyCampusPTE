
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mycampuspte/utils/theme/theme.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class Home extends StatefulWidget {
  final ScrollController scrollController;
  const Home({super.key, required this.scrollController});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Appointment> _appointments = [];
  List<Appointment> _selectedMonthEvents = [];
  DateTime? _currentMonth;

  @override
  void initState() {
    super.initState();
    _fetchEvents(DateTime.now()); // Fetch current month events on load
  }

  // Function to fetch events from Firestore
  Future<void> _fetchEvents(DateTime date) async {
    final newMonth = DateTime(date.year, date.month);
    if (_currentMonth != null &&
        _currentMonth!.year == newMonth.year &&
        _currentMonth!.month == newMonth.month) {
      return; // Already fetched this month
    }

    _currentMonth = newMonth;

    final startOfMonth = DateTime(date.year, date.month, 1);
    final endOfMonth = DateTime(date.year, date.month + 1, 0);

    final snapshot = await FirebaseFirestore.instance
        .collection('events')
        .where('eventDate', isGreaterThanOrEqualTo: startOfMonth)
        .where('eventDate', isLessThanOrEqualTo: endOfMonth)
        .get();

    final fetchedEvents = snapshot.docs.map((doc) {
      final event = doc.data();
      final eventDate = (event['eventDate'] as Timestamp).toDate();
      return Appointment(
        startTime: eventDate,
        endTime: eventDate.add(Duration(hours: 1)),
        subject: event['eventName'],
        notes: event['eventDescription'],
        color: Colors.blue,
      );
    }).toList();

    setState(() {
      _appointments = fetchedEvents;
      _selectedMonthEvents = fetchedEvents.where((event) {
        return event.startTime.year == date.year &&
            event.startTime.month == date.month;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    return Scaffold(
      body: SingleChildScrollView(
        controller: widget.scrollController,
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            //
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: height * 0.03,
              ),
              child: Text(
                "My Campus PTE",
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: height * 0.5,
              child: SfCalendar(
                // backgroundColor: buttonColor,
                viewHeaderStyle: ViewHeaderStyle(),
                view: CalendarView.month,
                firstDayOfWeek: 1,
                showDatePickerButton: true,
                dataSource: EventDataSource(_appointments),
                monthCellBuilder:
                    (BuildContext context, MonthCellDetails details) {
                  final DateTime date = details.date;
                  bool hasEvents = _appointments
                      .any((event) => isSameDate(event.startTime, date));

                  return Container(
                    decoration: BoxDecoration(
                      color: hasEvents ? Colors.grey : Colors.transparent,
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Center(
                      child: Text(
                        DateFormat('d').format(date),
                        style: TextStyle(
                            // color: hasEvents ? Colors.white : Colors.black,
                            ),
                      ),
                    ),
                  );
                },
                onViewChanged: (viewChangedDetails) {
                  // Use middle visible date to detect current month accurately
                  final midIndex =
                      (viewChangedDetails.visibleDates.length / 2).floor();
                  final midDate = viewChangedDetails.visibleDates[midIndex];
                  _fetchEvents(midDate);
                },
              ),
            ),
            SizedBox(
              height: 10,
            ),
            // Textfield
            // Padding(
            //   padding: EdgeInsets.symmetric(
            //       vertical: height * 0.01, horizontal: width * 0.05),
            //   child: TextField(
            //     decoration: InputDecoration(
            //         hintText: "Seach Event", border: OutlineInputBorder()),
            //   ),
            // ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: height * 0.01),
              child: Text(
                textAlign: TextAlign.center,
                // "Upcoming Events",
                _selectedMonthEvents.isEmpty
                    ? "No Upcoming Events this Month"
                    : "Upcoming Events",
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: (width < 550) ? 16 : 18),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: height * 0.01),
              child: ListView.builder(
                // controller: widget.scrollController,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _selectedMonthEvents.length,
                itemBuilder: (context, index) {
                  final event = _selectedMonthEvents[index];

                  return Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: width * 0.01, vertical: height * 0.005),
                    child: ListTile(
                      // onTap: () {
                      //   Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //         builder: (context) => EventDetailScreen(
                      //             eventId: event.id.toString()),
                      //       ));
                      // },
                      leading: Icon(
                        Icons.event,
                        color: white,
                      ),
                      tileColor: tileColor,
                      title: Text(
                        event.subject,
                        style: GoogleFonts.poppins(color: white),
                      ),
                      subtitle: Text(
                        event.notes ?? '',
                        maxLines: 3,
                        style: GoogleFonts.poppins(color: white),
                      ),
                      trailing: Text(
                        DateFormat('yyyy-MM-dd').format(event.startTime),
                        style: GoogleFonts.poppins(color: white),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to compare dates
  bool isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}

class EventDataSource extends CalendarDataSource {
  EventDataSource(List<Appointment> appointments) {
    this.appointments = appointments;
  }
}
