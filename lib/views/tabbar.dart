import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mycampuspte/Models/user_model.dart';
import 'package:mycampuspte/auth/controller.dart';
import 'package:mycampuspte/auth/login.dart';
import 'package:mycampuspte/providers/navbar_provider.dart';
import 'package:mycampuspte/utils/theme/theme.dart';
import 'package:mycampuspte/views/userside/all_events_userside.dart';
import 'package:mycampuspte/views/userside/contactus.dart';
import 'package:mycampuspte/views/userside/home.dart';
import 'package:mycampuspte/views/userside/profile.dart';
import 'package:mycampuspte/views/userside/user_profile.dart';
import 'package:provider/provider.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

class Tabbar extends StatefulWidget {
  const Tabbar({super.key});

  @override
  State<Tabbar> createState() => _TabbarState();
}

class _TabbarState extends State<Tabbar> {
  final PageController controller = PageController(initialPage: 0);
  bool isBottomNavBarVisible = true; // Track the visibility of the bottom nav
  ScrollController scrollController =
      ScrollController(); // Custom scroll controller
  int selectedIndex = 0;
  bool toggleDarkMode = false;
  // UserModel? user;
  // bool isLoadingUser = true;
  @override
  void initState() {
    super.initState();
    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final provider =
        Provider.of<BottomNavVisibilityProvider>(context, listen: false);

    if (scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      provider.hide(); // Hide nav bar when scrolling down
    } else if (scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      provider.show(); // Show nav bar when scrolling up
    }
  }

  // void fetchUserModel() async {
  //   final authProvider = Provider.of<MyAuthProvider>(context, listen: false);
  //   final fetchedUser = await authProvider.userModel;
  //   setState(() {
  //     user = fetchedUser;
  //     isLoadingUser = false;
  //   });
  // }
  @override
  void dispose() {
    scrollController.removeListener(_onScroll); // Clean up the listener
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<MyAuthProvider>(context);
    var size = MediaQuery.of(context).size;
    final double width = size.width;
    // if (isLoadingUser) {
    //   return const Scaffold(
    //     body: Center(
    //         child: CircularProgressIndicator(
    //       color: white,
    //     )),
    //   );
    // }
    return SafeArea(
      child: Scaffold(
          // appBar: AppBar(
          //     // backgroundColor: bgColor,
          //     // iconTheme: IconThemeData(color: black),
          //     ),

          // Drawer
          // drawer: FutureBuilder<UserModel?>(
          //   future: authProvider.userModel, // Fetch user model asynchronously
          //   builder: (context, snapshot) {
          //     if (snapshot.connectionState == ConnectionState.waiting) {
          //       return Drawer(
          //         child: Center(child: CircularProgressIndicator()),
          //       ); // Show loading indicator while fetching data
          //     }

          //     final userModel = snapshot.data;

          //     return _buildDrawer(width, context, userModel, authProvider);
          //   },
          // ),

          // Body
          body: PageView(
            controller: controller,
            children: [
              Home(
                scrollController: scrollController,
              ),
              AllEventsUserside(
                scrollController: scrollController,
              ),
              // Faq(),
              UserProfile()
            ],
            onPageChanged: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
          ),
          bottomNavigationBar: Consumer<BottomNavVisibilityProvider>(
              builder: (context, provider, child) {
            return provider.isVisible
                ? StylishBottomBar(
                    backgroundColor: bottomNavBackColor,
                    option: BubbleBarOptions(
                      barStyle: BubbleBarStyle.horizontal,
                      bubbleFillStyle: BubbleFillStyle.fill,
                      opacity: 0.3,
                    ),
                    items: [
                      BottomBarItem(
                        icon: const Icon(Icons.home),
                        title: Text(
                          'Home',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: (width < 550) ? 10 : 12,
                          ),
                        ),
                        selectedColor: white,
                        backgroundColor: white,
                        unSelectedColor: white,
                      ),
                      BottomBarItem(
                        icon: const Icon(Icons.event),
                        title: Text(
                          'Events',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: (width < 550) ? 10 : 12,
                          ),
                        ),
                        selectedColor: white,
                        backgroundColor: white,
                        unSelectedColor: white,
                      ),
                      BottomBarItem(
                        icon: const Icon(Icons.person),
                        title: Text(
                          'Profile',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: (width < 550) ? 10 : 12,
                          ),
                        ),
                        backgroundColor: white,
                        unSelectedColor: white,
                      ),
                    ],
                    currentIndex: selectedIndex,
                    onTap: (index) {
                      setState(() {
                        selectedIndex = index;
                      });
                      controller.jumpToPage(index);
                    },
                  )
                : SizedBox.shrink();
          })),
    );
  }

  Drawer _buildDrawer(double width, BuildContext context, UserModel? userModel,
      MyAuthProvider authProvider) {
    String fullName = userModel != null
        ? "${userModel.firstName} ${userModel.lastName}"
        : "Loading...";

    return Drawer(
      // backgroundColor: bgColor,

      child: Column(
        children: [
          // Drawer Header with User Name
          DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: (width < 550) ? 30 : 40,
                  backgroundColor: buttonColor,
                  child: Icon(
                    Icons.person,
                    size: 30,
                    color: white,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    textAlign: TextAlign.center,
                    fullName,
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: (width < 550) ? 12 : 16),
                  ),
                )
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.02),
            child: Column(
              children: [
                // Toggle mode
                // ListTile(
                //   leading: Icon(Icons.dark_mode),
                //   title: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Text(
                //         "Dark Mode",
                //         style: GoogleFonts.poppins(
                //             fontWeight: FontWeight.bold,
                //             fontSize: (width < 550) ? 14 : 18),
                //       ),
                //       Consumer<ThemeProvider>(
                //           builder: (context, themeProvider, child) {
                //         bool isDark = themeProvider.themeData.brightness ==
                //             Brightness.dark;
                //         return Switch(
                //           activeColor: Colors.green,
                //           value: isDark,
                //           onChanged: (value) {
                //             Provider.of<ThemeProvider>(context, listen: false)
                //                 .toggleTheme();
                //           },
                //         );
                //       }),
                //     ],
                //   ),
                // ),
                // Profile
                ListTile(
                  leading: Icon(
                    Icons.person,
                    // color: black,
                  ),
                  title: Text(
                    "Profile",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: (width < 550) ? 14 : 18,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    if (userModel != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => Profile(user: userModel),
                        ),
                      );
                    }
                  },
                ),

                // Contact Us
                ListTile(
                  leading: Icon(
                    Icons.email,
                    // color: black,
                  ),
                  title: Text(
                    "Contact Us",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: (width < 550) ? 14 : 18,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const Contactus()),
                    );
                  },
                ),

                // Sign Out
                ListTile(
                  leading: Icon(
                    Icons.logout,
                    // color: black,
                  ),
                  title: Text(
                    "Sign Out",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: (width < 550) ? 14 : 18,
                    ),
                  ),
                  onTap: () async {
                    await authProvider.signOut();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const LoginScreen()), // Replace with your LoginPage widget
                      (Route<dynamic> route) =>
                          false, // This will remove all the routes from the stack
                    );
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
