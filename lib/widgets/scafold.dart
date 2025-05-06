import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ScaffoldWithBottomNav extends StatefulWidget {
  final Widget child;
  final int currentIndex;

  const ScaffoldWithBottomNav({
    super.key,
    required this.child,
    required this.currentIndex,
  });

  @override
  State<ScaffoldWithBottomNav> createState() => _ScaffoldWithBottomNavState();
}

class _ScaffoldWithBottomNavState extends State<ScaffoldWithBottomNav> {
  final ScrollController _scrollController = ScrollController();
  bool _showBottomNav = true;
  bool _isScrollingDown = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.userScrollDirection ==
            ScrollDirection.reverse &&
        !_isScrollingDown) {
      setState(() {
        _isScrollingDown = true;
        _showBottomNav = false;
      });
    } else if (_scrollController.position.userScrollDirection ==
            ScrollDirection.forward &&
        _isScrollingDown) {
      setState(() {
        _isScrollingDown = false;
        _showBottomNav = true;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: (_) => true,
        child: widget.child,
      ),
      bottomNavigationBar: AnimatedSlide(
        duration: Duration(milliseconds: 300),
        offset: _showBottomNav ? Offset(0, 0) : Offset(0, 1),
        child: BottomNavigationBar(
          currentIndex: widget.currentIndex,
          onTap: (index) {
            // Handle page navigation
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.mail), label: 'Mails'),
            BottomNavigationBarItem(icon: Icon(Icons.help), label: 'FAQs'),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: 'Settings'),
          ],
        ),
      ),
    );
  }
}
