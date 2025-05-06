import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mycampuspte/auth/controller.dart';
import 'package:mycampuspte/providers/events_provider.dart';
import 'package:mycampuspte/providers/faq_provider.dart';
import 'package:mycampuspte/providers/mails_provider.dart';
import 'package:mycampuspte/providers/navbar_provider.dart';
import 'package:mycampuspte/splash_screen/splash_screen.dart';
import 'package:mycampuspte/utils/theme/theme.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Get.put(AuthController());
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => MyAuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => EventsProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => FaqProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => BottomNavVisibilityProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => MailProvider(),
        )
        // ChangeNotifierProvider(
        //   create: (context) => ThemeProvider(),
        // )
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      // theme: ThemeData(
      //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      //   useMaterial3: true,
      // ),
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      // theme: Provider.of<ThemeProvider>(context).themeData,
      home: SplashScreen(),
    );
  }
}
