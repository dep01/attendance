import 'package:attendance/page/home/office.dart';
import 'package:flutter/material.dart';
import 'attendance.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int tabIndex = 0;
  List<Widget> screens = [const AttendanceScreen(), const OfficeScreen()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: tabIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: tabIndex,
        onTap: (int index) {
          setState(() {
            tabIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.timelapse), label: "Check-In"),
          BottomNavigationBarItem(
              icon: Icon(Icons.location_city_outlined), label: "Office"),
        ],
      ),
    );
  }
}
