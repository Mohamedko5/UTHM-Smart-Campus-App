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
    'icon': Icons.map_rounded,
    'label': 'Map',
    'route': '/map',
  },
  {
    'icon': Icons.shopping_bag_rounded,
    'label': 'Store',
    'route': '/shop',
  },
];

void navigateToMainTab(BuildContext context, int index, String currentRoute) {
  final targetRoute = kMainNavItems[index]['route'] as String;
  if (targetRoute == currentRoute) {
    return;
  }

  Navigator.pushReplacementNamed(context, targetRoute);
}
