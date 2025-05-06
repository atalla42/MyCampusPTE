import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventsProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<QueryDocumentSnapshot> _allEvents = [];
  List<QueryDocumentSnapshot> _filteredEvents = [];

  String _searchQuery = '';

  List<QueryDocumentSnapshot> get events => _filteredEvents;

  EventsProvider() {
    _listenToEvents();
  }

  void _listenToEvents() {
    _firestore
        .collection('events')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((snapshot) {
      _allEvents = snapshot.docs;
      _filterEvents(); // Re-apply search filter when new data comes
    });
  }

  void updateSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
    _filterEvents();
  }

  void _filterEvents() {
    if (_searchQuery.isEmpty) {
      _filteredEvents = _allEvents;
    } else {
      _filteredEvents = _allEvents.where((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final title = data['eventName'].toString().toLowerCase();
        final description = data['eventDescription'].toString().toLowerCase();
        final eventDate = data['eventDate'].toDate();
        final dateString =
            DateFormat('yyyy-MM-dd').format(eventDate).toLowerCase();
        return title.contains(_searchQuery) ||
            description.contains(_searchQuery) ||
            dateString.contains(_searchQuery);
      }).toList();
    }
    notifyListeners();
  }
}
