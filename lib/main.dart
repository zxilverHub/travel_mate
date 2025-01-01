import 'package:flutter/material.dart';
import 'package:travelmate/db/travelmatedb.dart';
import 'package:travelmate/screens/getstarted.dart';
import 'package:travelmate/screens/mainscreen.dart';
import 'package:travelmate/screens/registration/signup.dart';
import 'package:travelmate/theme/apptheme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    TravelMateDb.openDb();
    return MaterialApp(
      theme: appTheme,
      debugShowCheckedModeBanner: false,
      // home: GetStarted(),
      home: SignUpPage(),
      // home: MainScreen(),
    );
  }
}
