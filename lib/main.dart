import 'package:attendance/page/checkin/view.dart';
import 'package:attendance/static_routes.dart';
import 'package:flutter/material.dart';
import 'package:attendance/page/index.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Attendance',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: StaticRoutes.splashScreen,
      routes: {
        StaticRoutes.splashScreen: (_) => const SplashScreen(),
        StaticRoutes.home: (_) => const HomeScreen(),
        StaticRoutes.addOffice: (_) => const AddOfficeScreen(),
        StaticRoutes.mapOffice: (_) => const MapOfficeScreen(),
        StaticRoutes.checkin: (_) => const CheckInScreen(),
      },
    );
  }
}
