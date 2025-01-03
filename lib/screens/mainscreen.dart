import 'package:flutter/material.dart';
import 'package:travelmate/screens/community/community.dart';
import 'package:travelmate/screens/destination/destination.dart';
import 'package:travelmate/screens/home/home.dart';
import 'package:travelmate/screens/notification/notification.dart';
import 'package:travelmate/screens/profile/profile.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // List of screens for the navigation bar
  final List<Widget> _pages = [
    const Home(),
    const Destination(),
    const CommunityScreen(),
    const NotificationScreen(),
    const Profile(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: navigationBar(),
    );
  }

  BottomNavigationBar navigationBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      items: [
        BottomNavigationBarItem(
          icon: Image.asset("assets/images/home/nav-icons/home.png"),
          activeIcon:
              Image.asset("assets/images/home/nav-icons/home-active.png"),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Image.asset("assets/images/home/nav-icons/destination.png"),
          activeIcon: Image.asset(
              "assets/images/home/nav-icons/destination-active.png"),
          label: 'Destinations',
        ),
        BottomNavigationBarItem(
          icon: Image.asset("assets/images/home/nav-icons/community.png"),
          activeIcon:
              Image.asset("assets/images/home/nav-icons/community-active.png"),
          label: 'Community',
        ),
        BottomNavigationBarItem(
          icon: Image.asset("assets/images/home/nav-icons/notification.png"),
          activeIcon: Image.asset(
              "assets/images/home/nav-icons/notification-active.png"),
          label: 'Notifications',
        ),
        BottomNavigationBarItem(
          icon: Image.asset("assets/images/home/nav-icons/profile.png"),
          activeIcon:
              Image.asset("assets/images/home/nav-icons/profile-active.png"),
          label: 'Profile',
        ),
      ],
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      backgroundColor: Colors.white,
      elevation: 10,
    );
  }
}
