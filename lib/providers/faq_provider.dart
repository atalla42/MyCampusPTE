import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FaqProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<QueryDocumentSnapshot> _allFaqs = [];
  List<QueryDocumentSnapshot> _filteredFaqs = [];

  String _searchQuery = '';

  List<QueryDocumentSnapshot> get faqs => _filteredFaqs;

  FaqProvider() {
    _listenToFaqs();
  }

  void _listenToFaqs() {
    _firestore
        .collection('faqs')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((snapshot) {
      _allFaqs = snapshot.docs;
      _filterFaqs();
    });
  }

  void updateSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
    _filterFaqs();
  }

  void _filterFaqs() {
    if (_searchQuery.isEmpty) {
      _filteredFaqs = _allFaqs;
    } else {
      _filteredFaqs = _allFaqs.where((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final question = data['question']?.toLowerCase() ?? '';
        final answer = data['answer']?.toLowerCase() ?? '';
        return question.contains(_searchQuery) || answer.contains(_searchQuery);
      }).toList();
    }
    notifyListeners();
  }

  Future<void> deleteFaq(String faqId, BuildContext context) async {
    try {
      await _firestore.collection('faqs').doc(faqId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Deleted Successfully')),
      );
    } catch (e) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Error deleting FAQ: $e')),
      // );
    }
  }
}
