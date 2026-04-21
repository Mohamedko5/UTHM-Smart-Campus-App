import 'package:flutter/material.dart';

const List<Map<String, dynamic>> kMainNavItems = [
  {
    'icon': Icons.home_rounded,
    'label': 'Home',
    'route': '/dashboard',
  },
  {
    'icon': Icons.calendar_today_rounded,
    'label': 'Schedule',
    'route': '/timetable',
  },
  {
    'icon': Icons.notifications_rounded,
    'label': 'Alerts',
    'route': '/notifications',
  },
  {
    'icon': Icons.person_rounded,
    'label': 'Profile',
    'route': '/profile',
  },
];

void navigateToMainTab(BuildContext context, int index, String currentRoute) {
  final targetRoute = kMainNavItems[index]['route'] as String;
  if (targetRoute == currentRoute) {
    return;
  }

  Navigator.pushReplacementNamed(context, targetRoute);
}
